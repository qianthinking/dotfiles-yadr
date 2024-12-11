return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",        -- Utility functions
            "nvim-tree/nvim-web-devicons",  -- File icons
            "MunifTanjim/nui.nvim",         -- UI components
        },
        cmd = "Neotree",  -- Load on :Neotree command
        config = function()
            require("neo-tree").setup({
                sources = {
                    "filesystem",
                    "buffers",
                    "git_status",
                },
                filesystem = {
                    follow_current_file = {
                        enabled = true,
                    },  -- Sync with the current file
                    hijack_netrw_behavior = "open_default",  -- Replace netrw
                    use_libuv_file_watcher = true,  -- Auto-refresh
                    commands = {
                        open_tabnew = function(state)
                            local node = state.tree:get_node()
                            if node.type == "file" then
                                vim.cmd("tabnew " .. vim.fn.fnameescape(node.path))
                                -- 在新标签页中打开 neo-tree
                                vim.cmd("Neotree reveal")
                            elseif node.type == "directory" then
                                require("neo-tree.sources.filesystem").toggle_directory(state, node)
                            end
                        end,
                    }
                },
                window = {
                    position = "left",
                    width = 30,
                    mappings = {
                        ["<space>"] = "toggle_node",
                        ["o"] = function(state)
                            local node = state.tree:get_node()
                            if node.type == "file" then
                                vim.cmd("edit " .. vim.fn.fnameescape(node.path))
                            elseif node.type == "directory" then
                                require("neo-tree.sources.filesystem").toggle_directory(state, node)
                            end
                        end,
                        ["h"] = "show_help", -- Use 'h' for help menu
                        ["<cr>"] = "noop", -- Disable '<CR>'
                        ["S"] = "split_with_window_picker",
                        ["s"] = "vsplit_with_window_picker",
                        ["t"] = "open_tabnew", -- Open files in a new tab
                        ["C"] = "close_node",
                        ["R"] = "refresh",
                        ["a"] = {
                            "add",
                            config = {
                                show_path = "relative",  -- Show relative path
                            },
                        },
                        ["d"] = "delete",
                        ["r"] = "rename",
                        ["y"] = "copy_to_clipboard",
                        ["x"] = "cut_to_clipboard",
                        ["p"] = "paste_from_clipboard",
                        ["c"] = "copy",  -- Copy file
                        ["m"] = "move",  -- Move file
                        ["q"] = "close_window",
                        ["?"] = "show_help",
                    },
                },
                default_component_configs = {
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "",
                    },
                    modified = {
                        symbol = "[+]",
                        highlight = "NeoTreeModified",
                    },
                    git_status = {
                        symbols = {
                            added     = "✚",
                            modified  = "",
                            deleted   = "✖",
                            renamed   = "",
                            untracked = "",
                            ignored   = "",
                            unstaged  = "",
                            staged    = "",
                            conflict  = "",
                        },
                    },
                },
                event_handlers = {
                    {
                        event = "neo_tree_buffer_enter",
                        handler = function()
                            vim.cmd("highlight! Cursor blend=100")
                            vim.opt.guicursor:append("a:Cursor/lCursor")
                        end,
                    },
                    {
                        event = "neo_tree_buffer_leave",
                        handler = function()
                            vim.cmd("highlight! Cursor blend=0")
                            vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
                        end,
                    },
                },
                window_picker = {
                    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    other_win_hl_color = "#2d2a2e", -- Adjust to a more comfortable color
                },
            })
        end,
    },
    {
        's1n7ax/nvim-window-picker',
        name = 'window-picker',
        event = 'VeryLazy',
        version = '2.*',
        config = function()
            require'window-picker'.setup()
        end,
    }
}
