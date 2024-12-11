-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- vim.g.maplocalleader = "\\"

vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undofile = true

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
vim.opt.updatetime = 200

vim.opt.number = true
vim.opt.hidden = true
vim.opt.smartindent = true
vim.opt.guicursor = "a:blinkon0"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 15

vim.opt.termguicolors = true

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "ucs-bom", "utf-8", "cp936", "gb18030", "big5", "euc-jp", "euc-kr", "latin1" }

vim.opt.clipboard = "unnamedplus"

vim.opt.mouse = "a"

vim.opt.completeopt = { "menu", "menuone", "preview" }

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local last_pos = vim.fn.line("'\"")
        if last_pos > 1 and last_pos <= vim.fn.line("$") then
            vim.cmd("normal! g`\"")
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
    pattern = { "python", "java" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
    callback = function(event)
        vim.opt_local.cursorline = event.event == "WinEnter"
    end,
})

vim.cmd([[
  syntax match nonascii "[^\x00-\x7F]"
  highlight nonascii guibg=Red ctermbg=2
]])

if vim.env.TMUX then
    vim.cmd([[
        let &t_SI = "\ePtmux;\e\e]50;CursorShape=1\x07\e\\"
        let &t_EI = "\ePtmux;\e\e]50;CursorShape=0\x07\e\\"
    ]])
else
    vim.cmd([[
        let &t_SI = "\e]50;CursorShape=1\x07"
        let &t_EI = "\e]50;CursorShape=0\x07"
    ]])
end

vim.opt.ttimeoutlen = 10
vim.api.nvim_create_augroup("FastEscape", { clear = true })
-- 动态调整 timeoutlen
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        vim.opt.timeoutlen = 200
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        vim.opt.timeoutlen = 500
    end,
})
