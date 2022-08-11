#!/usr/bin/env bash
# ----------------------------- Variables ----------------------------- #
downloadDir="$HOME/Downloads/apps"

lib32bit="[multilib]
Include = /etc/pacman.d/mirrorlist"

chaoticLib="[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist"

essential="lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lutris meson systemd git dbus -y
"
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Updating system ##
sudo pacman -S archlinux-keyring
sudo pacman -Syyuu

sudo pacman -S flatpak

## Enable write permission to /etc/pacman.conf ##
sudo chmod a+w /etc/pacman.conf

## Installing CHAOTIC AUR ##
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo pacman -Sy && sudo powerpill -Su && paru -Su

## Append (adding to the end of the file) to /etc/pacman.conf ##
sudo echo $chaoticLib >> /etc/pacman.conf

sudo echo $lib32bit >> /etc/pacman.conf
## Enable Multilib for 32- bit support ##

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
sudo pacman -S $essential firefox gparted qbittorrent spotify winetricks -y

## Installing gamemode ##
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.5.1
./bootstrap.sh

## Download e instalaçao de programas externos ##
mkdir "$downloadDir"

## Flatpak packages install ##
flatpak install flathub net.ankiweb.Anki -y
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub org.mozilla.Thunderbird -y
flatpak install flathub com.uploadedlobster.peek -y
flatpak install flathub com.usebottles.bottles -y
flatpak install flathub net.davidotek.pupgui2 -y
flatpak install flathub com.rafaelmardojai.Blanket -y
flatpak install flathub org.gabmus.gfeeds -y
flatpak install flathub sh.ppy.osu -y
flatpak install flathub org.telegram.desktop -y
flatpak install flathub com.stremio.Stremio -y
flatpak install flathub org.gnome.Solanum -y
# ---------------------------------------------------------------------- #

# ----------------------------- Pos-install ----------------------------- #
## Finalização, atualização e limpeza##
sudo pacman -Syu
flatpak update

paru motrix
paru parsec
paru steam
paru discord

# ---------------------------------------------------------------------- #