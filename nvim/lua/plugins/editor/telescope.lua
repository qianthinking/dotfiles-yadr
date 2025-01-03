return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",                -- 必须依赖
            "nvim-telescope/telescope-fzy-native.nvim", -- 模糊匹配性能提升
            "nvim-telescope/telescope-live-grep-args.nvim", -- 为 live_grep 提供参数
        },
        cmd = "Telescope", -- 按需加载，在执行 :Telescope 时加载插件
        config = function()
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')

            local search_tool, search_args

            if vim.fn.executable("rg") == 1 then
                -- 优先使用 ripgrep
                search_tool = "rg"
                search_args = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--line-number",
                    "--column",
                    "--smart-case",
                }
            elseif vim.fn.executable("ag") == 1 then
                -- 如果没有 ripgrep，尝试使用 ag
                search_tool = "ag"
                search_args = {
                    "ag",
                    "--nocolor",
                    "--noheading",
                    "--numbers",
                    "--column",
                    "--smart-case",
                }
            else
                -- 最后回退到 grep
                search_tool = "grep"
                search_args = {
                    "grep",
                    "--color=never",
                    "--no-heading",
                    "--line-number",
                    "--column",
                    "--smart-case",
                }
            end

            -- 提示当前使用的搜索工具
            -- print("Telescope is using: " .. search_tool)

            local function open_or_switch_to_file(prompt_bufnr)
                local selected_entry = action_state.get_selected_entry()

                -- Debug: Print the selected entry value
                print("Selected entry value: ", vim.inspect(selected_entry.value))

                -- 如果是 code action 等不涉及文件打开的场景，调用默认行为
                if not selected_entry.value or type(selected_entry.value) ~= "table" or not selected_entry.value.filename then
                  print("Not a file entry, using default behavior.")
                  actions.select_default(prompt_bufnr)  -- 调用默认行为
                  return
                end

                actions.close(prompt_bufnr)

                local file_to_open, line_nr, col_nr

                if type(selected_entry.value) == "table" then
                    -- Handle complex entries (like from live_grep)
                    file_to_open = selected_entry.value.filename or selected_entry.value[1]
                    line_nr = selected_entry.value.lnum
                    col_nr = selected_entry.value.col or 0
                else
                    -- Handle simple file paths and extract line/column if included
                    local match = {string.match(selected_entry.value, "^(.+):(%d+):(%d+):")}

                    -- Debug: Print the match result
                    if #match > 0 then
                        print("Match result: ", vim.inspect(match))
                        file_to_open, line_nr, col_nr = match[1], tonumber(match[2]), tonumber(match[3])
                    else
                        print("No match found.")
                        -- If only the file path is present (no line or column numbers)
                        file_to_open = selected_entry.value
                        line_nr, col_nr = 1, 0  -- Default to the first line and column
                    end
                end

                -- Debug: Print the file to open and the cursor position
                print("File to open: ", file_to_open)
                print("Line: ", line_nr, " Column: ", col_nr)

                if file_to_open then
                    for tab = 1, vim.fn.tabpagenr('$') do
                        local win_found = false
                        local buflist = vim.fn.tabpagebuflist(tab)  -- Get the list of buffers in the tab
                        for win_nr = 1, #buflist do
                            local bufnr = buflist[win_nr]  -- Get the buffer number for this window
                            if vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p") == vim.fn.fnamemodify(file_to_open, ":p") then
                                -- If the file is found in this window, switch to the correct tab and window
                                vim.cmd(tab .. 'tabnext')  -- Activate the correct tab
                                local win_id = vim.fn.win_getid(win_nr)  -- Get the window ID for the current window number
                                vim.fn.win_gotoid(win_id)  -- Activate the correct window

                                -- Set the cursor to the specified line and column
                                if line_nr and col_nr then
                                    vim.api.nvim_win_set_cursor(0, {line_nr, col_nr})
                                end
                                win_found = true
                                break
                            end
                        end
                        if win_found then
                            return
                        end
                    end

                    -- If the file is not already open, open it
                    vim.cmd('edit ' .. vim.fn.fnameescape(file_to_open))
                    -- Set the cursor to the specified line and column
                    if line_nr and col_nr then
                        vim.api.nvim_win_set_cursor(0, {line_nr, col_nr})
                    end
                end
            end

            local lga_actions = require("telescope-live-grep-args.actions")
            require('telescope').setup({
                defaults = {
                    vimgrep_arguments = search_args, -- 动态设置搜索工具
                    mappings = {
                        i = {
                            ["<CR>"] = open_or_switch_to_file,
                        },
                    },
                    prompt_prefix = "🔍 ",
                    selection_caret = "➤ ",
                    file_ignore_patterns = { "node_modules", ".git" },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
                aerial = {
                  -- Set the width of the first two columns (the second
                  -- is relevant only when show_columns is set to 'both')
                  col1_width = 4,
                  col2_width = 30,
                  -- How to format the symbols
                  format_symbol = function(symbol_path, filetype)
                    if filetype == "json" or filetype == "yaml" then
                      return table.concat(symbol_path, ".")
                    else
                      return symbol_path[#symbol_path]
                    end
                  end,
                  -- Available modes: symbols, lines, both
                  show_columns = "both",
                },
                extensions = {
                    fzy_native = {
                        override_generic_sorter = true,
                        override_file_sorter = true,
                    },
                    live_grep_args = {
                      mappings = {
                        i = {
                          ["<C-k>"] = lga_actions.quote_prompt(),
                          ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
                          ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        },
                      },
                    },
                },
            })

            local builtin = require('telescope.builtin')
            local telescope = require('telescope')

            telescope.load_extension('fzy_native')

            telescope.load_extension("live_grep_args")

            -- Telescope 的快捷键绑定

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { silent = true })
            -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { noremap = true, silent = true })
            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { silent = true })
            vim.keymap.set('n', '<leader>fh', function()
                builtin.find_files({
                    hidden = true,
                    no_ignore = true,
                })
            end, { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>fp', builtin.help_tags, { noremap = true, silent = true })
            vim.keymap.set('n', '<leader>fe', builtin.diagnostics, { noremap = true, silent = true }) -- 显示所有诊断信息
            vim.keymap.set('n', '<leader>ft', builtin.lsp_type_definitions, { noremap = true, silent = true }) -- 跳转到类型定义
            vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, { noremap = true, silent = true }) -- 跳转到实现
            vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true }) -- 查看引用
            vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, { noremap = true, silent = true }) -- 跳转到定义
            vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { noremap = true, silent = true }) -- 显示当前文档的符号
            vim.keymap.set('n', '<leader>fw', builtin.lsp_dynamic_workspace_symbols, { noremap = true, silent = true }) -- 显示工作区符号

            vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { silent = true })
            local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
            vim.keymap.set("n", "<leader>fc", live_grep_args_shortcuts.grep_word_under_cursor)


            local live_grep_args = require("telescope").extensions.live_grep_args
            -- Visual mode mapping to grep for the selected text
            vim.keymap.set('v', '<leader>fc', function()
                -- Ensure the visual mode is properly registered before retrieving the selection
                vim.cmd('normal! "vy')  -- Yank the current visual selection into register 'v'

                local selection = vim.fn.getreg('v')

                -- Ensure that the selection is non-empty
                if selection and #selection > 0 then
                    -- Quote the selection
                    local quoted_selection = '"' .. selection:gsub('"', '\\"') .. '"'

                    -- Use live_grep_args with the quoted text and -F parameter
                    live_grep_args.live_grep_args({
                        default_text = quoted_selection,
                        additional_args = function()
                            return { "-F" }
                        end,
                    })
                else
                    print("No text selected.")
                end
            end, { noremap = true, silent = true })
        end,
    },
}
