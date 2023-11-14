#!/bin/bash


#vars
DIR=${HOME}/setup


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

install_packages() {
    echo "# Installing selected PKGs #"
    sleep 2

    packages=(
        # Misc
        rust cargo conky rofi gcc pavucontrol nitrogen libvirt-daemon-kvm virt-manager libvirt

        # Font
        fontawesome-fonts fontawesome-6-free-fonts fontawesome6-fonts-web

        # Term tools + Term editor + GUI editor
        micro bat wget sed unzip neofetch curl tldr make tree exa acpi cmake feh sxhkd ncdu htop

        # Python + pip3
        python3-pip python-pip-wheel seaborn matplotlib numpy requests pandas

        # Python dependencies
        python3-cffi python3-cairocffi python3-xcffib python3-dbus-next

        git-all git
    )

    sudo dnf install "${packages[@]}"

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
    goodbye
    sleep 2
    
}

#running functions
main

