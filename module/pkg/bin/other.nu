
def filepath [name: string, version: string] {
  $env.USR_LOCAL_SHARE_BIN | path join $"($name)_($version)"
}

def dirpath [name: string, version: string] {
  $env.USR_LOCAL_SHARE_LIB | path join $"($name)_($version)"
}

def 'bind dir' [src: string, dst: string] {
  rm -rf $dst
  ln -sf $src $dst
}

def 'bind file' [cmd: string, src: string] {
  let dst = ($env.USR_LOCAL_BIN | path join $cmd)
  rm -rf $dst
  ln -sf $src $dst
}

def 'bind root' [cmd: string, src: string] {
  let dst = ($env.SYS_LOCAL_BIN | path join $cmd)
  sudo rm -rf $dst
  sudo ln -sf $src $dst
}

def move [
  --dir(-d): string = ''
  --file(-f): string = '',
  --path(-p): string,
] {
  if ($path | path exists) {
    rm -rf $path
  }
  let src = ($dir | path join $file)
  if ($src | path exists) {
    mv --force $src $path
  } else {
    error make -u {msg: $"Source not exists \n ($src)"}
  }
  if ($dir | path exists) { rm -rf $dir }
}

def path-not-exists [path: string, force: bool] {
  (not ($path | path exists) or $force)
}

def download [ url: string, --dirname(-d): string, --filename(-n): string, --force(-f) ] {
  let dir = if ($dirname | is-not-empty) {
    $env.TMP_PATH_FILE | path join $dirname
  } else {
    $env.TMP_PATH_FILE
  }
  mkdir $dir
  let path = if ($filename | is-not-empty) {
    $dir | path join $filename
  } else {
    $dir | path join ($url | url filename)
  }
  if (path-not-exists $path $force) {
    http download $url --output $path
  }
  return $path
}

def decompress [path: path] {
  if not ($path | path exists) {
    error make {msg: $"Path not exists: ($path)"}
  }

  let dir = mktemp --directory --tmpdir-path $env.TMP_PATH_DIR
  mkdir $dir

  if $path =~ ".tar" or $path =~ ".tbz" or $path =~ ".tgz" or $path =~ ".tar.gz" {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract tar...' -- tar -xvf $path -C $dir
    } else {
      tar -xvf $path -C $dir
    }
  } else if $path =~ ".zip" {
    if (exists-external gum) {
      ^gum spin --spinner dot --title 'Extract zip...' -- unzip $path -d $dir
    } else {
      unzip $path -d $dir
    }
  } else if $path =~ ".gz" {
    let basename = ($path | path basename | str replace '.gz' '')
    let filepath = ($dir | path join $basename)
    gunzip -c $path | save --force $filepath
    return $filepath
  } else {
    error make {msg: "Unsupported file format"}
  }

  let content = (ls $dir | get name)
  let first_item = ($content | first)

  if ($content | length) == 1 and ($first_item | path type) == "dir" {
    let nested_content = (ls $first_item | get name)
    let second_item = ($nested_content | first)

    if ($nested_content | length) == 1 and ($second_item | path type) == "dir" {
      return $second_item
    }
    return $first_item
  }
  return $dir
}

def choose [versions: list] {
  if not (^which gum | is-empty) {
    (^gum choose ...$versions)
  } else {
    ($versions | input list)
  }
}

export def atlas [ --eula, --force(-f) ] {
  let repository = 'ariga/atlas'
  let tag_name = ghub tag_name $repository
  let path = filepath atlas $tag_name

  if (path-not-exists $path $force) {
    let filename = if $eula {
      'atlas-linux-amd64-latest'
    } else {
      'atlas-community-linux-amd64-latest'
    }
    let download_path = download $'https://release.ariga.io/atlas/($filename)' -d atlas
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind file atlas $path
}

export def --env sshx [ --force(-f) ] {
  let repository = 'ekzhang/sshx'
  let tag_name = ghub tag_name $repository

  let os = (uname | get operating-system)
  let arch = (uname | get machine)

  let suffix = match $os {
      "Linux" => "-unknown-linux-musl",
      "Darwin" => "-apple-darwin",
      "FreeBSD" => "-unknown-freebsd",
      _ => {
          echo $"Unsupported OS ($os)"
          exit 1
      }
  }

  let arch = match $arch {
      "aarch64" | "aarch64_be" | "arm64" | "armv8b" | "armv8l" => "aarch64",
      "x86_64" | "x64" | "amd64" => "x86_64",
      "armv6l" => { "arm" },
      "armv7l" => { "armv7" },
      _ => {
          echo $"Unsupported arch ($arch)"
          exit 1
      }
  }

  let path = filepath sshx $tag_name
  if (path-not-exists $path $force) {
    let download_path = download $"https://s3.amazonaws.com/sshx/sshx-($arch)($suffix).tar.gz" -d sshx
    let decompress_path = decompress $download_path
    move -d $decompress_path -f sshx -p $path
  }
  bind file sshx $path

  let path = filepath sshx-server $tag_name
  if (path-not-exists $path $force) {
    let download_path = download $"https://s3.amazonaws.com/sshx/sshx-server-($arch)($suffix).tar.gz" -d sshx
    let decompress_path = decompress $download_path
    move -d $decompress_path -f sshx-server -p $path
  }
  bind file sshx-server $path
}

export def kubectl [ --force(-f) ] {
  let version = http get https://dl.k8s.io/release/stable.txt
  let path = filepath kubectl $version

  if (path-not-exists $path $force) {
    let download_path = download https://dl.k8s.io/release/($version)/bin/linux/amd64/kubectl -d kubectl
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind file kubectl $path
  bind root kubectl $path
}

export def --env mitmproxy [ --force(-f) ] {
  let repository = 'mitmproxy/mitmproxy'
  let tag_name = ghub tag_name $repository
  let path = dirpath mitmproxy $tag_name

  if (path-not-exists $path $force) {
    let version = ($tag_name | ghub to-version)
    let download_path = download $'https://downloads.mitmproxy.org/($version)/mitmproxy-($version)-linux-x86_64.tar.gz' -d mitmproxy
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.MITMPROXY_BIN
  env-path $env.MITMPROXY_BIN
}

export def devtunnel [ --force(-f) ] {
  let path = filepath devtunnel latest

  if (path-not-exists $path $force) {
    let download_path = download https://aka.ms/TunnelsCliDownload/linux-x64 -d devtunnel
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind file devtunnel $path
}

export def pinggy [ --force(-f) ] {
  let path = filepath pinggy latest

  if (path-not-exists $path $force) {
    let download_path = download https://s3.ap-south-1.amazonaws.com/public.pinggy.binaries/v0.1.0-beta.1/linux/amd64/pinggy -d pinggy
    add-execute $download_path
    move -f $download_path -p $path
  }

  bind file pinggy $path
}

export def remote-mouse [ --force(-f) ] {
  let version = 'latest'
  let path = filepath remotemouse $version

  if (path-not-exists $path $force) {
    let download_path = download 'https://www.remotemouse.net/downloads/linux/RemoteMouse_x86_64.zip' -d remotemouse
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.REMOTE_MOUSE_PATH
  env-path $env.REMOTE_MOUSE_PATH
}

export def --env docker [ --group(-g), --force(-f) ] {
  let version = '27.5.1'
  let path = dirpath docker $version

  if (path-not-exists $path $force) {
    let download_path = download $'https://download.docker.com/linux/static/stable/x86_64/docker-($version).tgz' -d docker
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  if not (exists-group docker) {
    sudo groupadd docker
    sudo usermod -aG docker $env.USER
  }

  bind dir $path $env.DOCKER_BIN
  env-path $env.DOCKER_BIN
}
def node-versions [ --force(-f) ] {
  [
    (http get https://nodejs.org/download/release/index.json | get version | first | str trim -c 'v')
    '21.2.0' '20.9.0' '18.18.2'
  ]
}

export def --env node [ --latest(-l), --force(-f) ] {
  let versions = node-versions

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = dirpath node $version
  if (path-not-exists $path $force) {
    let download_path = download $'https://nodejs.org/download/release/v($version)/node-v($version)-linux-x64.tar.gz' -d node
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.NODE_PATH
  env-path $env.NODE_BIN
}

def go-versions [ --force(-f) ] {
  [
    ...(http get https://go.dev/dl/?mode=json | get version)
  ]
}

export def --env golang [ --latest(-l), --force(-f) ] {
  let versions = go-versions

  let version = if $latest {
    ($versions | first)
  } else {
    (choose $versions)
  }

  let path = dirpath go $version
  if (path-not-exists $path $force) {
    let download_path = download $'https://go.dev/dl/($version).linux-amd64.tar.gz' -d golang
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.GOROOT
  env-path $env.GOBIN
}

export def --env zig [ --force(-f) ] {
  let version = ghub version "ziglang/zig"
  let path = dirpath zig $version

  if (path-not-exists $path $force) {
    let download_path = download $'https://ziglang.org/download/($version)/zig-linux-x86_64-($version).tar.xz' -d zig
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.ZIG_PATH
  env-path $env.ZIG_PATH
}

export def --env vlang [ --force(-f) ] {
  let version = 'latest'
  let path = dirpath vlang $version

  if (path-not-exists $path $force) {
    let download_path = download $'https://github.com/vlang/v/releases/($version)/download/v_linux.zip' -d vlang
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.VLANG_PATH
  env-path $env.VLANG_PATH
}

def java-list [] {
  {
    '11': 'https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz'
    '17': 'https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
    '21': 'https://download.java.net/java/GA/jdk21/fd2272bbf8e04c3dbaee13770090416c/35/GPL/openjdk-21_linux-x64_bin.tar.gz'
  }
}

def java-version [] {
  java-list | columns
}

export def --env java [ version: string@java-version = '21', --force(-f) ] {
  let path = dirpath java $version
  let download_url = (java-list | get $version)

  if (path-not-exists $path $force) {
    let download_path = download $download_url -d java
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.JAVA_PATH
  env-path $env.JAVA_BIN
}

export def --env jdtls [ --force(-f) ] {
  let path = dirpath jdtls 'latest'

  if (path-not-exists $path $force) {
    let download_path = download https://www.eclipse.org/downloads/download.php?download_path=/jdtls/snapshots/jdt-language-server-latest.tar.gz -d jdt -n jdt-language-server-latest.tar.gz
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.JDTLS_PATH
  env-path $env.JDTLS_BIN
}

def flutter_latest [ --force(-f) ] {
  http get https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | get releases | where channel == stable | get version | first
}

export def --env flutter [ --latest(-l), --force(-f) ] {
  let versions = [(flutter_latest) '3.10.6' '3.7.12' '3.0.5' '2.10.5' '2.2.3']

  let version = if $latest {
    ($versions | first)
  } else {
    let select = choose $versions
    if ($select | is-empty) {
      return
    }
    ($select)
  }

  let path = dirpath flutter $version
  if (path-not-exists $path $force) {
    let download_path = download $'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_($version)-stable.tar.xz' -d flutter
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.FLUTTER_PATH
  env-path $env.FLUTTER_BIN
}

export def --env android-studio [ --desktop(-d), --force(-f) ] {
  let version = '2024.2.1.9'
  let path = dirpath android-studio $version

  if (path-not-exists $path $force) {
    let download_path = download $'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/($version)/android-studio-($version)-linux.tar.gz' -d android-studio
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.ANDORID_STUDIO_PATH
  env-path $env.ANDROID_STUDIO_BIN

  if $desktop {
    let src = ($env.NU_BASE_FILES | path join applications android-studio.desktop)
    cp $src $env.LOCAL_SHARE_APPLICATIONS
  }
}

export def --env android-cmdline-tools [ --force(-f) ] {
  if (path-not-exists $env.ANDROID_CMDLINE_TOOLS $force) {
    let download_path = download https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -d android-cmdline-tools
    let decompress_path = decompress $download_path
    mkdir ($env.ANDROID_CMDLINE_TOOLS | path dirname)
    move -d $decompress_path -p $env.ANDROID_CMDLINE_TOOLS
  }
  env-path $env.ANDROID_CMDLINE_TOOLS_BIN
}

export def --env android-platform-tools [ --force(-f) ] {
  if (path-not-exists $env.ANDROID_PLATFORM_TOOLS $force) {
    let download_path = download https://dl.google.com/android/repository/platform-tools-latest-linux.zip -d android-platform-tools
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $env.ANDROID_PLATFORM_TOOLS
  }
  env-path $env.ANDROID_PLATFORM_TOOLS
}

export def --env dart [ --force(-f) ] {
  let version = (dart_latest)
  let path = dirpath dart $version

  if (path-not-exists $path $force) {
    let download_path = download $'https://storage.googleapis.com/dart-archive/channels/stable/release/($version)/sdk/dartsdk-linux-x64-release.zip' -d dart
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.DART_PATH
  env-path $env.DART_BIN
}

export def --env scilab [ --force(-f) ] {
  let version = '2024.1.0'
  let path = dirpath scilab $version

  if (path-not-exists $path $force) {
    let download_path = download $'https://www.scilab.org/download/($version)/scilab-($version).bin.x86_64-linux-gnu.tar.xz' -d scilab
    let decompress_path = decompress $download_path
    move -d $decompress_path -p $path
  }

  bind dir $path $env.SCILAB_PATH
  env-path $env.SCILAB_BIN
}

export def gitlab-cli [ --force(-f) ] {
  let version = '1.55.0'
  let path = filepath glab $version

  if (path-not-exists $path $force) {
    let download_path = download https://gitlab.com/gitlab-org/cli/-/releases/v($version)/downloads/glab_($version)_linux_amd64.tar.gz -d gitlab
    let decompress_path = decompress $download_path
    move -d $decompress_path -f bin/glab -p $path
  }

  bind file glab $path
}

export def gitlab-runner [ --force(-f) ] {
  sudo curl -L --output /usr/local/bin/gitlab-runner 'https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/latest/binaries/gitlab-runner-linux-amd64'
  sudo chmod 777 /usr/local/bin/gitlab-runner
  sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
  sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
  sudo gitlab-runner start
}

export def firefox-de [ --force(-f) ] {
  http download https://download-installer.cdn.mozilla.net/pub/devedition/releases/129.0b6/linux-x86_64/es-ES/firefox-129.0b6.tar.bz2
  extract tar firefox-129.0b6.tar.bz2

  sudo mv firefox /opt
  sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
  sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
}
