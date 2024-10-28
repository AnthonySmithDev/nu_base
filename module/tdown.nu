
export-env {
  $env.TELEGRAM_DIR = ($env.HOME | path join Telegram)
  $env.TELEGRAM_CHAT_DIR = ($env.TELEGRAM_DIR | path join chats)
  $env.TELEGRAM_CHAT_FILE = ($env.TELEGRAM_DIR | path join chats.json)
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

export def 'chat export' [id: int@chats_get_id --size: int = 200 ] {
  let name = (chats_get_name_by_id $id | path-safe)
  let filename = (gum input --header="Export name: " --value $name)
  let output = ($env.TELEGRAM_CHAT_DIR | path join $"($id) - ($filename).json")
  tdl chat export --chat $id --output $output --filter $"Media.Size < ($size)*1024*1024"
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

export def 'download' [id: string@files_get_ids] {
  let name = files_get_name_by_id $id
  let dir = ($env.TELEGRAM_CHAT_DIR | path join $"($id) - ($name)")
  let file = ($env.TELEGRAM_CHAT_DIR | path join $"($id) - ($name).json")
  tdl download --dir $dir --file $file --skip-same --continue
}
