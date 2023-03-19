#!/usr/bin/bash




echo "##############################"
echo "# Welcome to PigOS installer #"
echo "##############################"

sleep 2

echo

echo "please enter your password"
read -sp "Password: " pass
echo
echo "# Starting install... #"

sleep 3

echo

echo "# Configuring DNF for speed #"
echo "$pass" | sudo sh -c 'echo "#added for speed" >> /etc/dnf/dnf.conf'
echo "$pass" | sudo sh -c 'echo "fastestmirror = True" >> /etc/dnf/dnf.conf'
echo "$pass" | sudo sh -c 'echo "max_parallel_downloads = 5" >> /etc/dnf/dnf.conf'
echo "$pass" | sudo sh -c 'echo "defaultyes = True" >> /etc/dnf/dnf.conf'


echo "# Upgrading your system #"

echo

sleep 2

echo "$pass" | sudo dnf upgrade

sleep 2

echo "# Installing selected PKGs #"

sleep 2

echo "$pass" | sudo dnf install tldr make curl tree fontawesome-fonts fontawesome-fonts-web sed unzip neofetch alacritty micro tmux bat flameshot opendoas kf5-krunner bluez Thunar firefox wget geany greetd rust cargo

sleep 2



read -p "Would you like to use wayland Y/N " wayl
case $yesno in
    y|Y ) echo "Installing..."; echo $pass | sudo dnf install wl-clipboard pipewire grim swaybg swayidle swaylock wlroots waybar wofi foot mako slurp wf-recorder light yad viewnior imagemagick xfce-polkit xorg-xwayland xdg-desktop-portal-wlr;;
    n|N ) echo "Aborted, skipping...";;
esac

sleep 2

if [ $wayl = 'y' ]; then
    #hyprland dependencies and git clone
    read -p "Would you like to install Hyprland dependencies and clone Hyprland Y/N " hyprinst
    case $hyprinst in
        y|Y ) echo "Installing..."; echo "$pass" | sudo dnf install ninja-build cmake meson gcc-c++ libxcb-devel libX11-devel pixman-devel wayland-protocols-devel cairo-devel pango-devel; git clone --recursive https://github.com/hyprwm/Hyprland;;
        n|N ) echo "Aborted, skipping..."
    esac
fi

sleep 2

#Installing ocs-url
read -p "Would you like to install ocs-url (recommended) Y/N " yesno
case $yesno in
    y|Y ) echo "Installing..."; echo "$pass" | sudo dnf install ocs-url-3.1.0-1.fc20.x86_64.rpm;;
    n|N ) echo "Aborted, skipping...";;
esac



sleep 5

#Nix install
read -p "would you like to install NIX Package Manager Y/N " nixinst
case $nixinst in
    y|Y ) echo "# Starting NIX Package Manager installation... #"
        echo "$pass" | sudo mkdir /nix
        sudo chown "$USER" /nix
        curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
        sleep 45
        #linking nix apps to usr/share/applications
        echo "$pass" | sudo ln -s /nix/var/nix/profiles/per-user/"$HOME"/profile/share/applications /usr/share/applications
        echo "@reboot nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert @reboot nix-collect-garbage" | crontab -e;;
    n|N ) echo "Aborted, skipping..."
esac

sleep 5
echo
echo "# Enabling RPM-Fusion repositories #"
sleep 3
#enabling rpm-fusion
echo "$pass" | sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo "$pass"| sudo dnf groupupdate core
#multimedia and intel codecs
echo "$pass" | sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
echo "$pass" | sudo dnf groupupdate sound-and-video
echo "$pass" | sudo dnf install intel-media-driver

sleep 5

#crontab stuff(not sure if it works)
echo "# Updating Cron jobs to update on reboot #"
sleep 2
echo '@reboot echo "$pass" | sudo dnf upgrade 
@reboot echo "$pass" | sudo dnf autoremove' | crontab -e

sleep 5

#mkdir "$HOME"/.config/polybar

#git cloning
#git clone https://github.com/adi1090x/polybar-themes '$HOME/.config/polybar'
git clone https://github.com/catppuccin/alacritty.git '$HOME/.config/alacritty'

#echo "1" | sh "$HOME"/.config/polybar/polybar-themes/setup.sh


mv "$HOME"/setup/neofetch/config.conf "$HOME"/.config/neofetch


echo "# Installing ZSH for Humans #"
sleep 2
#install zsh4humans (PUT AT THE END)
if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
else
    sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh4humans/v5/install)"
fi


echo "# Running cleanup #"
echo "$pass" | sudo dnf autoremove


echo "# Please Reboot!! #"

sleep 8

done