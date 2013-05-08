source ~/.bash/aliases
source ~/.bash/functions
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/history_config

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# Homebrew bash completion scripts. TODO: make sure not conflicting with local ones
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Enable RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Enable NVM
[[ -s $HOME/.nvm/nvm.sh ]] && source $HOME/.nvm/nvm.sh

# Source Perrin's bash bookmarks
[[ -s $HOME/src/bash-bookmarks/bookmarker.sh ]] && source $HOME/src/bash-bookmarks/bookmarker.sh
