# Avie6 zsh configuration

export TERMINAL="alacritty"
export BROWSER="firefox"
export VISUAL="code"
export EDITOR="micro"
export "MICRO_TRUECOLOR=1"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="$PATH:/home/avie6/.local/bin"
export ZSH="/home/matt/.config/.oh-my-zsh"


ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions ssh-agent)


# FZF bases
export FZF_DEFAULT_OPTS="
  --color fg:#cdd6f4
  --color fg+:#cdd6f4
  --color bg:#1e1e2e
  --color bg+:#313244
  --color hl:#f38ba8
  --color hl+:#f38ba8
  --color info:#cba6f7
  --color prompt:#cba6f7
  --color spinner:#f5e0dc
  --color pointer:#f5e0dc
  --color marker:#f5e0dc
  --color border:#1e1e2e
  --color header:#f38ba8
  --prompt ' '
  --pointer ' λ'
  "


# Aliases
alias ".." = "cd .." # cd to parent directory
alias ls="exa -l --color=always --group-directories-first" # ls with color and icons
alias la="exa -al --color=always --group-directories-first" # ls -al with color and icons
alias sudo= "doas" # adds a sudo replacement
alias cat= "bat" # makes bat the default for cat
alias grep= "grep --color=auto" # just adds color to grep
alias upgrade= "sudo dnf upgrade && nix-env -u" # upgrades your system
alias wall= "./.autobg.sh" # changes the wallpaper (X11 only)
alias theme= "bash .tswitch.sh" #changes the alacritty theme
alias pyserver="python3 -m http.server" # runs the python server
alias cp="cp -r" # copies recursively
alias rm="rm -r" # removes recursively

#git
alias gm= "git merge $(git branch --show-current)" #merges the current branch to main/master
alias gc= "git commit -am " #commits with a message
alias gl= "git log --graph --oneline --decorate" #shows a graph of commits
alias ga= "git add -A" #adds all files
alias gp= "git push -u origin" #pushes to github