
sudo pacman -Syu --noconfirm

sudo pacman -Sy unzip --noconfirm
sudo pacman -Syu --needed --noconfirm brave-browser

sudo pacman -Sy docker --noconfirm
sudo pacman -Sy docker-compose --noconfirm

sudo systemctl enable --now docker
sudo systemctl status docker
sudo usermod -aG docker $env.USER

sudo pacman -Sy kitty
sudo pacman -Sy alacritty

sudo pacman -Sy openssh --noconfirm
sudo systemctl enable --now sshd
sudo systemctl status docker

yay -S vieb-bin --noconfirm

# hx /usr/share/applications/brave-browser.desktop 
# Exec=brave --enable-features=UseOzonePlatform --ozone-platform=wayland %U
