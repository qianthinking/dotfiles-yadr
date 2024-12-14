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
          null_ls.builtins.formatting.black.with({
            extra_args = function()
              local config = find_config("pyproject.toml")
              -- print("Black Config File: ", vim.inspect(config))
              return config and { "--config", config } or {}
            end,
          }),
          null_ls.builtins.formatting.prettier.with({
            extra_args = function()
              local config = find_config(".prettierrc")
              -- print("Prettier Config File: ", vim.inspect(config))
              return config and { "--config", config } or {}
            end,
          }),
        },
        --[[ on_attach = function(client, bufnr) ]]
        --[[   if client.supports_method("textDocument/formatting") then ]]
        --[[     vim.api.nvim_create_autocmd("BufWritePre", { ]]
        --[[       buffer = bufnr, ]]
        --[[       callback = function() ]]
        --[[         vim.lsp.buf.format({ bufnr = bufnr }) ]]
        --[[       end, ]]
        --[[     }) ]]
        --[[   end ]]
        --[[ end, ]]
      })
    end,
  },
}
