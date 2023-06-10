#!/bin/bash


#vars
#setting the dir
DIR="{$HOME}/setup"

#nerd font: jetbrains mono (my fav)
NERDF=https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip

#functions
#welcomes the user
welcome () {
    echo "################################"
    echo "# this is post PigOS installer #"
    echo "################################"
}

#configures micro text editor
micro_conf () {

    echo "# Adding micro configuration #"

    mkdir -p ${HOME}/.config/micro/colorschemes
    mv ${DIR}catppuccin-mocha.micro ${HOME}/.config/micro/colorschemes

    echo '{
        "autosave": 1,
        "hlsearch": true,
        "colorscheme": "gruvbox",
    }' > ${HOME}/.config/micro/settings.json

    #plugins
    micro -plugin install detectindent manipulator filemanager quoter
}

#configures tmux multiplexer
tmux_conf () {
    #turning on mouse in tmux
    echo "set -g mouse on" >> ${HOME}/.tmux.conf
}

#configures zshell
zsh_conf () {
    echo "Configuring zshrc"

    #p10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    #extensions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    echo "${HOME}/setup/.zshrc" >> .zshrc

    #adding zsh plugins
    sed -i 's|ZSH_THEME=""|ZSH_THEME="powerlevel10k/powerlevel10k"|' ${HOME}/.zshrc
    sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/' .zshrc

}

#adds a script script that changes the wallpaper
wallpaper () {
    mkdir .wallpapers
    cp "${DIR}/wallpapers" ".wallpapers"
    mv "${DIR}/setup/.autobg.sh" ${HOME}
}

#configures DT'S colorscipts to my liking (feel free to change)
#colorscript_conf () {
#
#    read -p "Have you installed DT's colorscripts Y/N " colorsc
#    if [ "$colorsc" = 'y' ]; then
#        echo "# Configuring DT's colorscripts"
#        sleep 2
#        colorscript -b xmonad
#        colorscript -b tiefighter2
#        colorscript -b tiefighter1row
#        colorscript -b tifighter1
#        colorscript -b thebat2
#        colorscript -b spectrum
#        colorscript -b pukeskull
#        colorscript -b mouseface2
#        colorscript -b guns
#        colorscript -b colorbars
#        colorscript -b bloks
#        colorscript -b blok
#    fi
#}

#installs jetbrains mono nerd font
nerd_font () {
    read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
    case $fontinst in
        y|Y ) echo "# Adding Nerd fonts to ${HOME}/.fonts/truetype #"; 
        mkdir -p ${HOME}/.fonts/truetype; wget -q ${NERDF}; 
        unzip "${HOME}/JetBrainsMono.zip" -d "${HOME}/.fonts/truetype"; 
        fc-cache;;

        n|N ) echo "Aborted, skipping...";;
    esac
}

#configures neofetch
neofetch_conf () {
    #moving neofetch config to .config
    mv ${DIR}/neofetch/config.conf ${HOME}/.config/neofetch
}

#configures the sudo alternative "doas"
doas_conf () {
    echo "Configuring doas"
    echo "add the following to /etc/doas.conf" > doas.txt
    echo "permit persist keepenv ${USER} as root" >> doas.txt
}

#install a picom fork with blur and rounded corners
picom () {
    read -p "Would you like to install Picom Y/N " jona
    if [ "$jona" = 'y' ]; then
        nix-env -iA nixpkgs.picom-jonaburg
    fi
}

#adds nix-channel-unstable for newer packages
nixunstable () {
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable
    nix-channel --update
}

#adds desktop entries for WM's
qtile_desktop () { cat <<EOF > /usr/share/xsessions/qtile.desktop
    [Desktop Entry]
    Name=Qtile
    Comment=Qtile Window Manager
    Exec=qtile start
    Type=Application
    Keywords=wm;tiling
EOF
}

#says goodbye to the user
gooodbye () {
    echo "
    Thank you for using the PigOS script
    I would recommend rebooting
    Goodbye ${USER}"
    sleep 5
}

#main
main () {

    welcome
    sleep 2
    nixunstable
    sleep 2
    micro_conf
    sleep 2
    tmux_conf
    sleep 2
    zsh_conf
    sleep 2
    wallpaper
    sleep 2
    nerd_font
    sleep 2
    doas_conf
    sleep 2
    neofetch_conf
    sleep 2
    picom
    sleep 2
    qtile_desktop
    sleep 2
    gooodbye
    sleep 6
}

# running functions
main