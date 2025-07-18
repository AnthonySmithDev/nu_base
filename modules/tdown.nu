
export-env {
  $env.TDOWN_DIR = ($env.HOME | path join .tdown)
  $env.TDOWN_CHAT_DIR = ($env.TDOWN_DIR | path join chats)
  $env.TDOWN_CHAT_FILE = ($env.TDOWN_DIR | path join chats.json)
}

export def setup [] {
  mkdir $env.TDOWN_DIR
  mkdir $env.TDOWN_CHAT_DIR
}

def to-custom-name [] {
  iconv -f utf-8 -t ascii//translit | tr -cd '[:alnum:] ' | str downcase | split words | str join "_"
}

export def 'chat ls' [] {
  let chats = (
  tdl chat ls -o json | from json
  | select id type visible_name username?
  | upsert custom_name {|row| ($row.visible_name | to-custom-name)}
  )

  $chats | save --force $env.TDOWN_CHAT_FILE
  return $chats
}

def chats [] {
  open $env.TDOWN_CHAT_FILE | select id custom_name
}

def chats_get_id [] {
  chats | rename value description
}

def chats_get_name_by_id [id: int] {
  chats | where id == $id | first | get custom_name
}

export def 'chat export' [id: int@chats_get_id, --last(-l): int] {
  let name = chats_get_name_by_id $id
  let filename = (gum input --header="Export name: " --value $name)
  let output = ($env.TDOWN_CHAT_DIR | path join $"($id)_($filename).json")
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
  let filename = ($env.TDOWN_CHAT_DIR | path join last.json)
  tdl chat export -c $chat_id -o $filename -T last -i 1
  let last = (open $filename | get messages.0.id | into int)
  rm $filename
  return $last
}

export def 'chat update' [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TDOWN_CHAT_DIR | path join $"($chat_id)_($chat_name)")
  let chat_file = ($env.TDOWN_CHAT_DIR | path join $"($chat_id)_($chat_name).json")
  let temp_file = ($env.TDOWN_CHAT_DIR | path join temp.json)

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
  ls -s $env.TDOWN_CHAT_DIR | where type == file | get name | split column '.' name | get name | parse "{id}_{name}"
}

def files_get_ids [] {
  files | rename value description
}

def files_get_name_by_id [id: string] {
  files | where id == $id | first | get name
}

export def download [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TDOWN_CHAT_DIR | path join $"($chat_id)_($chat_name)")
  let chat_file = ($env.TDOWN_CHAT_DIR | path join $"($chat_id)_($chat_name).json")

  mut total = 0
  print "Open file..."
  let messages = (open $chat_file | get messages)
  print "Open file OK"
  for msg in  $messages {
    let url = $"https://t.me/c/($chat_id)/($msg.id)"
    if ($msg.raw.Media?.Video? == true) {
      let size = ($msg.raw.Media?.Document?.Size | into filesize)
      if $size > 100mb {
        print $"Very large video size: ($url) ($size)"
        continue
      }
      let attributes = ($msg.raw.Media?.Document?.Attributes | where Duration != 0)
      if ($attributes | is-not-empty) {
        let duration = ($attributes | first | get Duration | into duration --unit sec)
        if $duration > 10min {
          print $"Very long video duration: ($url) ($duration), size: ($size)"
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
      break
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

export def --env dir [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TDOWN_CHAT_DIR | path join $"($chat_id)_($chat_name)")
  cd  $chat_dir
}

export def nautilus [chat_id: string@files_get_ids] {
  let chat_name = files_get_name_by_id $chat_id
  let chat_dir = ($env.TDOWN_CHAT_DIR | path join $"($chat_id)_($chat_name)")
  try { nautilus $chat_dir }
}
