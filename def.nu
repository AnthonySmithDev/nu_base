
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

def "kill ps" [] {
  let name = (ps | get name | gum filter ...$in )
  if ($name | is-empty) {
    return
  }
  let process = (ps | where name == $name)
  if ($process | is-empty) {
    return
  }
  kill --force ($process | first | get pid)
}

def "kill port" [port: int] {
  sudo lsof -i $":($port)" | from ssv -m 1
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
   mycli --auto-vertical-output $dsn
}

def redis [...cmd: string] {
   let url = $"redis://:($env.REDIS_PASS)@($env.REDIS_HOST):($env.REDIS_PORT)"
   if ($cmd | is-not-empty) {
      iredis --url $url --raw ($cmd | str join ' ')
   } else {
      iredis --url $url
   }
}

def "sql_ide" [] {
   harlequin -a mysql -h $env.SQL_HOST -p $env.SQL_PORT -U $env.SQL_USER --password $env.SQL_PASS --database $env.SQL_NAME
}

def redis_del [cmd: string] {
   redis DEL (redis KEYS $cmd | lines | str join ' ')
}

def pastes [filename: string, --lang(-l): string = "plain"] {
  let url = (curl -s -T $filename -H $"Content-Type: text/($lang)" https://api.pastes.dev/post)
  return { url: $url }
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

def "sser" [] {
  sudo systemctl start evremap.service
}
