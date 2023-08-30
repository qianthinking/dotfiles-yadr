require'chatgpt'.setup({
  openai_params = {
    model = "gpt-4",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 500,
    temperature = 0,
    top_p = 1,
    n = 1
  },
})
local chatgpt = require('chatgpt')
vim.keymap.set('n', '<leader>co', function() chatgpt.openChat() end, {remap=true})
vim.keymap.set('v', '<leader>ce', function() chatgpt.edit_with_instructions() end, {remap=true})
vim.keymap.set('v', '<leader>cr', function() chatgpt.run_actions() end, {remap=true})
vim.keymap.set('v', '<leader>cs', function() chatgpt.selectAwesomePrompt() end, {remap=true})
vim.keymap.set({'n', 'i'}, '<C-g>', function() chatgpt.complete_code() end, {remap=true})
