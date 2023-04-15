#!/bin/bash


#vars
DIR=${HOME}/setup
cron=$(crontab -l)


#functions
welcome () {

    echo "##############################"
    echo "# Welcome to PigOS installer #"
    echo "##############################"
}

passinput () {

    echo "please enter your password"
    read -sp "Password: " pass
    echo
    echo "# Starting install... #"
}

dnf_config () {

    echo "# Configuring DNF for speed #"
    echo "$pass" | sudo sh -c 'echo "#added for speed" >> /etc/dnf/dnf.conf'
    echo "$pass" | sudo sh -c 'echo "fastestmirror = True" >> /etc/dnf/dnf.conf'
    echo "$pass" | sudo sh -c 'echo "max_parallel_downloads = 5" >> /etc/dnf/dnf.conf'
    echo "$pass" | sudo sh -c 'echo "defaultyes = True" >> /etc/dnf/dnf.conf'
    
    echo "# Upgrading your system #"
    sleep 2
    echo "$pass" | sudo dnf upgrade
}

pkg_list () {

    echo "# Installing selected PKGs #"

    sleep 2

    #misc
    echo "$pass" | sudo dnf install opendoas greetd rust cargo lxqt-archiver conky rofi gcc xfce4-power-manager volumeicon xfce4-settings xfce4-power-manager nitrogen dunst pixman polkit-gnome

    #font + polybar
    echo "$pass" | sudo dnf install polybar fontawesome-fonts fontawesome5-fonts fontawesome-fonts-web 

    #term
    echo "$pass" | sudo dnf install alacritty

    #bluetooth + network manager
    echo "$pass" | sudo dnf install bluez bluez-tools bluez-libs blueman NetworkManager

    #term tools +term editor + gui editor
    echo "$pass" | sudo dnf install micro tmux bat wget sed unzip neofetch curl tldr make tree exa acpi cmake ninja-build geany feh meson sxhkd  

    #x11 screenshot
    echo "$pass" | sudo dnf install flameshot 

    #file manager
    echo "$pass" | sudo dnf install thunar

    #xorg server
    echo "$pass" | sudo dnf install xorg-x11-server-Xorg xorg-x11-server-common

    #python + pip3
    echo "$pass" | sudo dnf install python3-pip python-pip-wheel

    #python depencies
    echo $pass | sudo dnf install python3-cffi python3-cairocffi python3-xcffib python3-dbus-next

    echo "# Finished packages installation #"
}

pipewire () {

    read -p "Do you want to install pipwire and related apps Y/N " pipe
    if [ "$pipe" = "y" ]; 
    then echo "$pass" | sudo dnf install pipewire wireplumber pipewire-alsa pipewire-jack pipewire-pulseaudio pavucontrol easyeffects alsa-utils pipewire-jack-audio-connection-kit pipewire-gstreamer pipewire-libs pipewire-utils pipewire-plugin-libcamera pipewire-module-x11
    fi
}

picom_deps () {

    read -p "Would you like to install picom dependecies Y/N " picom
    case $picom in
        y|Y ) echo "Installing..."; 
        echo "$pass" | sudo dnf install dbus-devel gcc git libconfig-devel libdrm-devel libev-devel libX11-devel libX11-xcb libXext-devel libxcb-devel libGL-devel libEGL-devel meson pcre2-devel pixman-devel uthash-devel xcb-util-image-devel xcb-util-renderutil-devel xorg-x11-proto-devel;;
        n|N ) echo "Aborted, skipping...";;
    esac
}

colorscripts_inst () {

    read -p "Would you like to use DT's colorscripts Y/N " colorsc
    case $colorsc in
        y|Y ) echo "Installing..."; 
        echo "$pass" | sudo dnf copr enable foopsss/shell-color-scripts; 
        echo "$pass" | sudo dnf install shell-color-scripts;;
        n|N ) echo "Aborted, skipping...";;
    esac
}

wayland_deps () {

    read -p "Would you like to install wayland packages (why not?) Y/N " wayl
    case $wayl in
        y|Y ) echo "Installing..."; echo "$pass" | sudo dnf install wl-clipboard grim swaybg swayidle swaylock wlroots waybar wofi slurp wf-recorder light yad viewnior imagemagick xorg-xwayland xdg-desktop-portal-wlr qt5-wayland qt6-wayland wireplumber;;
        n|N ) echo "Aborted, skipping...";;
    esac
}

ocs-ur () {
    #Installing ocs-url
    read -p "Would you like to install ocs-url (recommended) Y/N " yesno
    case $yesno in
        y|Y ) echo "Installing..."; echo "$pass" | sudo dnf install ocs-url-3.1.0-1.fc20.x86_64.rpm;;
        n|N ) echo "Aborted, skipping...";;
    esac
}

nix_inst () {

    #Nix install
    read -p "would you like to install NIX Package Manager Y/N " nixinst
    case $nixinst in
        y|Y ) echo "# Starting NIX Package Manager installation... #";
            echo "$pass" | sudo mkdir /nix;
            sudo chown "$USER" /nix;
            curl -L https://nixos.org/nix/install | sh -s -- --no-daemon;
            sleep 45;
            #linking nix apps to usr/share/applications
            echo "$pass" | sudo ln -s /nix/var/nix/profiles/per-user/${HOME}/profile/share/applications /usr/share/applications;
            #adding nix stuff to cron
            echo ${cron} > cfile;
            echo "@reboot nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert" >> cfile;
            echo "@reboot nix-collect-garbage" >> cfile;;
        n|N ) echo "Aborted, skipping...";;
    esac
}

rpm_fusion () {

    echo "# Enabling RPM-Fusion repositories #"
    sleep 3
    #enabling rpm-fusion
    echo "$pass" | sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    echo "$pass"| sudo dnf groupupdate core
    #multimedia and intel codecs
    echo "$pass" | sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    echo "$pass" | sudo dnf groupupdate sound-and-video
    echo "$pass" | sudo dnf install intel-media-driver
}

#does not work
flatpak () {
    command flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    #browser + patchbay + font manager
    flatpak install flathub org.pipewire.Helvum
    flatpak install flathub org.mozilla.firefox
    flatpak install flathub org.gnome.FontManager
}

crontab () {
    #crontab stuff
    echo "# Updating Cron jobs to update on reboot #"
    sleep 2
    echo "@reboot echo $pass | sudo dnf upgrade" >> cfile
    echo "@reboot echo $pass | sudo dnf autoremove" >> cfile
}

wm_dots () {
    #adding arco wm dots to .config
    mv ${DIR}/wmdots/* ${HOME}
    mv ${HOME}/'spectrwm' 'qtile'  'awesome' 'cwm' ${HOME}/.config
}

sysctl_stuff () {

    sudo systemctl enable bluetooth
    sudo systemctl enable acpid
}

cronmerge () {

    crontab cfile
}

zsh_inst () {

    echo " " | sudo dnf install zsh
    echo "/bin/zsh" | sudo lchsh "$USER"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

cleanup () {
    echo "# Running cleanup #"
    echo "$pass" | sudo dnf autoremove
}

goodbye () {
    echo "# Please Reboot!! #"
    sleep 6
}

#main
main () {

    welcome
    sleep 2
    passinput
    sleep 2
    dnf_config
    sleep 2
    rpm_fusion
    sleep 2
    pkg_list
    sleep 2
    #flatpak | DOES NOT WORK, LINES 152-156
    sleep 2
    picom_deps
    sleep 2
    colorscripts_inst
    sleep 2
    wayland_deps
    sleep 2
    pipewire
    sleep 2
    ocs-ur
    sleep 2
    nix_inst
    sleep 2
    crontab
    sleep 2
    wm_dots
    sleep 2
    sysctl_stuff
    sleep 2
    cronmerge
    sleep 2
    sleep 2
    cleanup
    sleep 2
    goodbye
    zsh_inst
    
}

#running functions
main

