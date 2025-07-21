
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

export def 'chat export' [...chat_ids: int@chats_get_id, --last(-l): int] {
  for chat_id in $chat_ids {
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

export def download [chat_id: int@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let export_path = export-path $chat_id $chat_name
  let download_path = download-path $chat_id $chat_name

  mut already_exist = 0
  mut total_images = 0
  mut total_videos = 0
  mut low_resolution = 0
  mut too_long = 0
  mut too_large = 0
  
  print "Open file..."
  let messages = (open $export_path | get messages)
  print "Open file OK"
  
  for msg in $messages {
    let url = $"https://t.me/c/($chat_id)/($msg.id)"
    if ($msg.raw.Media?.Photo? != null) {
      $total_images += 1
    }
    if ($msg.raw.Media?.Video? == true) {
      $total_videos += 1
      let size = ($msg.raw.Media?.Document?.Size | into filesize)
      if $size > 100mb {
        $too_large += 1
        print $"Very large video size: ($url) ($size)"
        continue
      }
      let attributes = ($msg.raw.Media?.Document?.Attributes | where Duration != 0)
      if ($attributes | is-not-empty) {
        let duration = ($attributes | first | get Duration | into duration --unit sec)
        if $duration > 10min {
          $too_long += 1
          print $"Very long video duration: ($url) ($duration), size: ($size)"
          continue
        }
        let w = ($attributes | first | get W)
        let h = ($attributes | first | get H)
        let menor = if $w < $h { $w } else { $h }
        if $menor < 480 {
          $low_resolution += 1
          print $"Low resolution video detected: ($url) Resolution: ($w)x($h)"
          continue
        }
      }
    }
    let basename = ([$chat_id $msg.id $msg.file] | str join '_')
    let file_path = ($download_path | path join $basename)
    if ($file_path | path exists) {
      $already_exist += 1
      continue
    }
    if $already_exist > 0 {
      print $"total files that already exist: ($already_exist)"
    }
    let args = [download --continue --dir $download_path --url $url]
    try {
      tdl ...$args
    } catch { |err|
      print $"tdl ($args | str join ' ')"
      print $err.msg
      break
    }
  }
  
  {
    "Already exsits": $already_exist
    "Total images": $total_images
    "Total videos": $total_videos
    "Low resolution videos": $low_resolution
    "Too long videos (>10min)": $too_long
    "Too large videos (>100MB)": $too_large
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
