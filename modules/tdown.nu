
export-env {
  $env.TDOWN_DIR = ($env.HOME | path join .tdown)

  $env.TDOWN_CHAT_JSON_PATH = ($env.TDOWN_DIR | path join chats.json)
  $env.TDOWN_EXPORT_JSON_PATH = ($env.TDOWN_DIR | path join export.json)

  $env.TDOWN_EXPORT_DIR_PATH = ($env.TDOWN_DIR | path join export)
  $env.TDOWN_DOWNLOAD_DIR_PATH = ($env.TDOWN_DIR | path join download)
}

def to-custom-name [] {
  iconv -f utf-8 -t ascii//translit | tr -cd '[:alnum:] '
  | str downcase | split words | str join "_"
}

export def 'chat ls' [] {
  let chats = (
    tdl chat ls -o json | from json
    | select id type visible_name username?
    | upsert custom_name {|row| ($row.visible_name | to-custom-name)}
  )

  mkdir $env.TDOWN_DIR
  $chats | save --force $env.TDOWN_CHAT_JSON_PATH
  return $chats
}

def chats [] {
  open $env.TDOWN_CHAT_JSON_PATH
}

def chats_get_id [] {
  chats | select id visible_name | rename value description
}

def chat_find_by_id [id: int] {
  chats | where id == $id | first
}

def chats_get_name_by_id [id: int] {
  chat_find_by_id $id | get custom_name
}

def export-path [chat_id: int, name: string] {
  $env.TDOWN_EXPORT_DIR_PATH | path join $"($chat_id)_($name).json"
}

def download-path [chat_id: int, name: string] {
  $env.TDOWN_DOWNLOAD_DIR_PATH | path join $"($chat_id)_($name)"
}

def chat-select [] {
  open $env.TDOWN_CHAT_JSON_PATH
  | each {|row| $"(ansi green)($row.id)(ansi reset) _ ($row.visible_name)"}
  | to text | fzf --multi --exact --ansi --height=~25 --layout reverse --style full
  | lines | parse "{id} _ {name}" | get id | into int
}

export def 'chat export' [...chat_ids: int@chats_get_id, --last(-l): int, --force(-f)] {
  mkdir $env.TDOWN_EXPORT_DIR_PATH

  let select_ids = if ($chat_ids | is-empty) {
    chat-select
  } else {
    $chat_ids
  }
  for $chat_id in $select_ids {
    let name = chats_get_name_by_id $chat_id
    let output = export-path $chat_id $name
    if not $force and ($output | path exists) {
      print $"Chat export alreay exist: ($chat_id) ($name)"
      continue
    }
    mut args = [
      --raw
      --chat $chat_id
      --output $output
    ]
    if ($last | is-not-empty) {
      $args = ($args | append [--type last --input $last])
    }
    tdl chat export ...$args
  }
}

export def "last chat msg" [chat_id: int@files_get_ids] {
  let output = export-path $chat_id "last"
  tdl chat export -c $chat_id -o $output -T last -i 1
  let last = (open $output | get messages.0.id | into int)
  rm $output
  return $last
}

export def 'chat update' [chat_id: int@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let export_path = export-path $chat_id $chat_name
  let update_path = export-path $chat_id "update"

  mut export_content = open $export_path
  print "Open chat messages"

  let last_msg_in_chat = (last chat msg $chat_id)
  let last_msg_in_export = ($export_content | get messages.0.id | into int)
  print $"($last_msg_in_chat) ($last_msg_in_export)"

  if ($last_msg_in_chat <= $last_msg_in_export) {
    return
  }

  mut args = [
    --raw
    --chat $chat_id
    --output $update_path
    --type id
    --input $"($last_msg_in_export),($last_msg_in_chat)"
  ]
  tdl chat export ...$args

  let update_content = open $update_path
  $export_content | upsert messages ($export_content.messages | prepend ($update_content.messages)) | to json -r | save -f $export_path
  rm -rfp $update_path
}

def export-files [] {
  ls -s $env.TDOWN_EXPORT_DIR_PATH | where type == file | each {|row|
    let parse = ($row.name | split column '.' filename | get filename | parse "{id}_{name}" | first)
    {
      id: ($parse.id | into int)
      name: $parse.name
      size: $row.size
    }
  }
}

def files_get_ids [] {
  let completions = (export-files | sort-by size | each {|row|
    {
      value: $row.id
      description: $"($row.name), size:($row.size)"
    }
  })

  {
    options: {
      case_sensitive: false,
      completion_algorithm: substring,
      sort: false,
    },
    completions: $completions
  }
}

def files_get_name_by_id [id: int] {
  export-files | where id == $id | first | get name
}

export def export-ids [] {
  export-files | sort-by size | get id
}

export def export-select [] {
  let ids = open $env.TDOWN_CHAT_JSON_PATH | get id

  export-files | sort-by size
  | where id in $ids
  | each {|row| $"(ansi green)($row.id)(ansi reset) _ (chat_find_by_id $row.id | get visible_name) _ ($row.size)" }
  | to text | fzf --multi --exact --ansi --height=~25 --layout reverse --style full 
  | lines | parse "{id} _ {name}" | get id | into int
}

export def sum [...chat_ids: int@files_get_ids, --skip(-s)] {
  let select_ids = if ($chat_ids | is-empty) {
    export-select
  } else {
    $chat_ids
  }

  for $chat_id in $select_ids {
    let chat_name = files_get_name_by_id $chat_id
    let export_path = export-path $chat_id $chat_name

    mut videos_sizes = []
    mut videos_count = 0
    mut videos_skip = 0

    mut photos_sizes = []
    mut photos_count = 0
    mut photos_skip = 0

    for $message in (open $export_path | get messages) {
      if ($message.file | str ends-with ".mp4") {
        if not $message.raw.Media.Video {
          $videos_skip += 1
          continue
        }
        let size = ($message.raw.Media.Document.Size | into filesize)
        if $skip and ($size > 100mb) {
          $videos_skip += 1
          continue
        }
        let attributes = ($message.raw.Media.Document.Attributes)
        let attribute = if ($attributes | length) > 1 {
          $attributes | where Duration != null | first
        } else {
          $attributes | first
        }
        let duration = ($attribute | get Duration | into duration --unit sec)
        if $skip and $duration > 10min {
          $videos_skip += 1
          continue
        }
        let width = ($attribute | get W)
        let height = ($attribute | get H)
        let higher = if $width > $height { $width } else { $height }
        if $skip and ($higher < 720) {
          $videos_skip += 1
          continue
        }
        $videos_sizes ++= [$size]
        $videos_count += 1
      } else if ($message.file | str ends-with ".jpg") {
        if $message.raw.Media.Photo? == null {
          $photos_skip += 1
          continue
        }
        let last_size = ($message.raw.Media.Photo.Sizes | last)
        let size = if ($last_size | get Sizes?) != null {
          $last_size | get Sizes | last | into filesize
        } else {
          $last_size | get Size | into filesize
        }
        let width = $last_size | get W?
        let height = $last_size | get H?
        if $width != null and $height != null {
          let higher = if $width > $height { $width } else { $height }
          if $skip and ($higher < 720) {
            $photos_skip += 1
            continue
          }
        }
        $photos_sizes ++= [$size]
        $photos_count += 1
      }
    }

    let info = {
      chat_id: $chat_id
      photos: {
        "size": ($photos_sizes | math sum)
        "count": $photos_count
        "skip": $photos_skip
      }
      videos: {
        "size": ($videos_sizes | math sum)
        "count": $videos_count
        "skip": $videos_skip
      }
      total: {
        "size": ($photos_sizes | append $videos_sizes | math sum)
        "count": ($videos_count + $photos_count)
        "skip": ($videos_skip + $photos_skip)
      }
    }

    print ($info | table --expand)
  }
}

export def download [
  ...chat_ids: int@files_get_ids,
  --max-size(-s): filesize = 100mb
  --max-dur(-d): duration = 10min
  --min-res(-d): int = 720
  --all(-a)
] {
  mkdir $env.TDOWN_DOWNLOAD_DIR_PATH

  let select_ids = if $all {
    export-ids
  } else if ($chat_ids | is-empty) {
    export-select
  } else {
    $chat_ids
  }
  for $chat_id in $select_ids {
    let chat_name = files_get_name_by_id $chat_id
    let export_path = export-path $chat_id $chat_name
    let download_path = download-path $chat_id $chat_name
    mkdir $download_path

    mut photos_count = 0
    mut photos_exist = 0
    mut photos_low = 0
    mut photos_sizes = []

    mut videos_count = 0
    mut videos_exist = 0
    mut videos_low = 0
    mut videos_long = 0
    mut videos_large = 0
    mut videos_sizes = []

    let is_large = (ls $export_path | first | get size | $in > 5mb)
    if $is_large { print "Opening large file, please wait..." }
    let messages = (open $export_path | get messages)
    if $is_large { print "File loaded successfully" }
    if ($messages | is-empty) { continue }

    mut urls = []
  
    for message in $messages {
      let url = $"https://t.me/c/($chat_id)/($message.id)"
      if ($message.raw.Media?.Photo? != null) {
        $photos_count += 1
        let last_size = ($message.raw.Media.Photo.Sizes | last)
        let size = if ($last_size | get Sizes?) != null {
          $last_size | get Sizes | last | into filesize
        } else {
          $last_size | get Size | into filesize
        }
        let width = $last_size | get W?
        let height = $last_size | get H?
        if ($width != null and $height != null) {
          let higher = if $width > $height { $width } else { $height }
          if $higher < $min_res {
            $photos_low += 1
            continue
          }
        }
        $photos_sizes = ($photos_sizes | append $size)
      }
      if ($message.raw.Media?.Video? == true) {
        $videos_count += 1
        let size = ($message.raw.Media?.Document?.Size | into filesize)
        if $size > $max_size {
          $videos_large += 1
          continue
        }
        let attributes = ($message.raw.Media.Document.Attributes)
        let attribute = if ($attributes | length) > 1 {
          $attributes | where Duration != null | first
        } else {
          $attributes | first
        }
        let duration = ($attribute | get Duration | into duration --unit sec)
        if $duration > $max_dur {
          $videos_long += 1
          continue
        }
        let width = ($attribute | get W)
        let height = ($attribute | get H)
        let higher = if $width > $height { $width } else { $height }
        if $higher < $min_res {
          $videos_low += 1
          continue
        }
        $videos_sizes = ($videos_sizes | append $size)
      }
      let basename = ([$chat_id $message.id $message.file] | str join '_')
      let file_path = ($download_path | path join $basename)
      if ($file_path | path exists) {
        if ($message.raw.Media?.Photo? != null) {
          $photos_exist += 1
        }
        if ($message.raw.Media?.Video? == true) {
          $videos_exist += 1
        }
        continue
      }
      $urls = ($urls | append $url)
    }

    let info = {
      chat_id: $chat_id
      photos: {
        "size": ($photos_sizes | math sum)
        "count": $photos_count
        "exist": $photos_exist
        "low": $photos_low
        "skip": ($photos_exist + $photos_low)
      }
      videos: {
        "size": ($videos_sizes | math sum)
        "count": $videos_count
        "exist": $videos_exist
        "low": $videos_low
        "long": $videos_long
        "large": $videos_large
        "skip": ($videos_exist + $videos_low + $videos_long + $videos_large)
      }
      total: {
        "size": ($photos_sizes | append $videos_sizes | math sum)
        "count": ($photos_count + $videos_count)
        "exits": ($photos_exist + $videos_exist)
        "low": ($photos_low + $videos_low)
      }
    }
  
    print ($info | table --expand)

    for url in $urls {
      let args = [--continue --dir $download_path --url $url]
      try {
        tdl download ...$args
      } catch {
        # print $"tdl download ($args | str join ' ')"
        break
      }
    }
  }
}

export def videoinfo [filename: string] {
  let info = (mediainfo --Inform="Video;%Width% %Height%" $filename)
  let duration = (mediainfo --Output="General;%Duration%" $filename)
  if ($info | is-empty) { return {} }
  let size = ($info | parse "{w} {h}" | first)
  return {
    w: ($size.w | into int),
    h: ($size.h | into int),
    duration: ($duration | into int | $in / 1000 | math round),
  }
}

export def organize [dir: string] {
  let dir_base = if ($dir | is-empty) { $env.PWD } else { $dir }

  let dir_low = ($dir_base | path join low/)
  let dir_mid = ($dir_base | path join mid/)
  let dir_high = ($dir_base | path join high/)

  mkdir $dir_low
  mkdir $dir_mid
  mkdir $dir_high

  for filename in (ls $dir_base | where type == file | get name) {
    let info = videoinfo $filename
    if ($info | is-empty) { continue }
    if ($info.w < 720) and ($info.h < 720) {
      try { mv $filename $dir_low }
    }
    if ($info.w < 1080) and ($info.h < 1080) {
      try { mv $filename $dir_mid }
    }
    try { mv $filename $dir_high }

    print $"($filename) ($info.w) ($info.h)"
  }
}

export def --env dir [chat_id: int@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let download_path = download-path $chat_id $chat_name
  cd $download_path
}

export def nautilus [chat_id: int@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let download_path = download-path $chat_id $chat_name
  try { nautilus $download_path }
}
