return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            null_ls.setup({
                sources = {
                    -- 格式化工具
                    formatting.prettier,        -- JavaScript/TypeScript/CSS/JSON
                    formatting.stylua,          -- Lua
                    formatting.black,           -- Python
                    formatting.shfmt,           -- Shell

                    -- Linter 工具
                    -- diagnostics.eslint,         -- JavaScript/TypeScript
                    -- diagnostics.flake8,         -- Python
                    -- diagnostics.shellcheck,     -- Shell
                },
                on_attach = function(client, bufnr)
                    -- 自动格式化
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
