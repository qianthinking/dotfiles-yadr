return {
    {
        "nanozuki/tabby.nvim",
        commit = "c58d980",
        event = "VeryLazy", -- 延迟加载
        config = function()
            vim.o.showtabline = 2 -- 始终显示标签栏

            local api = require("tabby.module.api")
            local buf_name = require("tabby.feature.buf_name")

            -- 动态获取高亮组背景色
            local tabline_sel_bg = vim.api.nvim_get_hl_by_name("TabLineSel", true).background
            local tabline_bg = vim.api.nvim_get_hl_by_name("TabLine", true).background

            -- 自定义高亮组
            vim.api.nvim_set_hl(0, "TabbyModifiedSel", { fg = "#dd5f5f", bold = true, bg = tabline_sel_bg })
            vim.api.nvim_set_hl(0, "TabbyModified", { fg = "#dd5f5f", bold = true, bg = tabline_bg })
            vim.api.nvim_set_hl(0, "TabbyCurrentWin", { fg = "#ffffff", bold = true, bg = tabline_sel_bg })
            vim.api.nvim_set_hl(0, "TabbyCurrentWinSep", { fg = "#ffff00", bold = true, bg = tabline_sel_bg })

            local theme = {
                fill = "TabLineFill",
                head = "TabLine",
                current_tab = "TabLineSel",
                tab = "TabLine",
                win = "TabLine",
                tail = "TabLine",
            }

            require("tabby").setup({
                preset = "tab_only",
                option = {
                    theme = theme,
                    nerdfont = true,
                    lualine_theme = "nordfox", -- 配合 lualine 使用的主题
                    buf_name = {
                        mode = "shorten",
                    },
                    tab_name = {
                        name_fallback = function(tabid)
                            local wins = api.get_tab_wins(tabid)
                            local cur_win = api.get_tab_current_win(tabid)
                            local current_tab = api.get_current_tab()
                            local tab_name = ""
                            local valid_win_count = 0

                            for _, win in ipairs(wins) do
                                local bufid = api.get_win_buf(win)
                                local name = buf_name.get(win)

                                -- 忽略 Neo-tree 缓冲区
                                --[[ if name:find("neo%-tree") then ]]
                                --[[     goto continue ]]
                                --[[ end ]]

                                -- Skip windows with 'NvimTree' or 'CocTree' in the name
                                if name:find('NvimTree') or name:find('CocTree') then
                                  goto continue
                                end

                                -- 高亮已修改的缓冲区
                                if api.get_buf_is_changed(bufid) then
                                    if tabid == current_tab then
                                        name = name .. "%#TabbyModifiedSel#*%#TabLineSel#"
                                    else
                                        name = name .. "%#TabbyModified#*%#TabLine#"
                                    end
                                end

                                -- 高亮当前窗口
                                if tabid == current_tab and win == cur_win then
                                    name = "%#TabbyCurrentWin#" .. name .. "%#TabLineSel#"
                                end

                                -- 拼接窗口名称
                                if valid_win_count > 0 then
                                    tab_name = tab_name .. " | "
                                end
                                tab_name = tab_name .. name
                                valid_win_count = valid_win_count + 1

                                ::continue::
                            end

                            return tab_name
                        end,
                    },
                },
            })

            -- 标签页操作的快捷键
            vim.api.nvim_set_keymap("n", "<leader>gt", "<Cmd>Tabby jump_to_tab<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<S-M-h>", ":-tabmove<CR>", { noremap = true })
            vim.api.nvim_set_keymap("n", "<S-M-l>", ":+tabmove<CR>", { noremap = true })
        end,
    },
}
