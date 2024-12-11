return {
    {
        "Shatur/neovim-session-manager",
        cond = not vim.g.vscode, -- Load only if not in VSCode
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local Path = require("plenary.path")
            local session_manager = require("session_manager")
            local config = require("session_manager.config")

            session_manager.setup({
                sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- Directory for session files
                autoload_mode = config.AutoloadMode.CurrentDir, -- Automatically load session for the current directory
                autosave_last_session = true, -- Automatically save the last session
                autosave_ignore_filetypes = { "gitcommit", "gitrebase", "gitconfig" }, -- Filetypes to ignore
                -- Uncomment the following line if you want to specify ignored directories
                -- autosave_ignore_dirs = { "~/Downloads" },
            })
        end,
    },
}
