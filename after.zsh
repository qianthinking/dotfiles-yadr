# You need link it to ~/.zsh.after/ manually

#export PROMPT_RUBY_INFO=true
#export PROMPT_NODE_INFO=true
#export ENABLE_PYENV=true
if [ "$ENABLE_PYENV" = true ]; then
  profile_script_start "pyenv"
  if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
  profile_script_start "virtualenv"
  if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
fi

profile_script_start "iterm2"
test -s "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

setopt no_complete_aliases
profile_script_start "scm_breeze"
test -s "${HOME}/.scm_breeze/scm_breeze.sh" && source "${HOME}/.scm_breeze/scm_breeze.sh"

#test -s "${HOME}/.yadr/bin/aws_zsh_completer.sh" && source "$HOME/.yadr/bin/aws_zsh_completer.sh"

# profile_script_start "java"
# export JAVA_HOME=$(/usr/libexec/java_home -v1.17)
# export PATH=$HOMEBREW_PREFIX/opt/libpq/bin:$JAVA_HOME/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH

test -d "$HOMEBREW_PREFIX/opt/openssl@1.1" && export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@1.1"
profile_script_start "end"
export CC='ccache gcc'
export CXX='ccache g++'

# Define your own backward-kill-word-match function
backward-kill-word-match() {
    local WORDCHARS='[A-Za-z0-9_]'
    zle backward-kill-word
}
zle -N backward-kill-word-match
bindkey '^W' backward-kill-word-match
