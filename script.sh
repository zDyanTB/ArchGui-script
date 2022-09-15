#!/usr/bin/env bash
# ----------------------------- Variables ----------------------------- #
essential="lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader lutris meson systemd git dbus 
"

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
com.spotify.Client 
io.github.prateekmedia.appimagepool
md.obsidian.Obsidian
com.ticktick.TickTick"

# --------------------------- Pre-install ----------------------------- #
sudo rm /var/lib/pacman/db.lck

sudo pacman-key --init

echo '[~] Updating old system'
yes | sudo pacman -S archlinux-keyring
sudo pacman -S flatpak # Unable to set yes as default, it request a choice, default=1 #
yes | sudo pacman -Syyuu
# ----------------------------- Hands on ----------------------------- #

# Gaming essential lib #
yes | sudo pacman -S $essential

# Some essential applications #
yes | sudo pacman -S unrar unzip gnome-tweaks btrfs-progs

# Flatpak packages install #
yes | flatpak install flathub $flatpak_apps

# Desktop specifit configuration #
echo '[~] Checking Desktop enviroment'
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then

    # Gnome variables #
    echo '[~] Installing Gnome desktop configurations'.
    themes="/usr/share/themes"
    icons="/usr/share/icons"

    # Gnome flatpak applications #
    gnome_flatpak="
    org.gnome.Boxes
    org.gnome.Platform/x86_64/42
    "
    
    yes | flatpak install flathub $gnome_flatpak
    
elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    echo Using KDE
fi

# Snapd apps # 
snap install scrcpy

# Installing Feral Gamemode #
git clone https://github.com/FeralInteractive/gamemode.git
cd gamemode
git checkout 1.7 # omit to build the master branch
./bootstrap.sh

cd ..

# Installing ZAP AppImage Package manager #
curl -fsSL curl https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh | sh
# ----------------------------- Pos-install ----------------------------- #

# Enable write permission to /etc/pacman.conf #
sudo chmod a+w /etc/pacman.conf

echo '[~] Installing CHAOTIC AUR'
yes | sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
yes | sudo pacman-key --lsign-key FBA220DFC880C036
yes | sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
yes | sudo pacman -Sy && sudo powerpill -Su && paru -Su

# Append (adding to the end of the file) to /etc/pacman.conf #
sudo echo [chaotic-aur]$'\n'Include = /etc/pacman.d/chaotic-mirrorlist >> /etc/pacman.conf

# Enable Multilib for 32- bit support #
sudo echo [multilib]$'\n'Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf

yes | sudo pacman -Syu
flatpak update

echo '[~] Apps to be installed by paru'
echo '
parsec
steam
motrix
discord
qbittorrent
visual-studio-code
brave'

echo '[~] Script finished'
# ---------------------------------------------------------------------- #