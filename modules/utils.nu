
export def dns-for-families [] {
  # nameserver 127.0.0.53
  # nameserver 94.140.14.49
  # nameserver 94.140.14.59
  sudo bash -c "echo 'nameserver 1.1.1.3' >> /etc/resolv.conf"
  sudo systemctl restart NetworkManager
}

export def 'tiktok mv' [] {
  mkdir tiktok/videos/
  mkdir tiktok/images/

  mv ...(glob **/<[a-f0-9]:32>.mp4) ./tiktok/videos/
  mv ...(glob **/<[a-f0-9]:32>.png) ./tiktok/images/
}

export def 'tiktok rm' [] {
  rm ...(glob **/<[a-f0-9]:32>.mp4)
  rm ...(glob **/<[a-f0-9]:32>.png)
}

export def copy-backup-disk [] {
  sudo rclone copy -P -M /media/anthony/B2/Backup /media/anthony/B3/Backup
  sudo rclone copy -P -M /media/anthony/B2/Backup /media/anthony/B1/Backup
}

# use ~/nushell/nu_scripts/custom-completions/git/git-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/nix/nix-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/btm/btm-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/glow/glow-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/cargo/cargo-completions.nu *

export def 'chmod nu_base' [] {
  chmod '+x' sh/shell.sh
  chmod '+x' sh/install.sh

  fd --type file --exec chmod 666 {}
  fd --type dir --exec chmod 755 {}
}

export def 'nu gitignore list' [] {
  http get 'https://www.toptal.com/developers/gitignore/api/list?format=lines' | lines
}

export def gitignore [lang: string@'nu gitignore list'] {
  http get $'https://www.toptal.com/developers/gitignore/api/($lang)' | save .gitignore
}

export def help! [cmd?: string] {
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

export def --env scd [] {
  let path = gum file --file --directory
  if ($path | path type) == 'file' {
    hx $path
  } else if ($path | path type) == 'dir' {
    cd $path
  }
}

export def sqlite [database: string] {
   litecli $database --auto-vertical-output
}

export def mysql [] {
  let dsn = $'mysql://($env.SQL_USER):($env.SQL_PASS)@($env.SQL_HOST):($env.SQL_PORT)/($env.SQL_NAME)'
  print $dsn
  mycli $dsn --auto-vertical-output
}

export def redis [...cmd: string] {
  let url = $"redis://:($env.REDIS_PASS)@($env.REDIS_HOST):($env.REDIS_PORT)"
  if ($cmd | is-empty) {
    iredis --url $url
  } else {
    iredis --url $url --raw ($cmd | str join ' ')
  }
}

export def harsql [] {
  harlequin -a mysql -h $env.SQL_HOST -p $env.SQL_PORT -U $env.SQL_USER --password $env.SQL_PASS --database $env.SQL_NAME
}

export def redis_del [cmd: string] {
   redis DEL (redis KEYS $cmd | lines | str join ' ')
}

export def "android debug start" [] {
  watch . --glob=**/*.kt {||
    sh gradlew assembleDebug
    sh gradlew installDebug
    adb shell am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -n com.example.myapplication/.MainActivity
  }
}

export def "android debug restart" [] {
  watch . --glob=**/*.kt {||
    sh gradlew assembleDebug
    adb install -r app/build/outputs/apk/debug/app-debug.apk
    adb shell am force-stop com.example.myapplication
    adb shell am start -n com.example.myapplication/.MainActivity
  }
}

export def select-file [] {
  let preview = 'bat --plain --number --color=always {}'
  return (fd --type file | fzf --layout reverse --border --preview $preview | str trim)
}

export def "create camare" [] {
  # https://adityatelange.in/blog/android-phone-webcam-linux/
  sudo apt install v4l2loopback-dkms v4l2loopback-utils
  sudo modprobe -v v4l2loopback exclusive_caps=1 card_label="Android Webcam"
  let n = (ls /dev/video* | length)
  v4l2-ctl --list-devices
  scrcpy --no-video --no-playback --video-source=camera --camera-id=0 --camera-size=1920x1080 --v4l2-sink=/dev/video0
}

export def gic [lang: string] {
  let output = 'clipboard.png'
  wl-paste | freeze --output $output --theme dracula --language $lang
  open $output | wl-copy
  rm $output
}

export def --wrapped dockerctl [...rest] {
  if (ps | where name =~ dockerd | is-empty) {
    sudo ($env.DOCKER_BIN | path join dockerd)
  }
  if ($env.DOCKER_BIN | path join docker | path exists) {
    bash -c ($env.DOCKER_BIN | path join docker) ...$rest
  }
}

export def remote-mouse [] {
  bash -c $"($env.REMOTE_MOUSE_PATH | path join RemoteMouse)"
}

export def ftpd [] {
  ftpserver -conf ~/.config/ftpserver/ftpserver.json
}

export def cosmic-config-backup [] {
  let cosmic = ($env.HOME | path join cosmic)
  mkdir $cosmic

  for file in (git -C ($env.HOME | path join .config/cosmic) status --short  | parse "{_}  {files}" | get files) {
    let dirname = ($file | path dirname)
    let basename = ($file | path basename)
    mkdir ($cosmic | path join $dirname)
    cp $file ($cosmic | path join $dirname $basename)
  }
}

export def transfer [path: path] {
  if not ($path | path exists) {
    return
  }
  let filename = if ($path | path type) == "file" { $path } else {
    let basename = ($path | path basename) + ".zip"
    let dirname = ($env.HOME | path join temp transfer $basename)
    ^zip -q -r $dirname $path
    $dirname
  }
  let url = (open $filename | curl --silent --show-error --progress-bar --upload-file - $"https://transfer.sh/($filename)")
  echo $url
}

export def nf [name: string] {
  let dir = (fd -t d | fzf)
  hx ($dir | path join $name)
}

export def nd [name: string] {
  let dir = (fd -t d | fzf)
  mkdir ($dir | path join $name)
}

export def asr [] {
  job spawn {|| audiosource run}
}

export def watch_ask_prompt [] {
  r#'
  Find the "AI" comments below (marked with ?) in the code files I've shared with you.
  They contain my questions that I need you to answer and other instructions for you.
  responde en spanish
  '#
}

export def "main watch" [] {
  watch . --glob=**/*.go --quiet {|op, path|
    let prompt = (open $path | rg "AI?" | lines)
    if ($prompt | is-not-empty) {
      print $path
      open $path | aichat (watch_ask_prompt)
    }
  }
}

# let watch_code_prompt = r#'
# I've written your instructions in comments in the code and marked them with "ai"
# You can see the "AI" comments shown below (marked with █).
# Find them in the code files I've shared with you, and follow their instructions.

# After completing those instructions, also be sure to remove all the "AI" comments from the code too.
# '#

export def 'chmod nu_work' [] {
  fd -t f -x chmod 655
  fd -t d -x chmod 777
}

export def __logs_user [] {
  [anthony jean]
}

export def __logs_repo [] {
  [main p2p]
}

export def __logs_file [] {
  [server database]
}

export def logs [user: string@__logs_user, repo: string@__logs_repo, file: string@__logs_file] {
  let host = if $user == "anthony" {
    "locahost"
  } else {
    "100.97.221.20"
  }
  let port = if $repo == "main" {
    "3000"
  } else {
    "3010"
  }
  http get $"http://($host):($port)/logs/($file).log"
}

export def find_tag_vue [] {
  (ambs -r '<q-icon\s+[^>]*@click="([^"]+)"[^>]*>' --no-color --column  | lines | where $it =~ "q-icon" | split column : path line)
}

# wscat -c ws://yoda:7078 -x '{ "action": "subscribe", "topic": "confirmation" }'

export def 'gofmtx' [] {
  for $file in (glob **/*.go) {
    goimports -w $file
  }
}

export def bitcoin-config [src: path] {
  let dir = ($env.HOME | path join .bitcoin)
  mkdir $dir

  ln -sf $src ($dir | path join client.conf)
}
