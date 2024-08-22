" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" share system clipboard
if has("win16") || has("win32") || has("win64")
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" copy to attached terminal using the yank(1) script:
" https://github.com/sunaku/home/blob/master/bin/yank
noremap <silent> <leader>y y:OSCYank<Return>

set mouse=nv "Enable mouse use in all modes
set ttyfast "Send more characters for redraws
if has('nvim')
else
  set ttymouse=xterm2
endif

" complete
set completeopt=menu,menuone,preview
"set completeopt=menuone,menu,longest,preview

set pastetoggle=<F7>
set tags=./.tags;,.tags
map <F10> :!ctags -R --fields=+iaS --output-format=e-ctags --extras=+q -f .tags .<CR>

let g:used_javascript_libs = 'jquery'

au BufNewFile,BufRead *.mxml set filetype=mxml
au BufNewFile,BufRead *.jsp set filetype=java
au BufNewFile,BufRead *.es6 set filetype=javascript
au BufNewFile,BufRead *.as set filetype=actionscript
au BufNewFile,BufRead *.json set filetype=jsonc
au BufNewFile,BufRead {Gemfile,Rakefile,Capfile,*.rake,config.ru} set ft=ruby
au BufNewFile,BufRead *.gradle set filetype=groovy
au BufNewFile,BufRead helmfile.yaml,*.gotmpl set ft=helm

" au FileType * setlocal textwidth=119
" return previous editing position
au BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
au FileType python let python_highlight_all=1
au FileType python setlocal omnifunc=pythoncomplete#Complete

"use coc.vim eslint
au FileType javascript,typescript setlocal ts=2 sts=2 sw=2

au FileType ruby,eruby setlocal ts=2 sts=2 sw=2
au FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
au FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete

au FileType c,cpp setlocal  ts=2 sts=2 sw=2
au FileType c,cpp nnoremap <F6> :YcmForceCompileAndDiagnostics<CR>
au FileType cpp map <F10> :!ctags -R --c++-kinds=+pl --fields=+ialS --extra=+q .<CR>

au FileType erlang let g:erlang_completion_grep='zgrep'
au FileType erlang let g:erlang_man_extension='erl\.gz'
au FileType erlang set nofoldenable
au FileType erlang setlocal ts=4 sts=4 sw=4

au FileType java setlocal ts=4 sts=4 sw=4
au FileType java setlocal makeprg=javac\ -d\ .\ %
au Filetype java setlocal omnifunc=javacomplete#Complete

au FileType tex setlocal ts=2 sts=2 sw=2
au FileType tex setlocal iskeyword+=:

au FileType actionscript setlocal ts=4 sts=4 sw=4
au FileType actionscript setlocal omnifunc=actionscriptcomplete#CompleteAS
au FileType actionscript setlocal dictionary=dict/actionscript.dict
j
au FileType gradle setlocal ts=2 sts=2 sw=2

" Source the vimrc file after saving it
"au bufwritepost .vimrc source ~/.vimrc

"CoffeeScript
"This one compiles silently and with the -b option, but shows any errors:
au BufWritePost *.coffee silent make! -b | cwindow | redraw!
au BufNewFile,BufReadPost *.coffee setl sw=2 ts=2 sts=2 expandtab

" Auto close tab if NERDTree is the only window left
autocmd BufUnload * if winnr('$') == 1 && &filetype == 'NvimTree' | tabclose | endif

au WinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline

" Input method
"set iminsert=0
"set imsearch=0
"se imd
"au InsertEnter * se noimd
"au InsertLeave * se imd
"au FocusGained * se imd

set cul
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

syntax match nonascii "[^\x00-\x7F]"
highlight nonascii guibg=Red ctermbg=2

let g:indentLine_enabled = 0

"Exclude quickfix buffer from `:bnext` `:bprevious`
"https://stackoverflow.com/questions/28613190/exclude-quickfix-buffer-from-bnext-bprevious
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

 " leave insert mode quickly
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

set undofile
let g:snipMate = { 'snippet_version' : 1 }


function! TogglePyrightInlayHints()
    " Check if we are in a Python file
    if &filetype == 'python'
        " Get the current value of the setting
        let current_value = get(g:coc_user_config, 'pyright.inlayHints.variableTypes', 0)

        " Toggle the value
        let new_value = !current_value

        " Update the setting dynamically
        call coc#config('pyright.inlayHints.variableTypes', new_value)

        " Notify the user
        echo 'pyright.inlayHints.variableTypes set to ' . (new_value ? 'enabled' : 'disabled')
    else
        echo 'Not a Python file. Toggle aborted.'
    endif
endfunction

" Create a command to toggle it
command! TogglePyrightInlayHints call TogglePyrightInlayHints()
nnoremap <silent> th :call TogglePyrightInlayHints()<CR>

