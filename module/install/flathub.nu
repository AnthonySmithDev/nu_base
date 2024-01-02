
export def browser [] {
  flatpak install -y flathub 'dev.vieb.Vieb'
  flatpak install -y flathub 'com.brave.Browser'
  flatpak install -y flathub 'com.google.Chrome'
  flatpak install -y flathub 'com.microsoft.Edge'
}

export def remote [] {
	flatpak install -y flathub 'com.microsoft.Teams'
	flatpak install -y flathub 'us.zoom.Zoom'
}

export def work [] {
	flatpak install -y flathub 'com.discordapp.Discord'
  flatpak install -y flathub 'com.slack.Slack'
}

export def dev [] {
	flatpak install -y flathub 'com.helix_editor.Helix'
}

export def tool [] {
	flatpak install -y flathub 'org.keepassxc.KeePassXC'
}

export def other [] {
	flatpak install -y flathub 'com.google.AndroidStudio'
	flatpak install -y flathub 'org.localsend.localsend_app'
}
