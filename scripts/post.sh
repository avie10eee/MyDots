#!/bin/bash

DIR={$HOME}/setup
NERDF=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip

echo "################################"
echo "# this is post PigOS installer #"
echo "################################"


echo "# Adding micro configuration #"
echo '{
    "autosave": 1,
    "hlsearch": true
    "colorscheme": "gruvbox"
}' > ${HOME}/.config/micro/settings.json

micro -plugin install detectindent manipulator filemanager quoter



#tmux config
echo "set -g mouse on" >> ${HOME}/.tmux.conf

#zshrc
echo "Configuring zshrc"

echo "${HOME}/setup/.zshrc" >> .zshrc


mkdir .wallpapers
cp "${DIR}/wallpapers" ".wallpapers"
mv "${DIR}/setup/autobg.sh" ${HOME}


read -p "Would you like configure DT's colorscripts Y/N " colorsc
if [ "$colorsc" = 'y' ]; then
    echo "# Configuring DT's colorscripts"
    sleep 2
    colorscript -b xmonad
    colorscript -b tiefighter2
    colorscript -b tiefighter1row
    colorscript -b tifighter1
    colorscript -b thebat2
    colorscript -b spectrum
    colorscript -b pukeskull
    colorscript -b mouseface2
    colorscript -b guns
    colorscript -b colorbars
    colorscript -b bloks
    colorscript -b blok
fi



mkdir -p ${HOME}/.config/micro/colorschemes
mv ${DIR}catppuccin-mocha.micro ${HOME}/.config/micro/colorschemes
#ADD THE COLORSCHEME CHANGE!!!!!!!!


read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
case $fontinst in
    y|Y ) echo "# Adding Nerd fonts to ${HOME}/.fonts/truetype #"; mkdir -p ${HOME}/.fonts/truetype; wget -q ${NERDF}; unzip "${HOME}/JetBrainsMono.zip" -d "${HOME}/.fonts/truetype"; fc-cache;;
    n|N ) echo "Aborted, skipping...";;
esac

read -p "Do you want to install some WM's with Nix Package Manager Y/N " fontinst
case $fontinst in
    y|Y ) echo "Ok, Installing... "; nix-env -iA nixpkgs.hyprland nixpkgs.awesome nixpkgs.qtile nixpkgs.cwm nixpkgs.spectrwm nixpkgs.picom-jonaburg;;
    n|N ) echo "Aborted, skipping...";;
esac


sed -i 's/ZSH_THEME=""/ZSH_THEME="powerlevel10k/powerlevel10k/"' ${HOME}/.zshrc
sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/' .zshrc

#doas
echo "Configuring doas"
echo "add the following to /etc/doas.conf" > doas.txt
echo "permit persist keepenv ${USER} as root" >> doas.txt