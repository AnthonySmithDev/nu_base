
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
	[intellij com.jetbrains.IntelliJ-IDEA-Community]
	[ferdium org.ferdium.Ferdium]
	[zapzap com.rtosta.zapzap]
	[umftpd eu.ithz.umftpd]
	[blackbox com.raggesilver.BlackBox]
	[netbeans org.apache.netbeans]
	[eclipse org.eclipse.Java]
	[skanlite org.kde.skanlite]
	[simple org.gnome.SimpleScan]
	[resources net.nokyan.Resources]
	[planify io.github.alainm23.planify]
	[fragments de.haeckerfelix.Fragments]
	[varia io.github.giantpinkrobots.varia]
	[qbittorrent org.qbittorrent.qBittorrent]
	[multiplex com.pojtinger.felicitas.Multiplex]
	[vlc org.videolan.VLC]
	[open-tv dev.fredol.open-tv]
	[alpaca com.jeffser.Alpaca]
	[steam com.valvesoftware.Steam]
	[bottles com.usebottles.bottles]
	[mixxx org.mixxx.Mixxx]
	[connections org.gnome.Connections]
	[remmina org.remmina.Remmina]
	[deskflow org.deskflow.deskflow]
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
