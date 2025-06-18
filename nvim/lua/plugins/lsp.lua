return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "ruff", "ts_ls", "bashls", "jsonls", "html", "cssls", "yamlls", "dockerls", "vimls" },
        automatic_installation = true,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          local mason_registry = require("mason-registry")
          if not mason_registry.is_installed("gopls") then
            vim.cmd("MasonInstall gopls")
          end
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local mason_registry = require("mason-registry")
          if not mason_registry.is_installed("jdtls") then
            vim.cmd("MasonInstall jdtls")
          end
          lspconfig.jdtls.setup({})
        end,
      })

      -- Default capabilities for cmp integration
      local capabilities = vim.tbl_deep_extend(
        "force",
        require("lspconfig").util.default_config.capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

      local function quick_fix()
        -- 获取当前行的诊断信息
        local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()

        -- 如果没有诊断信息，提示并返回
        if #diagnostics == 0 then
          vim.notify("No diagnostics found", vim.log.levels.INFO)
          return
        end

        -- 使用 Lspsaga 的 code_action 功能
        -- require('lspsaga.codeaction'):code_action()
        saga_filtered_codeaction()
        -- 延迟一段时间后直接选择第一个选项
        vim.defer_fn(function()
          -- 获取当前窗口和缓冲区
          local win = vim.api.nvim_get_current_win()
          local buf = vim.api.nvim_win_get_buf(win)

          -- 获取弹窗的内容
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

          -- 如果弹窗中有内容，选择第一个选项
          if #lines > 0 then
            -- 模拟按下回车键
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "m", true)
          else
            vim.notify("No code actions available", vim.log.levels.INFO)
          end
        end, 1000)
      end

      local function fix_all()
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
      end


      -- Autocommand for LSP-specific key mappings
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", function()
              vim.lsp.buf.rename(nil, {
                --[[ filter = function(client) ]]
                --[[   -- 排除 pylsp ]]
                --[[   return client.name ~= "pylsp" ]]
                --[[ end, ]]
              })
          end, opts)
          vim.keymap.set({"n", "v"}, "<leader>of", function()
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

          vim.keymap.set('n', '<leader>qf', quick_fix, { silent = true, buffer = bufnr })
          -- 键绑定：修复整个文件
          vim.keymap.set("n", "<leader>qa", fix_all, { silent = true, buffer = bufnr })

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
      local inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
      setup_server("ts_ls", {
        settings = {
          typescript = {
            inlayHints = inlayHints,
          },
          javascript = {
            inlayHints = inlayHints,
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
      })
      setup_server("bashls", { filetypes = { "sh", "bash", "zsh" } })
      --[[ setup_server("basedpyright", { ]]
      --[[   settings = { ]]
      --[[     basedpyright = { ]]
      --[[       analysis = { ]]
      --[[         diagnosticMode = "openFilesOnly", ]]
      --[[         autoImportCompletions = true, ]]
      --[[         typeCheckingMode = "standard", ]]
      --[[         autoSearchPaths = true,        -- 自动搜索库路径 ]]
      --[[         useLibraryCodeForTypes = true, -- 使用库代码推导类型 ]]
      --[[         inlayHints = { ]]
      --[[           variableTypes = true,        -- 启用变量类型提示 ]]
      --[[           functionReturnTypes = true,  -- 启用函数返回类型提示 ]]
      --[[           parameterNames = true,       -- 启用参数名称提示 ]]
      --[[           callArgumentNames = true,    -- 启用调用参数名称提示 ]]
      --[[           genericTypes = true,         -- 启用泛型类型提示 ]]
      --[[         }, ]]
      --[[       }, ]]
      --[[     }, ]]
      --[[   }, ]]
      --[[ }) ]]
      --[[]]
      --[[ setup_server("pylsp", { ]]
      --[[   settings = { ]]
      --[[     pylsp = { ]]
      --[[       plugins = { ]]
      --[[         pycodestyle = { ]]
      --[[           enabled = false,  -- 启用 pycodestyle ]]
      --[[         }, ]]
      --[[         pyflakes = { ]]
      --[[           enabled = false,  -- 启用 pyflakes ]]
      --[[         }, ]]
      --[[         rope_autoimport = { ]]
      --[[           enabled = true,   -- 启用 rope_autoimport ]]
      --[[         }, ]]
      --[[         mccabe = { ]]
      --[[           enabled = true,  -- 启用 mccabe ]]
      --[[           threshold = 8,  -- 设置阈值 ]]
      --[[         }, ]]
      --[[         jedi_references = { ]]
      --[[           enabled = false,  -- 禁用 jedi_references，避免与basedpyright冲突 ]]
      --[[         } ]]
      --[[       }, ]]
      --[[     }, ]]
      --[[   }, ]]
      --[[ }) ]]

      setup_server("ruff", {
      })
      --[[ lspconfig.ruff.setup({ ]]
      --[[ }) ]]

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
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {}, -- required, even if empty
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
        lightbulb = {
          enable = false,
          enable_in_insert = false,
        }
      })

      local saga_codeaction = require 'lspsaga.codeaction'

      -- 保存原始的 action_callback 函数
      local original_action_callback = saga_codeaction.action_callback

      -- 保存原始的 code_action 方法
      local original_code_action = saga_codeaction.code_action

      -- 定义新的 code_action 方法
      _G.saga_filtered_codeaction = function(opts)
          function saga_codeaction:action_callback(tuples, enriched_ctx)
            -- 在这里对 tuples 进行过滤
            local filtered_tuples = {}
            for _, tuple in ipairs(tuples) do
              local action = tuple[2] -- 提取 action 部分
              -- 过滤掉 pylsp_rope 的特定 actions
              if not action.command or not (type(action.command) == "table" and string.match(action.command.command or "", "^pylsp_rope%.")) then
                table.insert(filtered_tuples, tuple)
              end
            end

            -- 调用原始的 action_callback 函数，传入过滤后的 tuples
            original_action_callback(self, filtered_tuples, enriched_ctx)
          end
        -- 调用原始的 code_action 方法
        original_code_action(saga_codeaction, opts)
      end

      vim.keymap.set({"n", "v"}, "<leader>ca", saga_filtered_codeaction, { silent = true })
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
            -- 注释这里，避免在 text之前用tab就是希望缩进，但会触发cmp的tab，导致不预期的选择
            --[[ elseif cmp.visible() then ]]
            --[[   cmp.select_next_item() -- 如果 nvim-cmp 补全框可见，选择下一个补全项 ]]
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
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
    -- Uncomment whichever supported plugin(s) you use
      "nvim-tree/nvim-tree.lua",
    -- "nvim-neo-tree/neo-tree.nvim",
    -- "simonmclean/triptych.nvim"
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
}
