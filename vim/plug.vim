call plug#begin('~/.vim/bundle')
if exists('g:vscode')
else
  source ~/.yadr/vim/packages/ruby.vim
  source ~/.yadr/vim/packages/languages.vim
  source ~/.yadr/vim/packages/git.vim
  source ~/.yadr/vim/packages/appearance.vim
  source ~/.yadr/vim/packages/textobjects.vim
  source ~/.yadr/vim/packages/search.vim
  source ~/.yadr/vim/packages/project.vim
  source ~/.yadr/vim/packages/vim-improvements.vim
endif
call plug#end()
