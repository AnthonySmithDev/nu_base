
export-env {
  $env.TELEGRAM_DIR = ($env.HOME | path join Telegram)
  $env.TELEGRAM_CHAT_DIR = ($env.TELEGRAM_DIR | path join chats)
  $env.TELEGRAM_CHAT_FILE = ($env.TELEGRAM_DIR | path join chats.json)
}

export def setup [] {
  mkdir $env.TELEGRAM_DIR
  mkdir $env.TELEGRAM_CHAT_DIR
}

export def 'chat ls' [] {
  let chats = (tdl chat ls -o json | from json | select id type visible_name username?)
  $chats | save --force $env.TELEGRAM_CHAT_FILE
  return $chats
}

def chats [] {
  open $env.TELEGRAM_CHAT_FILE | select id visible_name
}

def chats_get_id [] {
  chats | rename value description
}

def chats_get_name_by_id [id: int] {
  chats | where id == $id | first | get visible_name
}

export def 'chat export' [id: int@chats_get_id, --last(-l): int] {
  let name = (chats_get_name_by_id $id | path-safe | str downcase)
  let filename = (gum input --header="Export name: " --value $name)
  let output = ($env.TELEGRAM_CHAT_DIR | path join $"($id) - ($filename).json")
  mut args = [
    --raw
    --chat $id
    --output $output
  ]
  if ($last | is-not-empty) {
    $args = ($args | append [--type last --input $last])
  }
  tdl chat export ...$args
}

export def "last chat msg" [chat_id: string@files_get_ids] {
  let filename = ($env.TELEGRAM_CHAT_DIR | path join last.json)
  tdl chat export -c $chat_id -o $filename -T last -i 1
  let last = (open $filename | get messages.0.id | into int)
  rm $filename
  return $last
}

export def 'chat update' [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TELEGRAM_CHAT_DIR | path join $"($chat_id) - ($chat_name)")
  let chat_file = ($env.TELEGRAM_CHAT_DIR | path join $"($chat_id) - ($chat_name).json")
  let temp_file = ($env.TELEGRAM_CHAT_DIR | path join temp.json)

  mut file = open $chat_file
  print "Open chat messages"

  let last_chat = (last chat msg $chat_id)
  let last_file = ($file | get messages.0.id | into int)
  print $"($last_chat) ($last_file)"

  if ($last_chat <= $last_file) {
    return
  }

  mut args = [
    --raw
    --chat $chat_id
    --output $temp_file
    --type id
    --input $"($last_file),($last_chat)"
  ]
  tdl chat export ...$args

  let temp = open $temp_file
  $file | upsert messages ($file.messages | prepend ($temp.messages)) | to json -r | save -f $chat_file
}

def files [] {
  ls -s $env.TELEGRAM_CHAT_DIR | where type == file | get name | split column '.' name | get name | parse "{id} - {name}"
}

def files_get_ids [] {
  files | rename value description
}

def files_get_name_by_id [id: string] {
  files | where id == $id | first | get name
}

export def download [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TELEGRAM_CHAT_DIR | path join $"($chat_id) - ($chat_name)")
  let chat_file = ($env.TELEGRAM_CHAT_DIR | path join $"($chat_id) - ($chat_name).json")

  mut total = 0
  print "Open file..."
  let messages = (open $chat_file | get messages)
  print "Open file OK"
  for msg in  $messages {
    let url = $"https://t.me/c/($chat_id)/($msg.id)"
    if ($msg.raw.Media?.Video? == true) {
      let size = ($msg.raw.Media?.Document?.Size | into int) / 1024 / 1024 | math round -p 2
      if $size > 500 {
        print $"Very large video size: ($url) ($size) MB"
        continue
      }
      let attributes = ($msg.raw.Media?.Document?.Attributes | where Duration != 0)
      if ($attributes | is-not-empty) {
        let duration = ($attributes | first | get Duration | math round)
        if $duration > 600 {
          print $"Very long video duration: ($url) ($duration | into duration --unit sec), size: ($size) MB"
          continue
        }
      }
    }
    let filename = ([$chat_id $msg.id $msg.file] | str join '_')
    let path = ($chat_dir | path join $filename)
    if ($path | path exists) {
      $total += 1
      continue
    }
    if $total > 0 {
      print $"total files that already exist: ($total)"
      $total = 0
    }
    let args = [download --continue --dir $chat_dir --url $url]
    try {
      tdl ...$args
    } catch { |err|
      print $"tdl ($args | str join ' ')"
      print $err.msg
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

export def dir [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TELEGRAM_CHAT_DIR | path join $"($chat_id) - ($chat_name)")
  try { nautilus $chat_dir }
}
