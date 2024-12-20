local map = vim.keymap.set

-- indentLine
map("n", "ti", ":IndentLinesToggle<CR>", { silent = true })
map("n", "tl", ":AnsiEsc<CR>", { silent = true })
map("n", "tn", ":NvimTreeToggle<CR>", { silent = true })

-- Telescope
map("n", "tt", ":Telescope resume<CR>", { silent = true })

-- Aeral
map("n", "to", ":Lspsaga outline<CR>", { silent = true })
map("n", "ta", ":AvanteToggle<CR>", { silent = true })

-- Keybinding to toggle inlay hints
vim.keymap.set("n", "th", function() require("lsp-inlayhints").toggle() end, { silent = true })
