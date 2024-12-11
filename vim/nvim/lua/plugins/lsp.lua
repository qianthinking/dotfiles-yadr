return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")

            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "basedpyright", "ts_ls", "bashls", "jsonls", "html", "cssls", "yamlls", "dockerls", "vimls", "gopls", "jdtls"},
                automatic_installation = true,
            })


            -- Default capabilities for cmp integration
            local capabilities = vim.tbl_deep_extend(
                "force",
                require("lspconfig").util.default_config.capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Autocommand for LSP-specific key mappings
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set({ "n", "x" }, "<leader>of", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            })

            -- Lazy load LSP configurations
            local function setup_server(server, config)
                lspconfig[server].setup(vim.tbl_deep_extend("force", {
                    capabilities = capabilities,
                }, config or {}))
            end

            -- File-type specific LSP configurations
            setup_server("lua_ls", {
                filetypes = { "lua" },
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            })

            setup_server("ts_ls", { filetypes = { "javascript", "typescript" } })
            setup_server("basedpyright", {
              settings = {
                basedpyright = {
                  analysis = {
                    typeCheckingMode = "standard",
                    diagnosticMode = "workspace",
                    autoSearchPaths = true, -- 自动搜索库路径
                    useLibraryCodeForTypes = true, -- 使用库代码推导类型
                    inlayHints = {
                        variableTypes = true, -- 启用变量类型提示
                        functionReturnTypes = true, -- 启用函数返回类型提示
                        parameterNames = true, -- 启用参数名称提示
                        callArgumentNames = true, -- 启用调用参数名称提示
                        genericTypes = true, -- 启用泛型类型提示
                    },
                  },
                },
              },
            }, { filetypes = { "python" } })
        end,
    },
    {
        "stevearc/aerial.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("aerial").setup({
                filter_kind = false,
                backends = { "treesitter", "lsp" },
                layout = {
                    default_direction = "right",
                    max_width = { 40 },
                },
            })
        end,
    },
    -- {
    --   'stevearc/stickybuf.nvim',
    --   opts = {},
    -- },
    {
        "lvimuser/lsp-inlayhints.nvim",
        event = "LspAttach",
        config = function()
            require("lsp-inlayhints").setup({
                inlay_hints = {
                    parameter_hints = {
                        show = true,
                        prefix = "<- ",
                        separator = ", ",
                    },
                    type_hints = {
                        show = true,
                        prefix = "",
                        separator = ", ",
                    },
                    labels_separator = "  ",
                    max_len_align = false,
                    max_len_align_padding = 1,
                    right_align = false,
                    right_align_padding = 7,
                    highlight = "Comment",
                },
                enabled_at_startup = true, -- Automatically enable hints on startup
                debug_mode = false, -- Disable debug mode for performance
            })

            -- Automatically attach inlay hints to LSP buffers
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local bufnr = args.buf
                    require("lsp-inlayhints").on_attach(client, bufnr)
                end,
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        config = true,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSP completion source
            "hrsh7th/cmp-buffer", --Buffer completion source
            "hrsh7th/cmp-path", -- File path completion source
            "hrsh7th/cmp-cmdline", -- Command line completion
            "L3MON4D3/LuaSnip", -- Snippet engine
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    -- Navigate between completion items
                    ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
                    ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    -- ["<C-space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "path" },
                    { name = "cmdline" },
                },
            })
        end,
    },
    {
        "stevearc/aerial.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = { "AerialToggle" }, -- Load on command
        config = function()
            require("aerial").setup({
                backends = { "treesitter", "lsp" }, -- Use Tree-sitter and LSP for symbols
                layout = {
                    default_direction = "right", -- Panel on the right
                },
                attach_mode = "global", -- Attach to all buffers
                keymaps = {
                    ["<CR>"] = "actions.jump", -- Jump to symbol
                    ["<C-s>"] = "actions.scroll", -- Scroll to symbol in the code
                },
            })
            -- Optional keymap to toggle the panel
            -- vim.keymap.set("n", "<leader>o", ":AerialToggle!<CR>", { noremap = true, silent = true })
        end,
    },
}

