
sudo pacman -Syu --noconfirm

sudo pacman -S unzip

sudo pacman -S docker
sudo pacman -S docker-compose

sudo systemctl enable --now docker
sudo systemctl status docker
sudo usermod -aG docker $env.USER

sudo pacman -S kitty
sudo pacman -S alacritty

sudo pacman -S openssh
sudo systemctl enable --now sshd
sudo systemctl status docker

# hx /usr/share/applications/brave-browser.desktop 
# Exec=brave --enable-features=UseOzonePlatform --ozone-platform=wayland %U
