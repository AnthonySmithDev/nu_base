
export def browser [] {
	vieb
	brave
	chrome
	edge
}

export def vieb [] {
  flatpak install -y flathub 'dev.vieb.Vieb'
}

export def brave [] {
  flatpak install -y flathub 'com.brave.Browser'
}

export def chrome [] {
  flatpak install -y flathub 'com.google.Chrome'
}

export def edge [] {
  flatpak install -y flathub 'com.microsoft.Edge'
}

export def zoom [] {
	flatpak install -y flathub 'us.zoom.Zoom'
}

export def teams [] {
	flatpak install -y flathub 'com.microsoft.Teams'
}

export def slack [] {
  flatpak install -y flathub 'com.slack.Slack'
}

export def discord [] {
	flatpak install -y flathub 'com.discordapp.Discord'
}

export def helix [] {
	flatpak install -y flathub 'com.helix_editor.Helix'
}

export def localsend [] {
	flatpak install -y flathub 'org.localsend.localsend_app'
}

export def android-studio [] {
	flatpak install -y flathub 'com.google.AndroidStudio'
}

export def keepassxc [] {
	flatpak install -y flathub 'org.keepassxc.KeePassXC'
}

export def flameshot [] {
	flatpak install -y flathub org.flameshot.Flameshot
}
