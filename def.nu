
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
  sudo apt update -y;
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

def show [...rest: path] {
  if ($rest | is-empty) { return }
  bat --paging never --style header ...$rest
}

def showf [] {
  let filter = (gum filter --no-limit | lines)
  if ($filter | is-empty) { return }
  show ...$filter
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

def rn [glob: string] {
  let src_paths = (fd $glob | lines)
  if ($src_paths | length) == 0 {
    return
  }

  let indexs = ($src_paths | enumerate | get index)
  let tempfile = mktemp --tmpdir --suffix .txt
  $src_paths | save --force $tempfile

  hx $tempfile
  let dst_paths = (open $tempfile | lines)

  for index in $indexs {
    let src = ($src_paths | get $index)
    let dst = ($dst_paths | get $index)
    if $src == $dst { continue }
    mv -i $src $dst
  }
}

def 'rn dir' [] {
  let preview = 'eza --tree --color=always --icon=always {}'
  let dirname = (fd --type directory | fzf --layout reverse --border --preview $preview | str trim)

  let src_paths = (ls -s $dirname | get name)
  if ($src_paths | length) == 0 {
    return
  }

  let indexs = ($src_paths | enumerate | get index)
  let tempfile = mktemp --tmpdir --suffix .txt
  $src_paths | save --force $tempfile

  hx $tempfile
  let dst_paths = (open $tempfile | lines)

  for $index in $indexs {
    let src = ($src_paths | get $index)
    let dst = ($dst_paths | get $index)
    if $src == $dst { continue }
    mv -i ($dirname | path join $src) ($dirname | path join $dst)
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

def mdns-scan [resolve: string] {
  let columns = [type interface protocol 'service name' 'service type' 'host name' scope ip port info]
  avahi-browse -p -t -r $resolve | rg '=' | from csv --noheaders --separator ';' | rename ...$columns
}

def 'adbx c' [] {
  let devices = (mdns-scan _adb-tls-connect._tcp)
  if ($devices | length) > 0 {
    let device = ($devices | where protocol == IPv4 | first)
    adb connect $"($device.ip):($device.port)"
  }
}

def 'adbx p' [] {
  let nameId = random chars -l 10;
  let password = random chars -l 10;
  let name = $'ADB_WIFI_($nameId)';

  $'WIFI:T:ADB;S:($name);P:($password);;' | qrencode -t ANSI -m 1

  loop {
    let devices = (mdns-scan _adb-tls-pairing._tcp)
    if ($devices | length) > 0 {
      let device = ($devices | where protocol == IPv4 | where 'service name' == $name | first)
      adb pair $"($device.ip):($device.port)" $password
      adbx c
      break
    }
    sleep 1sec
  }
}

def 'zellij drop' [ --all ] {
  let sessions = (zellij list-sessions | lines)
  if ($sessions | length) == 0 {
    return
  }
  let choose = if $all {
    $sessions | ansi strip | parse '{name} {desc}'
  } else {
    gum choose --no-limit ...$sessions | lines | parse '{name} {desc}'
  }
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

def lsi [] {
  let images = (fd -e png -e jpg -e jpeg -d 1 | lines)
  if ($images | is-empty) {
    return
  }
  let isBig = (term size | get columns) > 110
  let isMany = ($images | length) > 6
  let grid = if ($isBig and $isMany) { 6 } else { 3 }
  timg --title --pixelation sixel --grid $grid ...$images
}

def 'rsftp' [] {
  rclone copy --sftp-host '192.168.0.20' --sftp-user 'anthony' --sftp-port 8022 --sftp-pass 'Smithg'
}

def --wrapped dockerctl [...rest] {
  if (ps | where name =~ dockerd | is-empty) {
    sudo ($env.DOCKER_BIN | path join dockerd)
  }
  if ($env.DOCKER_BIN | path join docker | path exists) {
    bash -c ($env.DOCKER_BIN | path join docker) ...$rest
  }
}

def ventoy [] {
  bash -c $"($env.VENTOY_PATH | path join VentoyGUI.x86_64)"
}

def remote-mouse [] {
  bash -c $"($env.REMOTE_MOUSE_PATH | path join RemoteMouse)"
}

def ftpd [] {
  ftpserver -conf ~/.config/ftpserver/ftpserver.json
}

def cosmic-config-backup [] {
  let cosmic = ($env.HOME | path join cosmic)
  mkdir $cosmic

  for file in (git -C ($env.HOME | path join .config/cosmic) status --short  | parse "{_}  {files}" | get files) {
    let dirname = ($file | path dirname)
    let basename = ($file | path basename)
    mkdir ($cosmic | path join $dirname)
    cp $file ($cosmic | path join $dirname $basename)
  }
}

def create-phone-backup [] {
  rclone copy --multi-thread-streams 2 -P -M anthony-android-work:/DCIM ~/Backup/
  rclone copy --multi-thread-streams 2 -P -M anthony-android-work:/Backup/ ~/Backup/
}
