
const list =	[
	[name, url];
	[vieb dev.vieb.Vieb]
	[brave com.brave.Browser]
	[chrome com.google.Chrome]
	[edge com.microsoft.Edge]
	[zoom us.zoom.Zoom]
	[teams com.microsoft.Teams]
	[slack com.slack.Slack]
	[discord com.discordapp.Discord]
	[helix com.helix_editor.Helix]
	[localsend org.localsend.localsend_app]
	[android com.google.AndroidStudio]
	[keepassxc org.keepassxc.KeePassXC]
	[flameshot org.flameshot.Flameshot]
	[vscodium com.vscodium.codium]
	[obs com.obsproject.Studio]
	[podman io.podman_desktop.PodmanDesktop]
	[ferdium org.ferdium.Ferdium]
	[zapzap com.rtosta.zapzap]
	[umftpd eu.ithz.umftpd]
	[blackbox com.raggesilver.BlackBox]
	[netbeans org.apache.netbeans]
	[eclipse org.eclipse.Java]
	[intellij com.jetbrains.IntelliJ-IDEA-Community]
	[skanlite org.kde.skanlite]
	[simple org.gnome.SimpleScan]
]

def names [] {
	$list | rename value description
}

export def main [...names: string@names] {
	let items = ($list | where {|e| $e.name in $names})
  for $item in $items {
		flatpak install flathub -y $item.url
  }
}
