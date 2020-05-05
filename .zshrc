# command history settings
HISTFILE=~/.histfile
HISTSIZE=1728
SAVEHIST=20736

# zsh options
setopt appendhistory nomatch HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS
unsetopt autocd beep extendedglob notify

# vim-like key bindings
bindkey -v

zstyle :compinstall filename '/home/banana/.zshrc'

autoload -Uz compinit
compinit

# zsh plugins
source ~/.zsh_plugins.sh

# zsh aliases
source ~/.aliases.sh

# zsh functions
source ~/.zsh_functions.sh

# zsh "pure" theme
autoload -U promptinit; promptinit
prompt pure
