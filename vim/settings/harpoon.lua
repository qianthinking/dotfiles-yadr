require("harpoon").setup {
    menu = {
        width = vim.api.nvim_win_get_width(0)/2,
    }
}

vim.keymap.set('n', '<leader>fh', function() require("harpoon.ui").toggle_quick_menu() end, {remap=true})
vim.keymap.set('n', '<leader>ha', function() require("harpoon.mark").add_file() end, {remap=true})
vim.keymap.set('n', '<leader>hn', function() require("harpoon.ui").nav_next() end, {remap=true})
vim.keymap.set('n', '<leader>hp', function() require("harpoon.ui").nav_prev() end, {remap=true})
vim.keymap.set('n', '<leader>h1', function() require("harpoon.ui").nav_file(1) end, {remap=true})
vim.keymap.set('n', '<leader>h2', function() require("harpoon.ui").nav_file(2) end, {remap=true})
vim.keymap.set('n', '<leader>h3', function() require("harpoon.ui").nav_file(3) end, {remap=true})
vim.keymap.set('n', '<leader>h4', function() require("harpoon.ui").nav_file(4) end, {remap=true})
vim.keymap.set('n', '<leader>h5', function() require("harpoon.ui").nav_file(5) end, {remap=true})
