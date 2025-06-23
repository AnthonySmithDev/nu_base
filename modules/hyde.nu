
export def install [] {
  sudo pacman -S --needed git base-devel
  git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
  cd ~/HyDE/Scripts
  bash ./install.sh
}

export def update [] {
  cd ~/HyDE/Scripts
  git pull origin master
  bash ./install.sh
}

export def "config state" [] {
# $env.HYDE_STATE_HOME
}

export def "config hypridle" [] {
}

export def "config userprefs" [] {
}

export def "config monitors" [] {
}

export def "config waybar" [] {
  ^hyde-shell waybar -u
}

export def "config kitty" [] {
  ^kill -SIGUSR1 kitty
}

export def "config" [] {
  config state
  config hypridle
  config userprefs
  config waybar
  config kitty
}

export def plugins [] {
  sudo pacman -Syu cmake meson cpio pkg-config git gcc

  hyprpm update
  # hyprpm add https://github.com/hyprwm/hyprland-plugins

  hyprpm add https://github.com/KZDKM/Hyprspace
  hyprpm enable Hyprspace
}
