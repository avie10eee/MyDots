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

dnf_config () {

    echo "# Configuring DNF for speed #"
    sudo sh -c 'echo "#added for speed" >> /etc/dnf/dnf.conf'
    sudo sh -c 'echo "fastestmirror = True" >> /etc/dnf/dnf.conf'
    sudo sh -c 'echo "max_parallel_downloads = 5" >> /etc/dnf/dnf.conf'
    sudo sh -c 'echo "defaultyes = True" >> /etc/dnf/dnf.conf'
    
    echo "# Upgrading your system #"
    sleep 2
    sudo dnf upgrade
}

pkg_list () {

    echo "# Installing selected PKGs #"

    sleep 2

    #misc
    sudo dnf install rust cargo lxqt-archiver conky rofi gcc pavucontrol volumeicon nitrogen dunst pixman

    #font
    sudo dnf install fontawesome-fonts fontawesome-6-free-fonts fontawesome6-fonts-web 

    #term
    sudo dnf install alacritty kitty

    #bluetooth + network manager
    sudo dnf install bluez bluez-tools bluez-libs blueman NetworkManager

    #term tools +term editor + gui editor
    sudo dnf install micro tmux bat wget sed unzip neofetch curl tldr make tree exa acpi cmake geany feh sxhkd  

    #x11 screenshot
    sudo dnf install flameshot 

    #file manager
    sudo dnf install thunar

    #xorg server
    sudo dnf install xorg-x11-server-Xorg xorg-x11-server-common

    #python + pip3
    sudo dnf install python3-pip python-pip-wheel

    #python depencies
    sudo dnf install python3-cffi python3-cairocffi python3-xcffib python3-dbus-next

    sudo dnf install git-all

    echo "# Finished packages installation #"
}

rpm_fusion () {

    echo "# Enabling RPM-Fusion repositories #"
    sleep 3
    #enabling rpm-fusion
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    echo "$pass"| sudo dnf groupupdate core
    #multimedia and intel codecs
    sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    sudo dnf groupupdate sound-and-video
    sudo dnf install intel-media-driver
}

sysctl_stuff () {
    sudo systemctl enable bluetooth
}

zsh_inst () {
    echo " " | sudo dnf install zsh
    echo "/bin/zsh" | sudo lchsh "$USER"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

cleanup () {
    echo "# Running cleanup #"
    sudo dnf autoremove
}

goodbye () {
    echo "# Please Reboot!! #"
    sleep 6
}

#main
main () {

    welcome
    sleep 2
    dnf_config
    sleep 2
    rpm_fusion
    sleep 2
    pkg_list
    sleep 2
    sysctl_stuff
    sleep 2
    cleanup
    sleep 2
    goodbye
    zsh_inst
    
}

#running functions
main

