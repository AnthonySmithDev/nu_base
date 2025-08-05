
const DEFAULT_DEVICE = "pixel_9"
const DEFAULT_SYSTEM_IMAGE = "system-images.android-36.google_apis_playstore.x86_64"

const ADV_SYSTEM_GENERAL = "adv_system_general"
const ADV_SYSTEM_INSTALLED = "adv_system_installed"

const ADV_DEVICE = "adv_device"
const ADV_VIRTUAL = "adv_virtual"

def to-system-images [] {
  grep "system-images;" | grep ";x86_64" | lines | uniq | each { str replace -a ";" "." }
}

def from-system-image [] {
  str replace -a "." ";"
}

export def "system general" [] {
  use clock.nu

  clock run $ADV_SYSTEM_GENERAL 1wk --json {
    ^sdkmanager --list --verbose err> /dev/null | to-system-images
  }
}

export def "system installed" [] {
  use clock.nu

  clock run $ADV_SYSTEM_INSTALLED 1day --json {
    ^sdkmanager --list_installed --verbose err> /dev/null | to-system-images
  }
}

export def "system install" [
  package: string@"system general" = $DEFAULT_SYSTEM_IMAGE
] {
  use clock.nu

  if $package not-in (system installed) {
    ^sdkmanager --install ($package | from-system-image) err> /dev/null
    clock add $ADV_SYSTEM_INSTALLED $package
  }
}

export def device [] {
  use clock.nu

  clock run $ADV_DEVICE 1wk {
    ^avdmanager list device -c
  } | lines
}

export def virtual [] {
  use clock.nu

  clock run $ADV_VIRTUAL 1day --json {
    ^avdmanager list avd -c | lines
  }
}

export def create [
  name?: string,
  --device(-d): string@"device" = $DEFAULT_DEVICE
  --package(-p): string@"system general" = $DEFAULT_SYSTEM_IMAGE
] {
  use clock.nu
  system install $package

  let device_name = if ($name | is-empty) { $device } else { $name }
  if $device_name in (virtual) {
    return
  }

  job spawn { ^avdmanager create avd -n $device_name -d $device -k ($package | from-system-image) }
  clock add $ADV_VIRTUAL $device_name
}

export def delete [name: string@virtual] {
  use clock.nu

  job spawn { ^avdmanager delete avd -n $name }
  clock delete $ADV_VIRTUAL $name
}

def from-ini [] {
  lines | split column "=" | rename key value
}

def to-ini [] {
  each {|e| $"($e.key)=($e.value)" } | to text
}

def get-ini [key: string] {
  where key ==  $key | first | get value
}

def upsert-ini [key: string, value: string] {
  upsert value {|row| if $row.key == $key {$value} else {$row.value}}
}

export def update [name: string@virtual] {
  let path = ($env.HOME | path join .android avd $"($name).avd" "config.ini")
  let config = (open $path | from-ini)
  print $path

  $config
  | upsert-ini hw.lcd.height 960
  | upsert-ini hw.lcd.width 480
  | upsert-ini hw.lcd.vsync 60
  | upsert-ini hw.lcd.density 240
  | upsert-ini hw.ramSize 4096
  | upsert-ini hw.cpu.ncore 5
  | to-ini | save --force $path
}

export def edit [name: string@virtual] {
  let path = ($env.HOME | path join .android avd $"($name).avd" "config.ini")
  let config = (open $path | from-ini)

  gum input --header "Height" --value ($config | get-ini hw.lcd.height)
  gum input --header "Width" --value ($config | get-ini hw.lcd.width)
  gum input --header "Vsync" --value ($config | get-ini hw.lcd.vsync)
  gum input --header "Density" --value ($config | get-ini hw.lcd.density)
  gum input --header "RamSize" --value ($config | get-ini hw.ramSize)
  gum input --header "Ncore" --value ($config | get-ini hw.cpu.ncore)
}

export def editor [name: string@virtual] {
  let path = ($env.HOME | path join .android avd $"($name).avd" "config.ini")
  hx $path
}

export def device-info [] {
  let ram_total = (adb shell cat /proc/meminfo | grep "MemTotal" | str trim | split words | get 1 | into int | $in * 1024) # Bytes
  let ram_available = (adb shell cat /proc/meminfo | grep "MemAvailable" | str trim | split words | get 1 | into int | $in * 1024) # Bytes
  let cpu_cores = (adb shell cat /proc/cpuinfo | grep ^processor | wc -l | into int)
  let screen_resolution = (adb shell wm size | str replace "Physical size: " "" | str trim)
  let screen_width = ($screen_resolution | split row "x" | get 0 | into int)
  let screen_height = ($screen_resolution | split row "x" | get 1 | into int)

  {
    cpu: {
      cores: $cpu_cores
    },
    ram: {
      total_gb: ($ram_total / (1024 * 1024 * 1024)),
      available_gb: ($ram_available / (1024 * 1024 * 1024))
    },
    display: {
      resolution: $screen_resolution,
      width_px: $screen_width,
      height_px: $screen_height
    },
  }
}

export def run [
  name: string@virtual,
  --memory: int = 8
] {
  let args = [
    -memory ($memory * 1024)
    -accel auto
    # -no-audio
    -no-window
    -no-boot-anim
    -debug init
    -no-metrics
    # -verbose
  ]
  ^emulator -avd $name ...$args
}

export def --wrapped view [--max-size: int = 720, ...rest] {
  ^scrcpy --window-title AVD --keyboard uhid  --max-size $max_size ...$rest
}

def hosts [] {
  ["192.168.0.11" "192.168.0.200"]
}

export def "adb server" [] {
  ^adb kill-server
  ^adb -a nodaemon server start
}

export def --env "adb env" [host: string@hosts] {
  $env.ADB_SERVER_SOCKET = $"tcp:($host):5037"
}

export def --env --wrapped client [host: string@hosts, --max-size: int = 720, ...rest] {
  adb env $host
  ^scrcpy --window-title AVD --keyboard uhid --tunnel-host $host --max-size $max_size ...$rest
}
