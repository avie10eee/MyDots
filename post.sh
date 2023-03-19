#!/usr/bin/bash

echo "################################"
echo "# this is post PigOS installer #"
echo "################################"

echo "# Adding micro configuration #"
echo "{
    'autosave': 1,
    'hlsearch': true
}" > "$HOME"/.config/micro/settings.json


#after-reboot
echo "nix-env -iA nixpkgs.quickemu nixpkgs.pywal nixpkgs.tty-clock" > "$HOME"/postinst.txt
echo "cd Hyprland
meson _build
ninja -C _build
sudo ninja -C _build install" > "$HOME"/hyprinstall


#tmux config
echo "set -g mouse on" >> "$HOME"/.tmux.conf

echo "alias sudo='doas'" >> .zshrc
echo "neofetch" >> .zshrc

while true; do
    read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
    case $fontinst in
        y|Y ) echo "# Adding Nerd fonts to "$HOME"/.fonts/truetype #"; mkdir "$HOME"/.fonts && mkdir "$HOME"/.fonts/truetype; wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip; unzip "$HOME"/JetBrainsMono.zip -d "$HOME"/.fonts/truetype;;
        n|N ) echo "Aborted, skipping..."
    esac

done