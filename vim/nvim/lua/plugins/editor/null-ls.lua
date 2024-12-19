return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")

      local function find_config(file)
        local cwd = vim.fn.getcwd()
        while cwd ~= "/" do
          local config_path = cwd .. "/" .. file
          if vim.fn.filereadable(config_path) == 1 then
            return config_path
          end
          cwd = vim.fn.fnamemodify(cwd, ":h")
        end
        return nil
      end

      null_ls.setup({
        debug = true, -- 开启调试
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.code_actions.refactoring,

          --[[ null_ls.builtins.diagnostics.ruff, -- Ruff for linting ]]
          --[[ null_ls.builtins.code_actions.ruff, -- Ruff for auto-fixing ]]
        },
      })
    end,
  },
}
