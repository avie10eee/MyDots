#!/usr/bin/bash

echo " " | sudo dnf upgrade

mkdir /nix
chown $USER /nix

#installing nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

#linking nix apps to usr/share/applications
echo " " | sudo ln -s /nix/var/nix/profiles/per-user/$USER/profile/share/applications /usr/share/applications

#enabling rpm-fuision
echo " " | sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo " " | sudo dnf groupupdate core
#multimedia and intel codecs
echo " " | sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
echo " " | sudo dnf groupupdate sound-and-video
echo " " | sudo dnf install intel-media-driver

#making cron readable
echo " " | sudo chmod r+x /var/spool/cron/

#crontab stuff(not sure if it works)
echo "@reboot /~/$USER/startup.sh
@reboot echo " " | sudo dnf upgrade
@reboot nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert
@reboot nix-collect-garbage" | crontab -e

git clone https://github.com/avie10eee/rofi
git clone https://github.com/adi1090x/polybar-themes

#install pkgs
echo " " | sudo dnf install python tldr cmake curl wget git fzf tree ocs-url sl latte-dock.x86_64 fontawesome-fonts fontawesome-fonts-web polybar conky pulseaudio 

#nix stuff(might work)
echo "vscodium, quickemu, virtmanager, pywal, Moe Dark Look-and-Feel(store.kde.org/p/1717596) , rpmfuision website, dnf.readthedocs.io/en/latest/conf_ref.html" > 


#install zsh and ohmyzsh (PUT AT THE END)
echo " " | sudo dnf install zsh
echo "/bin/zsh" | sudo lchsh $USER
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


