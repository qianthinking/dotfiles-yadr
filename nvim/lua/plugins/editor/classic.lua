return {
    { "AndrewRadev/splitjoin.vim", event = "VeryLazy"}, -- TODO: echasnovski/mini.splitjoin
    { "junegunn/vim-easy-align", event = "VeryLazy" }, -- TODO: echasnovski/mini.align
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require("ts_context_commentstring").setup({})
        end,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        event = "VeryLazy",
        config = function()
            require("Comment").setup({
                pre_hook = function(ctx)
                    local utils = require("ts_context_commentstring.utils")
                    local internal = require("ts_context_commentstring.internal")

                    -- 如果是 Python 文件，强制使用 `#` 注释符号
                    if vim.bo.filetype == "python" then
                        return "# %s"
                    end

                    -- 对其他文件使用 Treesitter 上下文注释
                    return internal.calculate_commentstring({
                        key = ctx.ctype == require("Comment.utils").ctype.line and "__default" or "__multiline",
                        location = utils.get_cursor_location(),
                    })
                end,
            })

            -- 自定义快捷键（可选）
            vim.keymap.set("n", "gcc", "<Plug>(comment_toggle_linewise_current)", { noremap = true, silent = true })
            vim.keymap.set("x", "gc", "<Plug>(comment_toggle_linewise_visual)", { noremap = true, silent = true })
        end,
    },
    {
        "mg979/vim-visual-multi",
        branch = "master",
        event = "VeryLazy",
        config = function()
            vim.g.VM_maps = {
                ["Find Under"] = "<C-n>", -- 添加一个光标
                ["Find Subword Under"] = "<C-n>", -- 添加子单词光标
                ["Select All"] = "<C-S-n>", -- 选择所有匹配的光标
                ["Skip Region"] = "<C-x>", -- 跳过当前匹配
                ["Remove Region"] = "<C-p>", -- 移除当前光标
            }
        end,
    },
    { "christoomey/vim-tmux-navigator", lazy = false }, -- Load immediately to ensure key mappings work.
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({ })
        end,
    },
    { "tpope/vim-repeat", event = "VeryLazy" },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter", -- Load when entering insert mode
        config = function()
            local npairs = require("nvim-autopairs")

            -- Initialize nvim-autopairs
            npairs.setup({
                check_ts = true, -- Enable Treesitter integration
                fast_wrap = {
                    map = "<M-e>",
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "Search",
                    highlight_grey = "Comment",
                },
            })

            -- Integrate with nvim-cmp
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local highlight = {
                "CursorColumn",
                "Whitespace",
            }
            require("ibl").setup {
                indent = {
                    --[[ highlight = highlight, ]]
                    char = "┊", -- 使用浅浅的虚线字符
                },
                whitespace = {
                    --[[ highlight = highlight, ]]
                    remove_blankline_trail = true,
                },
                scope = { enabled = false }, -- 禁用上下文范围高亮
                enabled = false
            }

            -- 自定义虚线的高亮颜色
            vim.cmd [[
                highlight! link IndentBlanklineChar Comment
            ]]
        end,
    },
    {
        "mtdl9/vim-log-highlighting",
        ft = { "log" },
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "log",
                callback = function()
                    -- Define syntax rules to hide terminal color escape codes
                    vim.cmd([[
                        syntax match Normal '\[[0-9;]*m' conceal
                        setlocal conceallevel=2
                        setlocal concealcursor=n
                    ]])
                end,
            })
        end,
    },
    {
        "powerman/vim-plugin-AnsiEsc",
        event = { "BufReadPost", "BufNewFile" },
    },
    {
        "ojroques/vim-oscyank",
        cmd = { "OSCYank" },
        config = function()
            -- 可选：设置 OSC Yank 自动使用剪贴板
            vim.g.oscyank_silent = true
        end,
    },
    -- Plug 'Keithbsmiley/investigate.vim' "gK for doc
    -- Plug 'bogado/file-line' "open file with line number
}
