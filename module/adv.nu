
export def create [name: string] {
  ^avdmanager create avd -n $name -k "system-images;android-34;google_apis;x86_64"
}

export def list [] {
  emulator -list-avds | lines | skip
}

export def run [name: string@list] {
  emulator -avd $name
}
