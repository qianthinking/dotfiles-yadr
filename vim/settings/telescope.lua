local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local function open_or_switch_to_file(prompt_bufnr)
    local selected_file = action_state.get_selected_entry()
    actions.close(prompt_bufnr)

    -- Iterate over all tabs and buffers
    for tab = 1, vim.fn.tabpagenr('$') do
        for _, bufnr in ipairs(vim.fn.tabpagebuflist(tab)) do
            if vim.fn.bufname(bufnr) == selected_file.value then
                -- Switch to the tab and buffer if the file is already open
                vim.cmd(tab .. 'tabnext')
                vim.cmd('buffer ' .. bufnr)
                return
            end
        end
    end

    -- Open the file in the current tab if it's not already open
    vim.cmd('edit ' .. selected_file.value)
end

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
-- require("telescope").load_extension('harpoon')
