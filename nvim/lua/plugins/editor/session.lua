return {
    {
        "Shatur/neovim-session-manager",
        cond = not vim.g.vscode, -- Load only if not in VSCode
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local Path = require("plenary.path")
            local session_manager = require("session_manager")
            local config = require("session_manager.config")

            -- 自定义会话目录，基于当前工作目录
            local function get_session_dir()
                local cwd = vim.fn.getcwd()
                -- 将当前工作目录转换为一个适合用作目录名的字符串
                local dir_name = cwd:gsub("/", "_"):gsub(":", "_")
                local session_dir = Path:new(vim.fn.stdpath("data"), "sessions", dir_name)
                session_dir:mkdir({ parents = true })
                return session_dir
            end

            session_manager.setup({
                sessions_dir = get_session_dir(), -- 动态生成会话目录
                autoload_mode = config.AutoloadMode.CurrentDir, -- 自动加载当前目录的会话
                autosave_last_session = true, -- 自动保存最后一个会话
                autosave_ignore_filetypes = { "gitcommit", "gitrebase", "gitconfig" }, -- 忽略的文件类型

                -- 在加载会话之前检查当前目录是否匹配
                before_load = function(session_path)
                    local expected_session_dir = get_session_dir()
                    local actual_session_dir = Path:new(session_path):parent().filename
                    if expected_session_dir ~= actual_session_dir then
                        vim.notify("Session directory does not match current working directory. Not loading session.", vim.log.levels.WARN)
                        return false -- 取消加载
                    end
                    return true -- 允许加载
                end,
            })

            -- 每次切换目录时更新会话目录
            vim.api.nvim_create_autocmd("DirChanged", {
                callback = function()
                    session_manager.setup({ sessions_dir = get_session_dir() })
                end,
            })
        end,
    },
}
