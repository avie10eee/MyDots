#!/usr/bin/bash

echo "################################"
echo "# this is post PigOS installer #"
echo "################################"

rm cfile

echo "# Adding micro configuration #"
echo "{
    'autosave': 1,
    'hlsearch': true
}" > ${HOME}/.config/micro/settings.json


#tmux config
echo "set -g mouse on" >> ${HOME}/.tmux.conf

#zshrc
echo "Configuring zshrc"

echo "${HOME}/setup/.zshrc" >> .zshrc



read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
case $fontinst in
    y|Y ) echo "# Adding Nerd fonts to ${HOME}/.fonts/truetype #"; mkdir -p ${HOME}/.fonts/truetype; wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip; unzip "${HOME}/JetBrainsMono.zip" -d "${HOME}/.fonts/truetype"; fc-cache;;
    n|N ) echo "Aborted, skipping...";;
esac

read -p "Do you want to install some WM's with Nix Package Manager Y/N " fontinst
case $fontinst in
    y|Y ) echo "Ok, Installing... "; nix-env -iA nixpkgs.hyprland nixpkgs.awesome nixpkgs.qtile nixpkgs.cwm nixpkgs.spectrwm nixpkgs.picom-jonaburg;;
    n|N ) echo "Aborted, skipping...";;
esac

#doas
echo "Configuring doas"
echo "add the following to /etc/doas.conf" > doas.txt
echo "permit persist keepenv ${USER} as root" >> doas.txt