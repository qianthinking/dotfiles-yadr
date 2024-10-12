require'hop'.setup({
  multi_windows = true,
  create_hl_autocmd = false,
})
local hop = require('hop')
local hoptreesitter = require('hop-treesitter')
vim.keymap.set({ "n", "x", "o" }, '<leader><leader>', function() hop.hint_words() end, {remap=true})
vim.keymap.set({ "n", "x", "o" }, ';;', function() hop.hint_words({
  current_line_only = true,
}) end, {remap=true})
vim.keymap.set({ "n", "x", "o" }, 's', function() hop.hint_char2({
}) end, {remap=true})


