# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something
alias -g GV='| grep -v grep'
alias -g A='| awk'
alias -g P1='"{print \$1}"'
alias -g P2='"{print \$2}"'
alias -g P3='"{print \$3}"'
alias -g K='| xargs kill'
alias -g K9='| xargs kill -9'

alias -g be='bundle exec' #shorter, or see prezto/modules/ruby
