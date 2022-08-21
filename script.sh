#!/usr/bin/env bash
# ----------------------------- Variables ----------------------------- #
essential="lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lutris meson systemd git dbus 
"
# Gnome variables #
themes="/usr/share/themes"
icons="/usr/share/icons"

flatpak_apps="
net.ankiweb.Anki
com.mattjakeman.ExtensionManager 
org.mozilla.Thunderbird 
com.uploadedlobster.peek 
com.usebottles.bottles 
net.davidotek.pupgui2 
com.rafaelmardojai.Blanket 
org.gabmus.gfeeds 
sh.ppy.osu 
org.telegram.desktop 
com.stremio.Stremio 
org.gnome.Solanum
com.spotify.Client 
org.gnome.Boxes
in.srev.guiscrcpy
io.github.prateekmedia.appimagepool"

# ----------------------------- Pre-install ----------------------------- #

# Updating system #
yes | sudo pacman -S archlinux-keyring flatpak
yes | sudo pacman -Syyuu

yes | sudo pacman-key --init

# Installing CHAOTIC AUR #
sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key FBA220DFC880C036
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Enable write permission to /etc/pacman.conf #
sudo chmod a+w /etc/pacman.conf

# Append (adding to the end of the file) to /etc/pacman.conf #
sudo echo [chaotic-aur]$'\n'Include = /etc/pacman.d/chaotic-mirrorlist >> /etc/pacman.conf

sudo pacman -Sy && sudo powerpill -Su && paru -Su

# Enable Multilib for 32- bit support #
sudo echo [multilib]$'\n'Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf

# ----------------------------- Hands on ----------------------------- #

yes | sudo pacman -Syu

# Gaming essential lib #
yes | sudo pacman -S $essential

# Some essential applications #
yes | sudo pacman -S unrar unzip gnome-tweaks btrfs-progs

# Installing ZAP AppImage Package manager #
curl -fsSL curl https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh | sh

# Installing Feral Gamemode #
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.5.1
./bootstrap.sh

cd ..

# Flatpak packages install #
flatpak_install="yes | flatpak install flathub"
$flatpak_install $flatpak_apps

# ----------------------------- Pos-install ----------------------------- #

paru ; flatpak update

echo "Apps to be installed with Paru" 
paru parsec
paru steam
paru motrix
paru discord
paru qbittorrent
paru visual-studio-code
paru brave

# ---------------------------------------------------------------------- #