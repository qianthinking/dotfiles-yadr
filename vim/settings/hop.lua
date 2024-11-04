require'hop'.setup({
  multi_windows = true,
  create_hl_autocmd = false,
})
local hop = require('hop')
local hoptreesitter = require('hop-treesitter')
local directions = require('hop.hint').HintDirection
vim.keymap.set({ "n", "x", "o" }, ';k', function() hop.hint_words({
  direction = directions.BEFORE_CURSOR
}) end, {remap=true})
vim.keymap.set({ "n", "x", "o" }, ';j', function() hop.hint_words({
  direction = directions.AFTER_CURSOR
}) end, {remap=true})
vim.keymap.set({ "n", "x", "o" }, ';;', function() hop.hint_words({
  current_line_only = true,
}) end, {remap=true})
vim.keymap.set({ "n", "x", "o" }, ';l', function() hop.hint_lines_skip_whitespace({
}) end, {remap=true})
