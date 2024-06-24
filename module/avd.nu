
export def create [name: string] {
  ^avdmanager --silent create avd -n $name -k "system-images;android-34;google_apis;x86_64"
}

export def list [] {
  ^avdmanager list avd -c | lines
}

export def delete [name: string@list] {
  ^avdmanager delete avd -n $name
}

export def run [name: string@list] {
  ^emulator -avd $name
}
