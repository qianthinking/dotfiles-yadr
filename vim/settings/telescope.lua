local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function open_or_switch_to_file(prompt_bufnr)
    local selected_entry = action_state.get_selected_entry()

    -- Debug: Print the selected entry value
    print("Selected entry value: ", vim.inspect(selected_entry.value))

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

-- Set up Telescope mappings
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<CR>"] = open_or_switch_to_file,
            },
        },
    },
    extensions = {
        coc = {
            theme = 'ivy',
            prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
        }
    },
})

require('telescope').load_extension('coc')
