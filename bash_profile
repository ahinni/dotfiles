export BASH_SILENCE_DEPRECATION_WARNING=1

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi
if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

source ~/.bash/aliases
source ~/.bash/functions
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/history_config
# source ~/.dcConfig/settings

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi


# Covers old homebrew bash-completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

#. /usr/local/etc/bash_completion.d/git-completion.bash
#. /usr/local/etc/bash_completion.d/git-prompt.sh
#. /usr/local/etc/bash_completion.d/docker

# Enable RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Enable NVM if not already enabled
if [ -z $NVM_DIR ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Enable jenv
if [ -f ~/.jenv/bin/jenv ]; then
	export PATH="$HOME/.jenv/bin:$PATH"
	export JENV_ROOT=/usr/local/opt/jenv
	eval "$(jenv init -)"
fi

export PATH="/usr/local/opt/python@3.9/libexec/bin:/usr/local/opt/ruby/bin:$PATH"
if [ -f ~/.cargo/env ]; then
	. "$HOME/.cargo/env"
fi
export PATH="/opt/homebrew/bin:$PATH"

# Homebrew bash completion scripts. TODO: make sure not conflicting with local ones
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="$PATH:/Users/aaron/.modular/bin"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
