nnoremap <silent> tg :GitGutterLineHighlightsToggle<CR>
nnoremap <silent> tn :NvimTreeToggle<CR>

" t for toggle in outline
nnoremap <silent> to :call CocAction('showOutline')<CR>

" TogglePyrightInlayHints see qianthinking.vim
" nnoremap <silent> <leader>th :call TogglePyrightInlayHints()<CR>
"
"use 'gD' instead
" nnoremap <silent> th :call CocAction('doHover')<CR>
"
nnoremap <silent> tt :Telescope resume<cr>
nnoremap <silent> ti :IndentLinesToggle<CR>


function! TogglePyrightInlayVariableHints()
    " Check if we are in a Python file
    if &filetype == 'python'
        " We will force toggle by tracking the state using a global variable
        if !exists('g:pyright_inlayVariableHints_state')
            let g:pyright_inlayVariableHints_state = v:false
        endif

        " Toggle the state
        let g:pyright_inlayVariableHints_state = !g:pyright_inlayVariableHints_state

        " Set the new value explicitly based on the toggled state
        let new_value = g:pyright_inlayVariableHints_state

        " Update the setting dynamically
        call CocAction('updateConfig', 'pyright.inlayHints.variableTypes', new_value)

        " Notify the user
        echo 'pyright.inlayHints.variableTypes set to ' . (new_value ? 'enabled' : 'disabled')
    else
        echo 'Not a Python file. Toggle aborted.'
    endif
endfunction

function! TogglePyrightInlayParameterHints()
    " Check if we are in a Python file
    if &filetype == 'python'
        " We will force toggle by tracking the state using a global variable
        if !exists('g:pyright_inlayParameterHints_state')
            let g:pyright_inlayParameterHints_state = v:false
        endif

        " Toggle the state
        let g:pyright_inlayParameterHints_state = !g:pyright_inlayParameterHints_state

        " Set the new value explicitly based on the toggled state
        let new_value = g:pyright_inlayParameterHints_state

        " Update the setting dynamically
        call CocAction('updateConfig', 'pyright.inlayHints.parameterTypes', new_value)

        " Notify the user
        echo 'pyright.inlayHints.parameterTypes set to ' . (new_value ? 'enabled' : 'disabled')
    else
        echo 'Not a Python file. Toggle aborted.'
    endif
endfunction


" Create a command to toggle it
command! TogglePyrightInlayVariableHints call TogglePyrightInlayVariableHints()
command! TogglePyrightInlayParameterHints call TogglePyrightInlayParameterHints()
let g:pyright_inlayVariableHints_state = v:true
nnoremap <silent> tv :call TogglePyrightInlayVariableHints()<CR>
nnoremap <silent> tp :call TogglePyrightInlayParameterHints()<CR>

