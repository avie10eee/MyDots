#!/usr/bin/bash

echo "##############################"
echo "# Welcome to PigOS installer #"
echo "##############################"

sleep 10

echo "# Configuring DNF for speed #"
echo " " | sudo sh -c 'echo "#added for speed" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "fastestmirror = True" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "max_parallel_downloads = 5 = True" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "defaultyes = True" >> /etc/dnf/dnf.conf'


echo "# Upgrading your system #"
echo " " | sudo dnf upgrade

sleep 10

echo "# Installing selected PKGs #"
echo " " | sudo dnf install tldr make curl tree sl fontawesome-fonts fontawesome-fonts-web sed unzip neofetch alacritty micro tmux wl-clipboard bat flameshot opendoas kf5-krunner pipewire grim bluez Thunar firefox wget

#Installing ocs-url
while true: do
    read -p "Would you like to install ocs-url (recommended) Y/N" yesno
    case $yesno in
        [Yy]* ) 
            echo "Installing..."
            echo " " | sudo dnf install ocs-url-3.1.0-1.fc20.x86_64.rpm
        ;;
        [Nn]* ) 
            echo "Aborted, skipping..."
            exit
        ;;
        * ) echo "Y/N";;
    esac
done


sleep 60

#Nix install
while true: do
    read -p "would you like to install NIX Package Manager Y/N" nixinst
    case $nixinst in
        [Yy]* ) 
            echo "# Starting NIX Package Manager installation... #"
            echo " " | sudo mkdir /nix
            echo " " | chown $USER /nix
            curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
            sleep 45
            #linking nix apps to usr/share/applications
            echo " " | sudo ln -s /nix/var/nix/profiles/per-user/$USER/profile/share/applications /usr/share/applications
            echo "@reboot nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert
            @reboot nix-collect-garbage" | crontab -e
        ;;
        [Nn]* ) 
            echo "Aborted, skipping..."
            exit
        ;;
        * ) echo "Y/N";;
    esac
done

sleep 60

echo "# Enabling RPM-Fusion repositories #"
sleep 3
#enabling rpm-fusion
echo " " | sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo " " | sudo dnf groupupdate core
#multimedia and intel codecs
echo " " | sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
echo " " | sudo dnf groupupdate sound-and-video
echo " " | sudo dnf install intel-media-driver

sleep 60

#Hyprland
#echo " " | sudo dnf install ninja-build cmake meson gcc-c++ libxcb-devel libX11-devel pixman-devel wayland-protocols-devel cairo-devel pango-devel
#git clone --recursive https://github.com/hyprwm/Hyprland


#crontab stuff(not sure if it works)
echo "# Updating Cron jobs to update on reboot #"
sleep 5
echo "@reboot echo " " | sudo dnf upgrade
@reboot echo " " | sudo dnf autoremove" | crontab -e

sleep 60

#mkdir ~/.config/polybar

#git cloning
#git clone https://github.com/adi1090x/polybar-themes "~/.config/polybar"
git clone https://github.com/catppuccin/alacritty.git "~/.config/alacritty"

#echo "1" | sh ~/.config/polybar/polybar-themes/setup.sh

while true: do
    read -p "Would you like to install JetBrainsMono.zip Y/N" fontinst
    case $fontinst in
        [Yy]* ) 
            echo "# Adding Nerd fonts to ~/.fonts/truetype #"
            sleep 5
            mkdir ~/.fonts && mkdir ~/.fonts/truetype
            wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
            mv JetBrainsMono.zip ~/.fonts/truetype
            unzip ~/.fonts/truetype/JetBrainsMono.zip
        ;;
        [Nn]* ) 
            echo "Aborted, skipping..."
            exit
        ;;
        * ) echo "Y/N";;
    esac
done





mv ~/setup/neofetch/config.conf ~/.config/neofetch


echo "# Adding micro configuration #"
echo "{
    "autosave": 1,
    "hlsearch": true
}" > ~/.config/micro/settings.json


#after-reboot
echo "nix-env -iA nixpkgs.quickemu nixpkgs.pywal nixpkgs.tty-clock" > ~/postinst.txt
echo "cd Hyprland
meson _build
ninja -C _build
sudo ninja -C _build install" > ~/hyprinstall


#tmux config
echo "set -g mouse on" >> ~/.tmux.conf


echo "# Installing ZSH for Humans #"
#install zsh4humans (PUT AT THE END)
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
    sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi


echo "alias sudo="doas"" >> .zshrc
echo "neofetch" >> .zshrc

echo "# Please Reboot!! #"


