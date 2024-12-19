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
        ensure_installed = { "lua_ls", "basedpyright", "ts_ls", "bashls", "jsonls", "html", "cssls", "yamlls", "dockerls", "vimls", "gopls", "jdtls" },
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
          local opts = { buffer = event.buf, silent = true }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>of", function()
            -- Format the entire file
            vim.lsp.buf.format({ async = true })
          end, opts)
          -- Visual mode range formatting or full file formatting
          vim.keymap.set("x", "<leader>of", function()
            -- Get the selected range
            local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
            local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

            -- Use `vim.lsp.buf.format` with a custom range if `range_formatting` is unavailable
            vim.lsp.buf.format({
              async = true,
              range = {
                ["start"] = { line = start_row - 1, character = start_col },
                ["end"] = { line = end_row - 1, character = end_col },
              },
            })
          end, opts)

          vim.keymap.set("n", "<leader>cp", function()
            vim.lsp.buf.code_action({
              apply = true, -- Automatically apply fixes
            })
          end, opts)

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
              autoImportCompletions = true,
              typeCheckingMode = "standard",
              autoSearchPaths = true,        -- 自动搜索库路径
              useLibraryCodeForTypes = true, -- 使用库代码推导类型
              inlayHints = {
                variableTypes = true,        -- 启用变量类型提示
                functionReturnTypes = true,  -- 启用函数返回类型提示
                parameterNames = true,       -- 启用参数名称提示
                callArgumentNames = true,    -- 启用调用参数名称提示
                genericTypes = true,         -- 启用泛型类型提示
              },
            },
          },
        },
      })


      -- 配置 ruff LSP
      lspconfig.ruff.setup({
        on_attach = function(client, bufnr)
          -- 键绑定：修复整个文件
          vim.keymap.set("n", "<leader>qf", function()
            local temp_file = vim.fn.tempname() -- 创建临时文件

            -- 获取当前缓冲区内容
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

            -- 写入临时文件
            local file = io.open(temp_file, "w")
            for _, line in ipairs(lines) do
              file:write(line .. "\n")
            end
            file:close()

            -- 执行 ruff 修复临时文件
            vim.fn.system(string.format("ruff check --fix %s", temp_file))

            -- 读取修复后的内容
            local repaired_file = io.open(temp_file, "r")
            if repaired_file then
              local repaired_lines = {}
              for line in repaired_file:lines() do
                table.insert(repaired_lines, line)
              end
              repaired_file:close()
              vim.api.nvim_buf_set_lines(0, 0, -1, false, repaired_lines)
            end

            -- 删除临时文件
            vim.fn.delete(temp_file)
          end, { noremap = true, silent = true, buffer = bufnr })

        end,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false, -- 浮动窗口不可交互
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded", -- 窗口边框样式
            source = "always", -- 显示诊断来源
            prefix = " ",
          })
        end,
      })
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    config = function()
      require("lspsaga").setup({
        code_action = {
          enable = true,
          keys = {
            quit = "<Esc>",
            exec = "<CR>",
          },
        },
        symbol_in_winbar = {
          enable = false,
        },
      })
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
        debug_mode = false,        -- Disable debug mode for performance
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source
      "hrsh7th/cmp-buffer",   --Buffer completion source
      "hrsh7th/cmp-path",     -- File path completion source
      "hrsh7th/cmp-cmdline",  -- Command line completion
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          -- Navigate between completion items
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- ["<C-space>"] = cmp.mapping.complete(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- 判断 Copilot 提示是否可见
            local copilot = require("copilot.suggestion")
            print(copilot.is_visible())
            if copilot.is_visible() then
              copilot.accept() -- 如果 Copilot 提示框可见，接受建议
            elseif cmp.visible() then
              cmp.select_next_item() -- 如果 nvim-cmp 补全框可见，选择下一个补全项
            else
              print("fallback")
              fallback() -- 否则插入普通 Tab
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item() -- 如果补全框可见，选择上一个补全项
            else
              fallback() -- 否则插入普通 Shift+Tab
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
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
          default_direction = "right",      -- Panel on the right
        },
        attach_mode = "global",             -- Attach to all buffers
        keymaps = {
          ["<CR>"] = "actions.jump",        -- Jump to symbol
          ["<C-s>"] = "actions.scroll",     -- Scroll to symbol in the code
        },
      })
      -- Optional keymap to toggle the panel
      -- vim.keymap.set("n", "<leader>o", ":AerialToggle!<CR>", { noremap = true, silent = true })
    end,
  },
}
