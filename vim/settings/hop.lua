require'hop'.setup({
  multi_windows = true,
})
local hop = require('hop')
vim.keymap.set('', ',,', function() hop.hint_words({}) end, {remap=true})
