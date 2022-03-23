source ~/.bash/aliases
source ~/.bash/functions
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/history_config
source ~/.dcConfig/settings

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# Homebrew bash completion scripts. TODO: make sure not conflicting with local ones
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Enable RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Enable NVM if not already enabled
if [ -z $NVM_DIR ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Enable jenv
export PATH="$HOME/.jenv/bin:$PATH"
export JENV_ROOT=/usr/local/opt/jenv
eval "$(jenv init -)"

export PATH="/usr/local/opt/python@3.9/libexec/bin:/usr/local/opt/ruby/bin:$PATH"
