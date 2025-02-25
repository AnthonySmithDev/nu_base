
export def list-device [] {
  job avd-list-device 1wk {
    ^avdmanager list device -c
  } | lines
}

export def system-images-list [] {
  job avd-system-images-list 1wk {
    ^sdkmanager --list --verbose | grep "system-images;" | grep ";x86_64"
  } | lines | uniq
}

export def system-images-installed [] {
  job avd-system-images-installed 1min {
    ^sdkmanager --list_installed --verbose | grep "system-images;" | grep ";x86_64"
  } | lines | uniq
}

export def create [
  name: string,
  --device(-d): string@list-device = "pixel_7_pro",
  --package(-p): string@system-images-installed = "system-images;android-35;google_apis_playstore;x86_64"
  ] {
  ^sdkmanager --install $package
  ^avdmanager --silent create avd -n $name -d $device -k $package
}

export def list [] {
  job avd-list-device 1min {
    ^avdmanager list avd -c
  } | lines
}

export def delete [name: string@list] {
  ^avdmanager delete avd -n $name
}

export def run [
  name: string@list,
  --cores: int = 4
  --memory: int = 4096
  ] {
  let args = [
    -cores $cores
    -memory $memory
    -ranchu
    -gpu host
    -accel on
    -engine qemu2
    -no-window
    -no-metrics
    -no-boot-anim
  ]
  ^emulator -avd $name ...$args
}
