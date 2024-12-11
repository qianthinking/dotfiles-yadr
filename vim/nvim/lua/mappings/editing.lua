local map = vim.keymap.set

-- splitjoin
map("n", "gS", ":SplitjoinSplit<CR>", { silent = true })
map("n", "gJ", ":SplitjoinJoin<CR>", { silent = true })

-- vim-easy-align
map("x", "ga", "<Plug>(EasyAlign)", { silent = true })
map("n", "ga", "<Plug>(EasyAlign)", { silent = true })

-- Macro
map("n", "<Space><Space>", "@q", { silent = true })
map("n", "<Space>1", "@1", { silent = true })
map("n", "<Space>2", "@2", { silent = true })

-- Pasting
map("v", "<leader>p", '"0p', { silent = true })
map("v", "<leader>P", '"0P', { silent = true })

map("n", "Y", "y$", { silent = true })

map("n", "0", "^", { silent = true })
map("n", "^", "0", { silent = true })

-- 跳转到最后编辑点
map("n", "<leader>.", "'.", { silent = true })

-- 跳转到更早的编辑点
map("n", "<leader>ge", "g;", { silent = true })

-- 跳转到更晚的编辑点
map("n", "<leader>gl", "g,", { silent = true })

map("v", "<", "<gv", { silent = true })
map("v", ">", ">gv", { silent = true })

map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

map("n", "<Space><Space>", "@q", { silent = true })
map("n", "<Space>1", "@1", { silent = true })
map("n", "<Space>2", "@2", { silent = true })

map("i", "<C-l>", " <space>=><space>", { silent = true })
map("c", "<C-l>", " <space>=><space>", { silent = true })
map("i", "<C-g>", " <space>-><space>", { silent = true })
map("c", "<C-g>", " <space>-><space>", { silent = true })
