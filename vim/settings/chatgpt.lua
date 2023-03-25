require'chatgpt'.setup({
  openai_params = {
    model = "gpt-3.5-turbo",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 2000,
    temperature = 0,
    top_p = 1,
    n = 1
  },
  keymaps = {
    close = { "<C-c>" },
    submit = "<C-d>",
    yank_last = "<C-y>",
    yank_last_code = "<C-k>",
    scroll_up = "<C-u>",
    scroll_down = "<C-d>",
    toggle_settings = "<C-o>",
    new_session = "<C-n>",
    cycle_windows = "<Tab>",
    -- in the Sessions pane
    select_session = "<Space>",
    rename_session = "r",
    delete_session = "d",
  },
})
local chatgpt = require('chatgpt')
vim.keymap.set('n', '<leader>co', function() chatgpt.openChat() end, {remap=true})
vim.keymap.set('v', '<leader>ce', function() chatgpt.edit_with_instructions() end, {remap=true})
vim.keymap.set({'n', 'i'}, '<C-g>', function() chatgpt.complete_code() end, {remap=true})
