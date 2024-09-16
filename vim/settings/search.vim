function! GetVisual()
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&
  normal! ""gvy
  let selection = getreg('"')
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save
  return selection
endfunction

" Find files using Telescope command-line sugar.
"nnoremap <silent> ff <cmd>Telescope find_files<cr>
"nnoremap <silent> fg <cmd>Telescope live_grep<cr>
"nnoremap <silent> fb <cmd>Telescope buffers<cr>
"nnoremap <silent> fh <cmd>Telescope help_tags<cr>
"
"nnoremap <silent> ft <cmd>Telescope coc type_definitions<CR>
"nnoremap <silent> fi <cmd>Telescope coc implementations<CR>
"nnoremap <silent> fr <cmd>Telescope coc references<CR>
"nnoremap <silent> fd <cmd>Telescope coc definitions<CR>
"nnoremap <silent> fs <cmd>Telescope coc document_symbols<CR>
"nnoremap <silent> fw <cmd>Telescope coc workspace_symbols<CR>
"
"nnoremap <silent> K <cmd>Telescope grep_string<CR>
"
""grep the current word using K (mnemonic Kurrent)
"" nnoremap <silent> K :Ag <cword><CR>
""nnoremap <silent> K :Ag <cword><CR>
"
""grep visual selection
"vnoremap K :<C-U>execute "Ag " . GetVisual()<CR>
"
""grep current word up to the next exclamation point using ,K
"nnoremap ,K viwf!:<C-U>execute "Ag " . GetVisual()<CR>

"grep for 'def foo'
nnoremap <silent> ,gd :Ag 'def <cword>'<CR>

",gg = Grep! - using Ag the silver searcher
" open up a grep line, with a quote started for the search
nnoremap ,gg :Ag ""<left>

"Grep for usages of the current file
nnoremap ,gcf :exec "Ag " . expand("%:t:r")<CR>


