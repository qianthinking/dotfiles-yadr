#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

PROFILING_ZSH_START=false

profile_script_start() {
  if [ "$PROFILING_ZSH_START" = true ]; then
    date "+%T.%3N start $1"
  fi
}
profile_script_end() {
  if [ "$PROFILING_ZSH_START" = true ]; then
    date "+%T.%3N end $1"
  fi
}

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# put after prezto
profile_script_start "brew init"
# better performance than 'brew --prefix'
if [[ $(uname -m) == "arm64" ]]; then
  BREW_PREFIX="/opt/homebrew"
  fpath=($BREW_PREFIX/share/zsh/functions $BREW_PREFIX/share/zsh/site-functions  $fpath)
else
  BREW_PREFIX="/usr/local"
fi
[ -f $BREW_PREFIX/bin/brew ] && eval "$($BREW_PREFIX/bin/brew shellenv)"

profile_script_start "Prezto init"
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  profile_script_start "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

profile_script_start "customize init"
# Customize to your needs...
for config_file ($HOME/.yadr/zsh/*.zsh) profile_script_start "$config_file" && source $config_file
profile_script_start "completion path"
fpath=(~/.zsh/completion $fpath)

export ASDF_DATA_DIR="${HOME}/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
# source "${HOME}/.asdf/asdf.sh"
fpath=(${ASDF_DIR}/completions $fpath)
zstyle ':completion::complete:*' use-cache 1
profile_script_start "completion init"

autoload -Uz compinit && compinit

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export HOSTNAME=$HOST
