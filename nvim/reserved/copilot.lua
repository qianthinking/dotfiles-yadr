return {
    {
        "github/copilot.vim",
        cond = not vim.g.vscode,
        event = "InsertEnter",
        config = function()
            -- vim.g.copilot_no_tab_map = true
            -- vim.keymap.set("i", "<C-J>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
            vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
        end,
    },
}
