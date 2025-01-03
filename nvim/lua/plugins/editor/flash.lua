return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        config = function()
            require("flash").setup({
                labels = "abcdefghijklmnopqrstuvwxyz", -- 自定义跳转标签
                search = {
                    mode = "fuzzy",
                    highlight = true,
                },
                modes = {
                  search = {
                    enabled = false
                  },
                  char = {
                    enabled = true,
                    keys = { "f", "F" },
                    -- jump = true, -- 启用跳转功能
                    -- autohide = true, -- 自动隐藏标签
                  }
                }
            })

            -- vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump({
            --   search = {
            --     mode = function(str)
            --       return "\\<" .. str
            --     end,
            --   },
            -- }) end, { desc = "Flash" })
            --
            -- Normal, visual, and operator-pending mode mapping for Flash Treesitter
            vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

            -- Operator-pending mode mapping for Remote Flash
            vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })

            -- Operator-pending and visual mode mapping for Treesitter Search
            vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

            -- Command-line mode mapping for toggling Flash Search
            vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

            vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump({
              search = {
                mode = function(str)
                  return "\\<" .. str
                end,
              },
            }) end, { desc = "Toggle Flash Search" })

            -- 定义 ;w 映射，仅匹配单词
            --[[ vim.keymap.set({ "n", "x", "o" }, ";w", function() require("flash").jump({ ]]
            --[[   pattern = ".", -- initialize pattern with any char ]]
            --[[   search = { ]]
            --[[     mode = function(pattern) ]]
            --[[       -- 去除模式开头的点 ]]
            --[[       if pattern:sub(1, 1) == "." then ]]
            --[[         pattern = pattern:sub(2) ]]
            --[[       end ]]
            --[[       -- 匹配单独的单词 ]]
            --[[       return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern) ]]
            --[[     end, ]]
            --[[   }, ]]
            --[[   jump = { pos = "range" }, ]]
            --[[ }) end, { desc = "Toggle Flash Search for Words" }) ]]


            -- -- Define ;W mapping for words and dot-separated word sequences
            -- vim.keymap.set({ "n", "x", "o" }, ";W", function()
            --     require("flash").jump({
            --       pattern = "^",
            --       label = { after = { 0, 0 } },
            --       search = {
            --         mode = "search",
            --         exclude = {
            --           function(win)
            --             return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
            --           end,
            --         },
            --       },
            --       action = function(match)
            --         local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            --         picker:set_selection(match.pos[1] - 1)
            --       end,
            --     })
            -- end, { desc = "Toggle Flash Search for Words and Dot-Separated Words" })
        end,
    },
}
