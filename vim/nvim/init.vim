set runtimepath^=~/.vim runtimepath+=~/.vim/after
"echo "runtimepath: " . &runtimepath
let &packpath = &runtimepath
"echom "packpath: " . &packpath
source ~/.vimrc
