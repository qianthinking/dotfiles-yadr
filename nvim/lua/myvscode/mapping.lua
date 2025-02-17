local M = {}

local map = vim.keymap.set

local augroup = vim.api.nvim_create_augroup

M.my_vscode = augroup('MyVSCode', {})

local function notify(cmd)
    return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
end

-- splitjoin
map("n", "gS", ":SplitjoinSplit<CR>", { silent = true })
map("n", "gJ", ":SplitjoinJoin<CR>", { silent = true })

-- vim-easy-align
map("x", "ga", "<Plug>(EasyAlign)", { silent = true })
map("n", "ga", "<Plug>(EasyAlign)", { silent = true })

local dial = require("dial.map").manipulate
map("n", "<C-a>", function() dial("increment", "normal") end)
map("n", "<C-x>", function() dial("decrement", "normal") end)
map("v", "<C-a>", function() dial("increment", "visual") end)
map("v", "<C-x>", function() dial("dial.map").manipulate("decrement", "visual") end)

map("n", "//", ":nohlsearch<CR>", { silent = true })
map("n", "<leader>hl", ":set hlsearch! hlsearch?<CR>", { silent = true })

-- 文件路径相关快捷键
map("n", "<leader>cf", notify 'copyFilePath', { silent = true })
map("n", "<leader>cr", notify 'copyRelativeFilePath', { silent = true })

map('n', 'tn', notify 'workbench.action.toggleSidebarVisibility', { silent = true })

map('n', '<leader>fr', notify 'references-view.findReferences', { silent = true }) -- language references
map('n', '<leader>fe', notify 'workbench.actions.view.problems', { silent = true }) -- language diagnostics
map('n', 'gr', notify 'editor.action.goToReferences', { silent = true })
map('n', '<leader>rn', notify 'editor.action.rename', { silent = true })
map('n', '=', notify 'editor.action.formatDocument', { silent = true })
map('n', '<leader>ca', notify 'editor.action.refactor', { silent = true }) -- language code actions

map('n', '<leader>fg', notify 'workbench.action.findInFiles', { silent = true }) -- use ripgrep to search files
map('n', '<leader>ff', notify 'workbench.action.quickOpen', { silent = true }) -- find files
map('n', '<leader>fc', notify 'workbench.action.showCommands', { silent = true }) -- find commands

map('v', '=', notify 'editor.action.formatSelection', { silent = true })
map('v', '<leader>ca', notify 'editor.action.refactor', { silent = true })
map('v', '<leader>fc', notify 'workbench.action.showCommands', { silent = true })

return M


