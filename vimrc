" ================ Vim only : start ==============
" Neovim has defaults
if !has("nvim")

  " Use Vim settings, rather then Vi settings (much better!).  " This must be first, because it changes other options as a side effect.
  set nocompatible

  set ttyfast
  set backspace=indent,eol,start  "Allow backspace in insert mode
  set history=10000               "Store lots of :cmdline history
  set autoread                    "Reload files changed outside vim
  set autoindent
  set visualbell                  "No sounds
  scriptencoding utf-8
  set encoding=utf-8
  set incsearch                   " Find the next match as we type the search
  set hlsearch                    " Highlight searches by default
  set smarttab
  set showcmd                     "Show incomplete cmds down the bottom set
  set sidescroll=1
  set tags=.tags;,tags
  set tabpagemax=50
  set listchars=tab:\>\ ,trail:-,nbsp:+ " Display tabs and trailing spaces visually
  set wildmenu                    "enable ctrl-n and ctrl-p to scroll thru matches
  set background=dark

endif
" ================ Vim only : end   ==============

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" make Vim 8 slow
" set lazyredraw

set smartindent

 " leave insert mode quickly
if ! has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
  augroup END
endif

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader=","

" TODO: this may not be in the correct place. It is intended to allow overriding <Leader>.
" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ================ General Config ====================
set number                      "Line numbers are good
set gcr=a:blinkon0              "Disable cursor blink

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" =============== Vim-Plug Initialization ===============
if filereadable(expand("~/.vim/plug.vim"))
  source ~/.vim/plug.vim
endif
au BufNewFile,BufRead *.vim set filetype=vim

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Indentation ======================

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

vnoremap <leader>p "0p
vnoremap <leader>P "0P

"set nowrap       "Don't wrap lines
set wrap       "Default wrap
"let &colorcolumn=join(range(81,999),",")

set linebreak    "Wrap lines at convenient points

" ================ Folds ============================

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" ================ Completion =======================

set wildmode=list:longest
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.pyc,.git,build/*,*.beam,ebin/*,*.class,*.lo,*.log,*coverage*,*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*/node_modules/*
" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15

" ================ Search ===========================

set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if has("termguicolors")
    " fix bug for vim
    "set t_8f=[38;2;%lu;%lu;%lum
    "set t_8b=[48;2;%lu;%lu;%lum
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    " enable true color
    set termguicolors
endif

" ================ Security ==========================
set modelines=0
set nomodeline

" vim-plug debug
let g:plug_shallow = 0

" ================ Custom Settings ========================
let g:yadr_disable_solarized_enhancements = 1
let vimsettings = '~/.vim/settings'
for fpath in split(globpath(vimsettings, '*.vim'), '\n')
  exe 'source' fpath
endfor
for fpath in split(globpath(vimsettings, '*.lua'), '\n')
  exe 'source' fpath
endfor

  " ================ Color scheme ========================

  let g:enable_bold_font = 0
  let g:enable_italic_font = 1

  " colorscheme hybrid
  " use term bg color(black) to fix the bracket color in the float window
  " let g:hybrid_custom_term_colors = 1
  " let g:hybrid_reduced_contrast = 1
  " let g:lightline.colorscheme='material'

  " hi! CursorLine guibg=#263238 ctermbg=234
  " hi! CocErrorSign guifg=#f43753 ctermfg=201 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  " hi! CocWarningSign guifg=#d3b987 ctermfg=180 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  " hi! CocHintSign guifg=#224466 ctermfg=81 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  " hi! CocInfoSign guifg=#ffc24b ctermfg=215 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
  " hi! VertSplit guifg=#405070



  " Change Color when entering Insert Mode
  " autocmd InsertEnter * highlight CursorLine guibg=black ctermbg=black
  " Revert Color to default when leaving Insert Mode
  " autocmd InsertLeave * highlight CursorLine guibg=#263238 ctermbg=234
