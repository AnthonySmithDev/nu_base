
export def create [name: string] {
  ^sdkmanager --install "system-images;android-35;google_apis_playstore;x86_64" # if android >= 28
  ^avdmanager --silent create avd -n $name -k "system-images;android-35;google_apis_playstore;x86_64"
}

export def list [] {
  ^avdmanager list avd -c | lines
}

export def delete [name: string@list] {
  ^avdmanager delete avd -n $name
}

export def run [name: string@list] {
  ^emulator -avd $name -no-window
}
