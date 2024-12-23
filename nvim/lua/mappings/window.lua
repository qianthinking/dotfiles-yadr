local map = vim.keymap.set

-- Tab
map("n", "H", ":tabprevious<CR>", { silent = true })
map("n", "L", ":tabnext<CR>", { silent = true })
map("n", "<C-t>c", ":tabnew<CR>", { silent = true })
map("n", "<C-t>e", ":tabe %<CR>", { silent = true })
map("n", "<C-t>h", ":tabprevious<CR>", { silent = true })
map("n", "<C-t>l", ":tabnext<CR>", { silent = true })
map("n", "<leader>rd", ":redraw!<CR>", { silent = true })

-- 跳转到第 1 到第 9 个标签页
for i = 1, 9 do
    map("n", "<leader>" .. i, i .. "gt", { silent = true })
end

-- 跳转到最后一个标签页
map("n", "<leader>0", ":tablast<CR>", { silent = true })

-- 全局变量存储上一次访问的标签页编号
vim.g.lasttab = 1

-- 快捷键 T：跳转到上一次访问的标签页
vim.keymap.set("n", "T", function()
    vim.cmd("tabn " .. vim.g.lasttab)
end, { silent = true })

-- 自动命令：记录离开标签页时的编号
vim.api.nvim_create_autocmd("TabLeave", {
    pattern = "*",
    callback = function()
        vim.g.lasttab = vim.fn.tabpagenr()
    end,
})

map("n", "<leader>ww", ":w<CR>", { silent = true })
map("n", "<leader>xx", ":x<CR>", { silent = true })
map("n", "<leader>qq", ":qa<CR>", { silent = true })

-- Define the function as a global function by adding it to the _G table
_G.CloseWindowOrKillBuffer = function()
    -- 获取当前窗口和缓冲区
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_win_get_buf(current_win)

    -- 获取所有窗口列表
    local all_wins = vim.api.nvim_list_wins()
    local buffer_usage_count = 0

    -- 统计所有窗口中使用当前缓冲区的数量
    for _, win in ipairs(all_wins) do
        if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == current_buf then
            buffer_usage_count = buffer_usage_count + 1
        end
    end

    if buffer_usage_count > 1 then
        -- 如果有多个窗口使用此缓冲区，仅关闭当前窗口
        vim.api.nvim_win_close(current_win, false)
    else
        -- 检查其他 Tab 是否使用此缓冲区
        local other_tab_buffer_used = false
        local all_tabs = vim.api.nvim_list_tabpages()

        for _, tab in ipairs(all_tabs) do
            if tab ~= vim.api.nvim_get_current_tabpage() then
                local tab_wins = vim.api.nvim_tabpage_list_wins(tab)
                for _, win in ipairs(tab_wins) do
                    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == current_buf then
                        other_tab_buffer_used = true
                        break
                    end
                end
            end
            if other_tab_buffer_used then
                break
            end
        end

        if not other_tab_buffer_used then
            vim.api.nvim_buf_delete(current_buf, { force = true })
        else
            vim.api.nvim_win_close(current_win, false)
        end
    end

    -- 获取当前 Tab 和窗口列表
    local current_tab = vim.api.nvim_get_current_tabpage()
    local current_tab_wins = vim.api.nvim_tabpage_list_wins(current_tab)

    -- 如果这是最后一个 Tab 和窗口，检查是否只剩下 nvim-tree 窗口
    if #vim.api.nvim_list_tabpages() == 1 and #current_tab_wins == 1 then
        local remaining_win = current_tab_wins[1]
        if vim.api.nvim_win_is_valid(remaining_win) then
            local remaining_buf = vim.api.nvim_win_get_buf(remaining_win)
            local remaining_bufname = vim.api.nvim_buf_get_name(remaining_buf)

            -- 如果唯一剩余的窗口是 nvim-tree，则不执行任何关闭操作
            if remaining_bufname:match("NvimTree") then
                return
            end
        end
    end

    -- 如果当前 Tab 只剩下一个窗口且该窗口是 nvim-tree，则关闭它
    if #current_tab_wins == 1 then
        local remaining_win = current_tab_wins[1]
        if vim.api.nvim_win_is_valid(remaining_win) then
            local remaining_buf = vim.api.nvim_win_get_buf(remaining_win)
            local remaining_bufname = vim.api.nvim_buf_get_name(remaining_buf)

            -- 检查缓冲区名称是否包含 'NvimTree'
            if remaining_bufname:match("NvimTree") then
                vim.api.nvim_win_close(remaining_win, false)
            end
        end
    end
end

-- Window
map("n", "Q", CloseWindowOrKillBuffer, { silent = true })

-- Locate the file in the nvim-tree
map("n", "<C-\\>", ":NvimTreeFindFile<CR>", {silent = true})

