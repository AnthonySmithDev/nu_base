
def seed [] {
  cat /dev/urandom | tr -dc '0-9A-F' | head -c 64
}

def 'chmod nu_base' [] {
  chmod +x bash/shell.sh
  chmod +x bash/install.sh

  fd --type file --exec chmod 666 {}
  fd --type dir --exec chmod 755 {}
}

def trans [ ...text: string, --en(-e)] {
  let lang = if $en { ':en' } else { ':es' }
  docker run -it --rm soimort/translate-shell -b $lang ($text | str join ' ')
}

def 'nu gitignore list' [] {
  http get 'https://www.toptal.com/developers/gitignore/api/list?format=lines' | lines
}

def gitignore [lang: string@'nu gitignore list'] {
  http get $'https://www.toptal.com/developers/gitignore/api/($lang)' | save .gitignore
}

def help! [cmd?: string] {
  let pipe = $in

  if $pipe != null {
    $pipe | bat --plain --language help
    return
  }

  if $cmd != null {
    if (which bat | is-empty) {
      ^$cmd --help
    } else {
      ^$cmd --help | bat --plain --language help
    }
    return
  }
}

def json [] {
  to json | jless --mode line
}

def --env gfm [] {
  let path = gum file --file --directory
  if ($path | path type) == 'file' {
    hx $path
  } else if ($path | path type) == 'dir' {
    cd $path
  }
}


def --wrapped bg [...rest] {
  let cmd = $"($rest | str join ' ') > /dev/null 2>&1 &"
  bash -c $cmd
}

def build [] {
  nu ($env.NU_BASE_PATH | path join docker build.nu)
}

def ooc [] {
  OCO_AI_PROVIDER="ollama" ^opencommit
}

def "kill ps" [name = ""] {
  let list = (ps | where name =~ $name)
  let name = ($list | get name | gum filter --select-if-one ...$in)
  if ($name | is-empty) {
    return
  }
  let process = ($list | where name == $name)
  if ($process | is-empty) {
    return
  }
  kill --force ($process | first | get pid)
}

def "kill port" [port: int] {
  let list = (lsof -i :($port) | from ssv -m 1)
  if ($list | is-empty) {
    return
  }
  let name = ($list | get COMMAND | gum filter --select-if-one ...$in)
  if ($name | is-empty) {
    return
  }
  let process = ($list | where COMMAND == $name)
  if ($process | is-empty) {
    return
  }
  kill --force ($process | first | get PID | into int)
}

def --wrapped sail [...cmd: string] {
  let sail = ($env.PWD | path join vendor/bin/sail)
  if ($sail | path exists) {
    ^$sail ...$cmd
  } else {
    print "Sail not found"
  }
}

def sqlite [database: string] {
   litecli $database --auto-vertical-output
}

def mysql [] {
  let dsn = $'mysql://($env.SQL_USER):($env.SQL_PASS)@($env.SQL_HOST):($env.SQL_PORT)/($env.SQL_NAME)'
  print $dsn
  mycli $dsn --auto-vertical-output
}

def redis [...cmd: string] {
  let url = $"redis://:($env.REDIS_PASS)@($env.REDIS_HOST):($env.REDIS_PORT)"
  if ($cmd | is-empty) {
    iredis --url $url
  } else {
    iredis --url $url --raw ($cmd | str join ' ')
  }
}

def mongo [] {
  let dsn = $'mongodb://($env.MONGO_USER):($env.MONGO_PASS)@($env.MONGO_HOST):($env.MONGO_PORT)'
  print $dsn
  mongosh --quiet $dsn
}

def harsql [] {
  harlequin -a mysql -h $env.SQL_HOST -p $env.SQL_PORT -U $env.SQL_USER --password $env.SQL_PASS --database $env.SQL_NAME
}

def redis_del [cmd: string] {
   redis DEL (redis KEYS $cmd | lines | str join ' ')
}

def "paste new" [filename: string, --lang(-l): string = "plain"] {
  let url = (curl -s -T $filename -H $"Content-Type: text/($lang)" https://api.pastes.dev/post)
  return { url: $url }
}

def "paste view" [str: string] {
  let key = if ($str | str contains https://pastes.dev/) {
    $str | split row https://pastes.dev/ | last
  } else {
    $str
  }
  http get https://api.pastes.dev/($key)
}

def git_commit [...rest: string] {
  git commit -m ($rest | str join ' ')
}

def git_history [file: string] {
  let logs = (git log --pretty=format:"%h" -- $file | lines)
  for $commit in $logs {
    git show $"($commit):($file)" | bat -l go
  }
}

def "android debug start" [] {
  watch . --glob=**/*.kt {||
    sh gradlew assembleDebug
    sh gradlew installDebug
    adb shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n com.example.myapplication/.MainActivity
  }
}

def "andorid debug restart" [] {
  watch . --glob=**/*.kt {||
    sh gradlew assembleDebug
    adb install -r app/build/outputs/apk/debug/app-debug.apk
    adb shell am force-stop com.example.myapplication
    adb shell am start -n com.example.myapplication/.MainActivity
  }
}

def __systemctl [] {
  [status start stop restart]
}

def su [systemctl: string@__systemctl] {
  systemctl --user $systemctl mouseless.service
}

def qmk-udev [] {
  sudo cp /home/anthony/qmk_firmware/util/udev/50-qmk.rules /etc/udev/rules.d/
}

def --env mcd [name: string] {
  mkdir $name
  cd $name
}
