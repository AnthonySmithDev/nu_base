
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
 
sudo pacman -Sy chafa
yay -Sy timg

sudo pacman -Syu vivaldi --noconfirm
sudo pacman -Syu ffmpegthumbnailer --noconfirm

sudo pacman -S nautilus
sudo pacman -S gnome-disk-utility
sudo pacman -Syu ffmpegthumbnailer tumbler


sudo pacman -S qemu libvirt virt-manager ebtables dnsmasq

sudo systemctl enable --now libvirtd
sudo systemctl status libvirtd
sudo usermod -aG libvirt $env.USER

sudo pacman -S edk2-ovmf
sudo pacman -S spice-vdagent
sudo pacman -Syu qemu-full 
