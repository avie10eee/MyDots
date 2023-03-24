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


#after-reboot
#echo "nix-env -iA nixpkgs.quickemu nixpkgs.pywal nixpkgs.tty-clock" > ${HOME}/postinst.txt
#echo "cd Hyprland
#meson _build
#ninja -C _build
#sudo ninja -C _build install" > ${HOME}/hyprinstall


#tmux config
echo "set -g mouse on" >> ${HOME}/.tmux.conf

#zshrc
echo "Configuring zshrc"
echo "Adding exports"
sleep 2
echo 'export TERM="xterm-256color"' >> .zshrc
echo 'export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"' >> .zshrc
echo 'export EDITOR="micro"' >> .zshrc
sleep 2

echo "Adding .config to xdg config home"

sleep 2

echo 'if [ -z "$XDG_CONFIG_HOME" ] ; then'
echo '    export XDG_CONFIG_HOME="$HOME/.config"'

echo "Adding aliases"

sleep 2

echo "alias ls='exa -l --color=always --group-directories-first'" >> .zshrc
echo "alias la='exa -al --color=always --group-directories-first'" >> .zshrc
echo "alias sudo='doas'" >> .zshrc
echo "alias cat='bat'"
echo "alias grep='grep --color=auto'"
echo "neofetch" >> .zshrc
echo "colorscript -r" >> .zshrc

while true; do
    read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
    case $fontinst in
        y|Y ) echo "# Adding Nerd fonts to ${HOME}/.fonts/truetype #"; mkdir -p ${HOME}/.fonts/truetype; wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip; unzip "${HOME}/JetBrainsMono.zip" -d "${HOME}/.fonts/truetype"; break;;
        n|N ) echo "Aborted, skipping..."; break;;
    esac
done



#doas
echo "Configuring doas"
echo "add the following to /etc/doas.conf" > doas.txt
echo "permit persist keepenv ${USER} as root" >> doas.txt