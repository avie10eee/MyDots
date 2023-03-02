#!/usr/bin/bash

echo " " | sudo sh -c 'echo "#added for speed" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "fastestmirror = True" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "max_parallel_downloads = 5 = True" >> /etc/dnf/dnf.conf'
echo " " | sudo sh -c 'echo "defaultyes = True" >> /etc/dnf/dnf.conf'


echo " " | sudo dnf upgrade


#install pkgs
echo " " | sudo dnf install tldr cmake curl wget git fzf tree sl latte-dock fontawesome-fonts fontawesome-fonts-web polybar conky pulseaudio virt-manager qemu bash coreutils edk2-tools grep jq lsb procps python3 genisoimage usbutils util-linux sed spice-gtk-tools swtpm wget xdg-user-dirs xrandr unzip rofi


sudo mkdir /nix
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
echo " " | sudo dnf install ocs-url-3.1.0-1.fc20.x86_64.rpm

#curl stuff: 1=moe-dark-look-and-feel-global-theme 2=colloid-full-icon-theme
https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1645543295/Moe-Dark.tar.gz?response-content-disposition=attachment%3B%2520Moe-Dark.tar.gz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20230302%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230302T034956Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=e01c061458c6e8bc5415cf37ed72207212622c18bc12b57aee9d075c44718b25
https://ocs-dl.fra1.cdn.digitaloceanspaces.com/data/files/1639061356/Colloid-teal.tar.xz?response-content-disposition=attachment%3B%2520Colloid-teal.tar.xz&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=RWJAQUNCHT7V2NCLZ2AL%2F20230302%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230302T035348Z&X-Amz-SignedHeaders=host&X-Amz-Expires=60&X-Amz-Signature=8628932a39e5b7d2893f497ebd322c1e54475d78e13ccf56172990ec84f748eb


#crontab stuff(not sure if it works)
echo "@reboot /~/$USER/startup.sh
@reboot echo " " | sudo dnf upgrade
@reboot nix-channel --update; nix-env -iA nixpkgs.nix nixpkgs.cacert
@reboot nix-collect-garbage" | crontab -e


#git cloning
git clone https://github.com/avie10eee/rofi
git clone https://github.com/adi1090x/polybar-themes
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


mv rofi ~/.config

mkdir ~/.config/polybar
mv polybar-themes/* ~/.config/
echo "1" | sh ~/.config/polybar/setup.sh



#after-reboot
touch after-reboot.txt
echo "nix-env -iA nixpkgs.quickemu nixpkgs.pywal nixpkgs.networkmanager_dmenu , git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" > after-reboot.sh


#install zsh and ohmyzsh (PUT AT THE END)
echo " " | sudo dnf install zsh
echo "/bin/zsh" | sudo lchsh $USER
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/ZSH_THEME=""/ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc

echo " " | sudo reboot


