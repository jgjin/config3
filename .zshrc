# command history settings
HISTFILE=~/.histfile
HISTSIZE=1728
SAVEHIST=20736

# zsh options
setopt appendhistory nomatch HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS
unsetopt autocd beep extendedglob notify

# emacs-like key bindings, because Termite supports insert and select modes
bindkey -e

zstyle :compinstall filename '/home/banana/.zshrc'

autoload -Uz compinit
compinit
_comp_options+=(globdots)

# source ~/.profile because it's not doing it by itself?
source ~/.zprofile

# zsh plugins
auto-ls-custom_function () {
    ls -AF --color=auto
}
source ~/.zsh_plugins.sh
AUTO_NOTIFY_THRESHOLD=12
AUTO_NOTIFY_EXPIRE_TIME=3000
AUTO_LS_COMMANDS=(custom_function)

# zsh aliases
source ~/.aliases.sh

# zsh functions
source ~/.zsh_functions.sh

# zsh key bindings
source ~/.zsh_keybindings.sh

# zsh "pure" theme
autoload -U promptinit; promptinit
prompt pure
