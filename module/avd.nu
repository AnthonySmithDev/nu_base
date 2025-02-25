
export-env {
  $env.AVD_SERVER_SOCKET = "192.168.0.200"
}

export def install-sdk [] {
  let packages = [
    "platform-tools"
    "platforms;android-35"
    "build-tools;35.0.0"
    "sources;android-35"
    "emulator"
  ]
  ^sdkmanager --install ...($packages | reverse)
}

export def list-device [] {
  job run avd-list-device 1wk {
    ^avdmanager list device -c
  } | lines
}

def to-system-images [] {
  grep "system-images;" | grep ";x86_64" | lines | uniq | each { |it| $"`($it)`" }
}

export def system-images-list [] {
  job run avd-system-images-list 1wk {
    ^sdkmanager --list --verbose err> /dev/null
  } | to-system-images
}

export def system-images-installed [] {
  job run avd-system-images-installed 1min {
    ^sdkmanager --list_installed --verbose err> /dev/null
  } | to-system-images
}

export def create [
  name: string,
  --device(-d): string@list-device = "pixel_7",
  --package(-p): string@system-images-installed = "system-images;android-35;google_apis_playstore;x86_64"
  ] {
  ^sdkmanager --install $package err> /dev/null
  ^avdmanager --silent create avd -n $name -d $device -k $package
}

export def list [] {
  job run avd-list-avd 1min {
    ^avdmanager list avd -c
  } | lines
}

export def delete [name: string@list] {
  ^avdmanager delete avd -n $name
  job delete avd-list-avd
}

export def run [
  name: string@list,
  --cores: int = 4
  --memory: int = 8
  ] {
  let args = [
    -cores $cores
    -memory ($memory * 1024)
    -ranchu
    -accel on
    -engine qemu2
    -no-window
    -no-metrics
    -no-boot-anim
  ]
  ^emulator -avd $name ...$args
}

export def server [] {
  ^adb kill-server
  ^adb -a nodaemon server start
}

export def --env scrcpy [] {
  $env.ADB_SERVER_SOCKET = $"tcp:($env.AVD_SERVER_SOCKET):5037"
  ^scrcpy --tunnel-host $env.AVD_SERVER_SOCKET
}
