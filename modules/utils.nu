
export def dns-for-families [] {
  # nameserver 127.0.0.53
  # nameserver 94.140.14.49
  # nameserver 94.140.14.59
  sudo bash -c "echo 'nameserver 1.1.1.3' >> /etc/resolv.conf"
  sudo systemctl restart NetworkManager
}

export def nault [] {
  let dir = ($env.HOME | path join .config/BraveSoftware/Brave-Browser-S)
  job spawn { brave-browser --user-data-dir=($dir) --app=https://nault.cc/configure-wallet }
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

export def ytb [filename: string] {
  let args = [
    # --quiet
    # --progress
    --max-filesize 1G
    --match-filter "duration < 1800"
    --write-thumbnail
    --restrict-filenames
    --write-all-thumbnails
    --concurrent-fragments 50
    --batch-file $filename
    --download-archive archive.txt
    --output "%(uploader)s/%(title)s [%(id)s].%(ext)s"
    # --output "%(uploader)s/%(upload_date>%Y)s/%(title)s [%(id)s].%(ext)s"
  ]
  yt-dlp ...$args
}

# use ~/nushell/nu_scripts/custom-completions/git/git-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/nix/nix-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/btm/btm-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/glow/glow-completions.nu *
# use ~/nushell/nu_scripts/custom-completions/cargo/cargo-completions.nu *
#
# 


export def 'chmod nu_base' [] {
  chmod '+x' sh/shell.sh
  chmod '+x' sh/install.sh

  fd --type file --exec chmod 666 {}
  fd --type dir --exec chmod 755 {}
}

export def trans [ ...text: string, --en(-e)] {
  let lang = if $en { ':en' } else { ':es' }
  docker run -it --rm soimort/translate-shell -b $lang ($text | str join ' ')
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

export def pastes [input: string, --save(-s): string] {
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

$env.SHOW_PATH = ($env.HOME | path join .show.txt)

export def show [...filter: path] {
  if ($filter | is-empty) { return }
  $filter | save -f $env.SHOW_PATH
  bat --paging never --style header ...$filter
}

export def showf [] {
  let filter = (fd --type file | gum filter --no-limit | lines)
  if ($filter | is-empty) { return }
  show ...$filter
}

export def showd [dir: path] {
  let filter = (fd --type file . $dir | lines)
  if ($filter | is-empty) { return }
  show ...$filter
}

export def showc [] {
  let filter = (open $env.SHOW_PATH | lines)
  if ($filter | is-empty) { return }
  show ...$filter
}

export def showe [] {
  hx $env.SHOW_PATH
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

export def list-images [
  ...images: string
  --pixelation(-p): string = "sixel"
  --search(-s): string = "."
  --max-depth(-m): int = 1
  --columns(-c): int
  --dir(-d): path = "."
] {
  let images = if ($images | is-not-empty) { $images } else {
    fd -e png -e jpg -e jpeg -d $max_depth $search $dir | lines
  }

  if ($images | is-empty) {
    return
  }

  let terminal_width = (term size | get columns)
  let is_wide_terminal = $terminal_width > 110
  let image_count = ($images | length)
  
  let grid_columns = if $columns != null { $columns } else {
    let max_images_per_row = if $image_count <= 2 { $image_count } else { 2 }
    if $is_wide_terminal { $max_images_per_row * 2 } else { $max_images_per_row }
  }

  timg --title --pixelation $pixelation --grid $grid_columns ...$images
}

export def --wrapped dockerctl [...rest] {
  if (ps | where name =~ dockerd | is-empty) {
    sudo ($env.DOCKER_BIN | path join dockerd)
  }
  if ($env.DOCKER_BIN | path join docker | path exists) {
    bash -c ($env.DOCKER_BIN | path join docker) ...$rest
  }
}

export def ventoy [] {
  bash -c $"($env.VENTOY_PATH | path join VentoyGUI.x86_64)"
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

export def paths [
  --path(-p): string = ".",
  --search(-s): string
  --type(-t): string
  ] {
  mut paths = []
  if ($search != null) {
    $paths = if ($type != null) {
      fd  --hidden --type $type $search --full-path $path | lines
    } else { fd  --hidden  $search --full-path $path | lines }
  } else {
    let list = ls -la $path
    $paths = if ($type != null) {
      $list | where type == $type | get name
    } else { $list | get name }
  }
  return $paths
}


export def asr [] {
  job spawn {|| audiosource run}
}

export def sshkeygen [] {
  ssh-keygen -t ed25519
}

export def xpaint [--deps(-d)] {

  if $deps {
    pip3 install torch==2.1.2 torchvision==0.16.2 --index-url https://download.pytorch.org/whl/cu121
    # pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121


    # sudo ubuntu-drivers autoinstall
    # ubuntu-drivers devices
    # 


    pip3 install iopaint
    pip3 install onnxruntime
    pip3 install rembg
    pip3 install gfpgan
    pip3 install realesrgan
    pip3 install realesrgan
  }

  # ^iopaint install-plugins-packages

  let args = [
    --model=Sanster/PowerPaint-V1-stable-diffusion-inpainting
    --device=cuda

    # --enable-interactive-seg
    # --interactive-seg-model=sam2_1_base
    # --interactive-seg-device=cuda

    # --enable-gfpgan
    # --gfpgan-device=cuda

    # --enable-realesrgan
    # --realesrgan-model=RealESRGAN_x4plus
    # --realesrgan-device=cuda

    # --enable-remove-bg
    # --remove-bg-model=briaai/RMBG-1.4
    # --remove-bg-device=cuda

    # --enable-restoreformer
    # --restoreformer-device=cuda

    --host=0.0.0.0
    # --port=8080
  ]
  CUDA_VISIBLE_DEVICES="0,1,2" ^iopaint start ...$args
}

export def to-gif [video: path] {
  mkdir ./tmp
  ffmpeg -i $video -vf fps=10 ./tmp/frame_%04d.png
  convert -delay 10 -loop 0 ./tmp/frame_*.png output.gif
  rm -rf ./tmp
}
