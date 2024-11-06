
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

def ghcli [] {
  with-wd /home/anthony/nushell/nu_base/cmd/ghcli {
    go run .
  }
}

def saup [] {
  sudo apt update
  sudo apt upgrade -y
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

def modf [...rest] {
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

def 'adb x' [] {
  let port = gum input --header "PORT"
  adb connect $"192.168.0.120:($port)"
}

def 'zellij drop' [] {
  let choose = (zellij list-sessions | gum choose --no-limit | lines | parse '{name} {desc}')
  let active = ($choose | where desc !~ 'EXITED' | get name)
  let exited = ($choose | get name)

  for $session in $active {
    zellij kill-session $session
  }
  for $session in $exited {
    zellij delete-session --force $session
  }
}

def 'rfzf' [query: string = ''] {
  rm -f /tmp/rg-fzf-{r,f}
  let RG_PREFIX = "rg --column --line-number --no-heading --color=always --smart-case "
  let INITIAL_QUERY = "${*:-}"
  let args = [
    --ansi --disabled --query $"($query)"
    --bind $"start:reload:($RG_PREFIX) {q}"
    --bind $"change:reload:sleep 0.1; ($RG_PREFIX) {q} || true"
    --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
      echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
      echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"'
    --color "hl:-1:underline,hl+:-1:underline:reverse"
    --prompt '1. ripgrep> '
    --delimiter :
    --header 'CTRL-T: Switch between ripgrep/fzf'
    --preview 'bat --color=always {1} --highlight-line {2}'
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
    --bind 'enter:become(vim {1} +{2})'
  ]
  fzf ...$args
}

def lsix [] {
  let images = (fd -e png -e jpg -d 1 | lines)
  let isBig = (term size | get columns) > 110
  let isMany = ($images | length) > 6
  let grid = if ($isBig and $isMany) { 6 } else { 3 }
  timg --title --pixelation sixel --grid $grid ...$images
}
