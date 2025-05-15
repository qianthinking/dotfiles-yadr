vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamedplus"

vim.filetype.add {
    pattern = {
        ['.*%.ipynb.*'] = 'python',
        -- uses lua pattern matching
        -- rathen than naive matching
    },
}

require('myvscode.lazy')
require('myvscode.mapping')


