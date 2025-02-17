-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins/editor/flash" },
    { import = "plugins/editor/hop" },
    { import = "plugins/editor/treesitter" },
    { import = "plugins/editor/select" },
    { import = "myvscode/others" },
  },
  performance = {
    rtp = {
      reset = false, -- 保留非 Lazy.nvim 管理的插件
    },
  },
  -- automatically check for plugin updates
  checker = {
    enabled = false,
    frequency = 604800, -- 每 7 天检查一次更新
  },
  change_detection = {
    enabled = false, -- 启用配置变更检测
    notify = true,  -- 变更时弹出通知
  },
})
