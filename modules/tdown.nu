
export-env {
  $env.TDOWN_DIR = ($env.HOME | path join .tdown)
  $env.TDOWN_CHAT_PATH = ($env.TDOWN_DIR | path join chats.json)
  $env.TDOWN_EXPORT_PATH = ($env.TDOWN_DIR | path join export)
  $env.TDOWN_DOWNLOAD_PATH = ($env.TDOWN_DIR | path join download)
}

export def setup [] {
  mkdir $env.TDOWN_DIR
  mkdir $env.TDOWN_EXPORT_PATH
  mkdir $env.TDOWN_DOWNLOAD_PATH
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

  $chats | save --force $env.TDOWN_CHAT_PATH
  return $chats
}

def chats [] {
  open $env.TDOWN_CHAT_PATH | select id custom_name
}

def chats_get_id [] {
  chats | rename value description
}

def chats_get_name_by_id [id: int] {
  chats | where id == $id | first | get custom_name
}

def export-path [chat_id: int, name: string] {
  $env.TDOWN_EXPORT_PATH | path join $"($chat_id)_($name).json"
}

def download-path [chat_id: int, name: string] {
  $env.TDOWN_DOWNLOAD_PATH | path join $"($chat_id)_($name)"
}

def chat-select [] {
  open $env.TDOWN_CHAT_PATH
  | each {|row| $"(ansi green)($row.id)(ansi reset) _ ($row.visible_name)"}
  | to text | fzf --exact --ansi --height=40 | lines | parse "{id} _ {name}" | get id | into int
}

export def 'chat export' [...chat_ids: int@chats_get_id, --last(-l): int] {
  let ids = if ($chat_ids | is-empty) {
    chat-select
  } else {
    $chat_ids
  }
  for chat_id in $ids {
    let name = chats_get_name_by_id $chat_id
    let output = export-path $chat_id $name
    if ($output | path exists) {
      print $"Chat export alreay exist: ($chat_id) ($name)"
      return
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
}

def export-files [] {
  ls -s $env.TDOWN_EXPORT_PATH | where type == file | each {|row|
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

def export-select [] {
  let ids = (ls -s $env.TDOWN_EXPORT_PATH | where type == file | get name |  parse "{id}_{name}" | get id | into int)

  open $env.TDOWN_CHAT_PATH
  | where id in $ids
  | each {|row| $"(ansi green)($row.id)(ansi reset) _ ($row.visible_name)"}
  | to text | fzf --exact --ansi --height=20 | lines | parse "{id} _ {name}" | get id | into int
}

export def sum [...chat_ids: int@files_get_ids, --skip(-s)] {
  let chat_id = if ($chat_ids | is-empty) {
    export-select | first
  } else {
    $chat_ids | first
  }
  let chat_name = files_get_name_by_id $chat_id
  let export_path = export-path $chat_id $chat_name

  mut video_sizes = []
  mut image_sizes = []
  mut video_count = 0
  mut image_count = 0
  mut skipped_videos = 0
  mut skipped_images = 0

  for $message in (open $export_path | get messages) {
    if ($message.file | str ends-with ".mp4") {
      if not $message.raw.Media.Video {
        $skipped_videos += 1
        continue
      }
      let size = ($message.raw.Media.Document.Size | into filesize)
      if $skip and ($size > 100mb) {
        $skipped_videos += 1
        continue
      }
      let attribute = ($message.raw.Media.Document.Attributes | where Duration != 0 | first)
      let duration = ($attribute | get Duration | into duration --unit sec)
      if $skip and $duration > 10min {
        $skipped_videos += 1
        continue
      }
      let width = ($attribute | get W)
      let height = ($attribute | get H)
      let higher = if $width > $height { $width } else { $height }
      if $skip and ($higher < 720) {
        $skipped_videos += 1
        continue
      }
      $video_sizes ++= [$size]
      $video_count += 1
    } else if ($message.file | str ends-with ".jpg") {
      if $message.raw.Media.Photo? == null {
        $skipped_images += 1
        continue
      }
      let last_size = ($message.raw.Media.Photo.Sizes | last)
      let size = if ($last_size | get Sizes?) != null {
        $last_size | get Sizes | last
      } else {
        $last_size | get Size
      }
      let width = $last_size | get W?
      let height = $last_size | get H?
      if $skip and ($width != null and $height != null) {
        let higher = if $width > $height { $width } else { $height }
        if $higher < 720 {
          $skipped_images += 1
          continue
        }
      }
      $image_sizes ++= [($size | into filesize)]
      $image_count += 1
    }
  }

  {
    skip: {
      "images": $skipped_images,
      "videos": $skipped_videos,
      "total": ($skipped_videos + $skipped_images)
    }
    count: {
      "images": $image_count,
      "videos": $video_count,
      "total": ($video_count + $image_count)
    },
    sizes: {
      "images": ($image_sizes | math sum),
      "videos": ($video_sizes | math sum),
      "total": ($image_sizes | append $video_sizes | math sum)
    },
  }
}

export def download [
  ...chat_ids: int@files_get_ids,
  --max-size(-s): filesize = 100mb
  --max-dur(-d): duration = 10min
] {
  let chat_id = if ($chat_ids | is-empty) {
    export-select | first
  } else {
    $chat_ids | first
  }

  let chat_name = files_get_name_by_id $chat_id
  let export_path = export-path $chat_id $chat_name
  let download_path = download-path $chat_id $chat_name

  mut count_images = 0
  mut count_videos = 0
  mut low_images = 0
  mut low_videos = 0
  mut too_long = 0
  mut too_large = 0
  mut existing_images = 0
  mut existing_videos = 0

  print "Open file..."
  let messages = (open $export_path | get messages)
  print "Open file OK"

  mut urls = []
  
  for message in $messages {
    let url = $"https://t.me/c/($chat_id)/($message.id)"
    if ($message.raw.Media?.Photo? != null) {
      $count_images += 1
      let last_size = ($message.raw.Media.Photo.Sizes | last)
      let width = $last_size | get W?
      let height = $last_size | get H?
      if ($width != null and $height != null) {
        let higher = if $width > $height { $width } else { $height }
        if $higher < 720 {
          $low_images += 1
          continue
        }
      }
    }
    if ($message.raw.Media?.Video? == true) {
      $count_videos += 1
      let size = ($message.raw.Media?.Document?.Size | into filesize)
      if $size > $max_size {
        $too_large += 1
        continue
      }
      let attributes = ($message.raw.Media.Document.Attributes | where Duration != 0)
      if ($attributes | is-empty) {
        continue
      }
      let attribute = ($attributes | first)
      let duration = ($attribute | get Duration | into duration --unit sec)
      if $duration > $max_dur {
        $too_long += 1
        continue
      }
      let width = ($attribute | get W)
      let height = ($attribute | get H)
      let higher = if $width > $height { $width } else { $height }
      if $higher < 720 {
        $low_videos += 1
        continue
      }
    }
    let basename = ([$chat_id $message.id $message.file] | str join '_')
    let file_path = ($download_path | path join $basename)
    if ($file_path | path exists) {
      if ($message.raw.Media?.Photo? != null) {
        $existing_images += 1
      }
      if ($message.raw.Media?.Video? == true) {
        $existing_videos += 1
      }
      continue
    }
    $urls = ($urls | append $url)
  }

  let info = {
    exist: {
      "images": $existing_images
      "videos": $existing_videos
      "total": ($existing_images + $existing_videos)
    }
    count: {
      "images": $count_images
      "videos": $count_videos
      "total": ($count_images + $count_videos)
    }
    low: {
      "images": $low_images
      "videos": $low_videos
      "total": ($low_images + $low_videos)
    }
    video: {
      "long": $too_long
      "large": $too_large
    }
  }
  
  print ($info | table --expand)

  for url in $urls {
    let args = [download --continue --dir $download_path --url $url]
    tdl ...$args
    # print $"tdl ($args | str join ' ')"
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
