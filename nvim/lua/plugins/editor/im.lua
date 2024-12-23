return {
    {
        "ybian/smartim",
        event = "InsertEnter", -- Load when entering insert mode
        config = function()
            -- Default settings
            vim.g.smartim_default = "com.apple.keylayout.ABC" -- macOS default input method
            vim.g.smartim_disable = 0

            -- Toggle SmartIM
            vim.keymap.set("n", "<leader>tsi", function()
                if vim.g.smartim_disable == 1 then
                    vim.g.smartim_disable = 0
                    print("SmartIM enabled")
                else
                    vim.g.smartim_disable = 1
                    print("SmartIM disabled")
                end
            end, { desc = "Toggle SmartIM" })

            -- Optional: Integration with multiple cursors
            vim.api.nvim_create_autocmd("User", {
                pattern = "MultipleCursorsPre",
                callback = function()
                    vim.g.smartim_disable = 1
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "MultipleCursorsPost",
                callback = function()
                    vim.g.smartim_disable = 0
                end,
            })
        end,
    },
}
