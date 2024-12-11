return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                signcolumn = true, -- 在左侧显示标记列
                numhl      = false, -- 关闭行号高亮
                linehl     = false, -- 关闭整行高亮
                watch_gitdir = {
                    interval = 1000, -- 监控 Git 目录的刷新间隔
                    follow_files = true, -- 追踪文件路径的移动
                },
                attach_to_untracked = true, -- 未追踪文件也启用 gitsigns
                current_line_blame = false, -- 启用当前行的 Git blame 信息
                current_line_blame_opts = {
                    delay = 500, -- 显示延迟
                    virt_text_pos = "eol", -- 在行尾显示
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
                sign_priority = 6, -- 标记优先级
                update_debounce = 200, -- 更新的防抖时间
                status_formatter = nil, -- 使用默认的状态格式化器
                max_file_length = 40000, -- 超过此长度的文件不启用 gitsigns
                preview_config = {
                    border = "rounded", -- 使用圆角边框
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
            vim.keymap.set("n", "tg", function()
                require("gitsigns").toggle_current_line_blame()
            end, { noremap = true, silent = true, desc = "Toggle Git line blame" })
        end,
    },
}
