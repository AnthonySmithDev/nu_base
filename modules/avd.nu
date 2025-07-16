export-env {
  $env.AVD_SERVER_SOCKET = "192.168.0.200"
}

const DEFAULT_DEVICE = "pixel_9"
const DEFAULT_SYSTEM_IMAGE = "system-images.android-36.google_apis_playstore.x86_64"

def to-system-images [] {
  grep "system-images;" | grep ";x86_64" | lines | uniq | each { str replace -a ";" "." }
}

def from-system-image [] {
  str replace -a "." ";"
}

export def "system list" [] {
  use clock.nu

  clock run avd-list-system-images 1wk {
    ^sdkmanager --list --verbose err> /dev/null
  } | to-system-images
}

export def "system installed" [] {
  use clock.nu

  clock run avd-system-images 1min {
    ^sdkmanager --list_installed --verbose err> /dev/null
  } | to-system-images
}

export def "system install" [
  package: string@"system list" = $DEFAULT_SYSTEM_IMAGE
] {
  ^sdkmanager --install ($package | from-system-image) err> /dev/null
}

export def device [] {
  use clock.nu

  clock run avd-list-device 1wk {
    ^avdmanager list device -c
  } | lines
}

export def virtual [] {
  use clock.nu

  clock run avd-list-avd 1min --json {
    ^avdmanager list avd -c | lines
  }
}

export def create [
  name?: string,
  --device(-d): string@device = $DEFAULT_DEVICE
  --package(-p): string@"system list" = $DEFAULT_SYSTEM_IMAGE
] {
  use clock.nu

  if $package not-in (system installed) {
    ^sdkmanager --install ($package | from-system-image)
  }
  if $name not-in (virtual) {
    let name = if ($name | is-empty) { $device } else { $name }
    ^avdmanager create avd -n $name -d $device -k ($package | from-system-image)
  }
  clock add avd-list-avd $name
}

export def delete [name: string@virtual] {
  use clock.nu

  ^avdmanager delete avd -n $name
  clock delete avd-list-avd
}

export def editor [name: string@virtual] {
  let dir = ($env.ANDROID_AVD_HOME | path join $"($name).avd")
  let files = [
    ($dir | path join "config.ini")
    # ($dir | path join "hardware-qemu.ini")
    # ($dir | path join "snapshots/default_boot/hardware.ini")
  ]
  hx ...$files
}

export def run [
  name: string@virtual,
  --cores: int = 4
  --memory: int = 8
] {
  let args = [
    -cores $cores
    -memory ($memory * 1024)
    -ranchu
    -accel on
    -engine qemu2
    -no-audio
    -no-window
    -no-metrics
    -no-boot-anim
    -verbose
  ]
  ^emulator -avd $name ...$args
}

export def --wrapped screen [--max-size: int = 800, ...rest] {
  ^scrcpy --max-size $max_size ...$rest
}

export def server [] {
  ^adb kill-server
  ^adb -a nodaemon server start
}

export def --env "remote env" [] {
  $env.ADB_SERVER_SOCKET = $"tcp:($env.AVD_SERVER_SOCKET):5037"
}

export def --env --wrapped "remote scrcpy" [--max-size: int = 1080, ...rest] {
  env
  ^scrcpy --tunnel-host $env.AVD_SERVER_SOCKET --max-size $max_size ...$rest
}
