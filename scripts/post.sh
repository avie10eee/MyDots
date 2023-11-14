#!/bin/bash

#check if user is root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    exit 1
fi


#vars

#nerd font
NERDF="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"

#functions

checks () {
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Please install it and try again."
        exit 1
    fi

    
    if ! command -v wget &> /dev/null; then
    echo "Wget is not installed. Please install it and try again."
    return
    fi

    if ! command -v unzip &> /dev/null; then
    echo "Unzip is not installed. Please install it and try again."
    return
    fi

}


#welcomes the user
welcome () {
    echo "################################"
    echo "# this is post PigOS installer #"
    echo "################################"
}

#configures micro text editor
micro_conf () {

    if [ ! -d "${HOME}/.config/micro" ]; then
        mkdir -p "${HOME}/.config/micro"
    fi

    echo "# Adding micro configuration #"

    echo '{
        "autosave": 1,
        "hlsearch": true,
        "colorscheme": "gruvbox"
    }' > "${HOME}"/.config/micro/settings.json

    #plugins
    micro -plugin install detectindent manipulator filemanager quoter
}

#configures zshell
zsh_conf () {

    if [ ! -d "${HOME}/.oh-my-zsh/custom/themes" ]; then
    mkdir -p "${HOME}/.oh-my-zsh/custom/themes"
    fi

    if [ ! -d "${HOME}/.oh-my-zsh/custom/plugins" ]; then
    mkdir -p "${HOME}/.oh-my-zsh/custom/plugins"
    fi

    echo "Configuring zshrc"

    #p10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    #extensions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    if [ -f "${HOME}/setup/.zshrc" ]; then
    echo "${HOME}/setup/.zshrc" >> "${HOME}/.zshrc"
    else
    echo "${HOME}/setup/.zshrc" > "${HOME}/.zshrc"
    fi

    #adding zsh plugins
    sed -i 's|ZSH_THEME=""|ZSH_THEME="powerlevel10k/powerlevel10k"|' ${HOME}/.zshrc
    sed -i 's/plugins=(git)/plugins=(zsh-syntax-highlighting zsh-autosuggestions)/' ${HOME}/.zshrc

}

#installs jetbrains mono nerd font
nerd_font () {

    if [ ! -d "${HOME}/.fonts/truetype" ]; then
    mkdir -p "${HOME}/.fonts/truetype"
    fi


    read -p "Would you like to install JetBrainsMono nerd font Y/N " fontinst
    if [ $fontinst = 'y' ]; then
    echo "# Adding Nerd fonts to system #"
    wget -q ${NERDF} -P "${HOME}/Downloads/"
    unzip "${HOME}/Downloads/JetBrainsMono.zip" -d "${HOME}/.fonts/truetype"
    fc-cache
    else
    echo "Skipping Nerd fonts installation"
    fi
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

    checks
    sleep 2
    welcome
    sleep 2
    micro_conf
    sleep 2
    nerd_font
    sleep 2
    gooodbye
    sleep 6
}

# running functions
main