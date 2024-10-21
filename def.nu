
def seed [] {
  cat /dev/urandom | tr -dc '0-9A-F' | head -c 64
}

export def git_clone [repo: string, path: string, tag?: string] {
  if ($path | path exists) {
    git -C $path pull
  } else {
    git clone $repo $path
  }
  if ($tag | is-not-empty) {
    git -C $path switch $tag
  }
}

export def --env with-wd [path: string, closure: closure] {
  let pwd = pwd
  cd $path
  do $closure
  cd $pwd
}

export def group-exists [group: string] {
  open /etc/group | str contains $group
}

export def user-exists [user: string] {
  open /etc/passwd | str contains $user
}

def 'chmod nu_base' [] {
  chmod '+x' sh/shell.sh
  chmod '+x' sh/install.sh

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
      (^$cmd --help | bat --plain --language help)
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

def harsql [] {
  harlequin -a mysql -h $env.SQL_HOST -p $env.SQL_PORT -U $env.SQL_USER --password $env.SQL_PASS --database $env.SQL_NAME
}

def redis_del [cmd: string] {
   redis DEL (redis KEYS $cmd | lines | str join ' ')
}

def pastes [input: string, --save(-s): string] {
  if $input =~ "https://pastes.dev" {
    let path = ($input | url parse | get path)
    let url = ("https://api.pastes.dev" + $path)
    let body = http get $url
    if ($save | is-empty) {
      $body
    } else {
      $body | save -f $save
    }
  } else {
    curl -s -T $input https://api.pastes.dev/post
  }
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

def "android debug restart" [] {
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

def --env mcd [name: string] {
  mkdir $name
  cd $name
}

def ghcli [] {
  with-wd /home/anthony/nushell/nu_base/cmd/ghcli {
    go run .
  }
}

def saup [] {
  sudo apt update
  sudo apt upgrade -y
}

def "external exists" [app: string] {
  which $app --all | where type == external | is-not-empty
}

def confirm [...prompt: string] {
  try {
    gum confirm ($prompt | str join ' ')
  } catch {
    return false
  }
  return true
}

def select-file [] {
  let preview = 'bat --plain --number --color=always {}'
  return (fd --type file | fzf --layout reverse --border --preview $preview | str trim)
}

def modf [...rest: string] {
  let file = (select-file)
  mods (open $file) ...$rest
}

def imods [] {
  mods --quiet Hola

  loop {
    mut input = ""
    mut file = ""
    try {
      print ""
      $input = (gum write)
      if ($input | str contains ".file") {
        $file = (select-file)
      }
      mut args = [
        --quiet
        --continue-last
        $input
      ]
      if ($file | is-not-empty) {
        $args = ($args | append (open $file))
      }
      mods ...$args
    } catch {
      break
    }
  }
}

def "bulk rename" [] {
  let preview = 'lsd --tree --color=always --icon=always {}'
  let base = (fd --type directory | fzf --layout reverse --border --preview $preview | str trim)
  let names = (ls -s $base | get name)
  let filename = mktemp --tmpdir --suffix .txt
  $names | save -f $filename
  hx $filename
  let news = (open $filename | lines)
  for  $it in ($names | enumerate) {
    let src = $it.item
    let dst = ($news | get $it.index)
    if $src == $dst {
      continue
    }
    mv -i ($base | path join $src) ($base | path join $dst)
  }
}

def gradlew-tasks [] {
  if ('gradlew' | path exists) {
    return (./gradlew tasks | rg ' - ' | parse '{value} - {description}')
  }
  return []
}

def gradlew [task: string@gradlew-tasks] {
  if ('gradlew' | path exists) {
    ./gradlew $task
  }
}

def "create camare" [] {
  # https://adityatelange.in/blog/android-phone-webcam-linux/
  sudo apt install v4l2loopback-dkms v4l2loopback-utils
  sudo modprobe -v v4l2loopback exclusive_caps=1 card_label="Android Webcam"
  let n = (ls /dev/video* | length)
  v4l2-ctl --list-devices
  scrcpy --no-video --no-playback --video-source=camera --camera-id=0 --camera-size=1920x1080 --v4l2-sink=/dev/video0
}

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

def gic [lang: string] {
  let output = 'clipboard.png'
  wl-paste | freeze --output $output --theme dracula --language $lang
  open $output | wl-copy
  rm $output
}
