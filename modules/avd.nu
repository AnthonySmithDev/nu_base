
export-env {
  $env.AVD_SERVER_SOCKET = "192.168.0.200"
}

export def list-device [] {
  use clock.nu

  clock run avd-list-device 1wk {
    ^avdmanager list device -c
  } | lines
}

def to-system-images [] {
  grep "system-images;" | grep ";x86_64" | lines | uniq | each { |it| $"'($it)'" }
}

export def list-system-images [] {
  use clock.nu

  clock run avd-list-system-images 1wk {
    ^sdkmanager --sdk_root=($env.ANDROID_SDK_ROOT) --list --verbose err> /dev/null
  } | to-system-images
}

export def system-images [] {
  use clock.nu

  clock run avd-system-images 1min {
    ^sdkmanager --sdk_root=($env.ANDROID_SDK_ROOT) --list_installed --verbose err> /dev/null
  } | to-system-images
}

export def list-virtual [] {
  use clock.nu

  clock run avd-list-avd 1min {
    ^avdmanager list avd -c
  } | lines
}

const DEFAULT_SYSTEM_IMAGE = "system-images;android-35;default;x86_64"

export def install-system [package: string@list-system-images = $DEFAULT_SYSTEM_IMAGE] {
  ^sdkmanager --sdk_root=($env.ANDROID_SDK_ROOT) --install $package err> /dev/null
}

export def create [
  name: string,
  --device(-d): string@list-device = "pixel_9",
  --package(-p): string@system-images = $DEFAULT_SYSTEM_IMAGE
  ] {
  ^sdkmanager --sdk_root=($env.ANDROID_SDK_ROOT) --install $package err> /dev/null
  ^avdmanager create avd -n $name -d $device -k $package
}

export def delete [name: string@list-virtual] {
  use clock.nu

  ^avdmanager delete avd -n $name
  clock delete avd-list-avd
}

export def editor [name: string@list-virtual] {
  let dir = ($env.HOME | path join $".android/avd/($name).avd")
  let files = [
    ($dir | path join config.ini)
    ($dir | path join hardware-qemu.ini)
    ($dir | path join snapshots/default_boot/hardware.ini)
  ]
  hx ...$files
}

export def run [
  name: string@list-virtual,
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
    -verbose
  ]
  ^emulator -avd $name ...$args
}

export def server [] {
  ^adb kill-server
  ^adb -a nodaemon server start
}

export def --env env [] {
  $env.ADB_SERVER_SOCKET = $"tcp:($env.AVD_SERVER_SOCKET):5037"
}

export def --env --wrapped scrcpy [--max-size: int = 1480, ...rest] {
  env
  ^scrcpy --tunnel-host $env.AVD_SERVER_SOCKET --max-size $max_size ...$rest
}
