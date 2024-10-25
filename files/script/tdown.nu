#!/usr/bin/env nu

export-env {
  $env.TELEGRAM_DIR = ($env.HOME | path join Telegram)
  $env.TELEGRAM_CHAT_DIR = ($env.TELEGRAM_DIR | path join chats)
  $env.TELEGRAM_CHAT_FILE = ($env.TELEGRAM_DIR | path join chats.json)
}

export def 'install' [] {
  https download https://github.com/iyear/tdl/releases/download/v0.17.5/tdl_Linux_64bit.tar.gz
  extract tar tdl_Linux_64bit.tar.gz -d tdl_linux
  mv tdl_linux/tdl $env.USR_LOCAL_BIN
  rm -rf tdl_linux

  mkdir $env.TELEGRAM_DIR
  mkdir $env.TELEGRAM_CHAT_DIR
}

export def 'chat ls' [] {
  tdl chat ls -o json | from json
}

export def 'chat save' [] {
  tdl chat ls -o json | save --force $env.TELEGRAM_CHAT_FILE
}

def 'chats' [] {
  open $env.TELEGRAM_CHAT_FILE | select id visible_name | rename value description
}

export def 'chat export' [id: string@chats] {
  let output = ($env.TELEGRAM_CHAT_DIR | path join $"($id).json")
  tdl chat export --chat $id --output $output --filter "Media.Size < 100*1024*1024"
}

def 'files' [] {
  ls -s $env.TELEGRAM_CHAT_DIR | where type == file | get name | split column '.' name | get name
}

export def 'download' [id: string@files] {
  let dir = ($env.TELEGRAM_CHAT_DIR | path join $id)
  let file = ($env.TELEGRAM_CHAT_DIR | path join $"($id).json")
  tdl download --dir $dir --file $file --continue
}
