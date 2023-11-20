require("chatgpt").setup({
  actions_paths = { "~/.vim/chatgpt/actions.json" },
  openai_params = {
    model = "gpt-4-1106-preview",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 300,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = "gpt-4-1106-preview",
    frequency_penalty = 0,
    presence_penalty = 0,
    temperature = 0,
    top_p = 1,
    n = 1,
  },
})
vim.api.nvim_set_keymap("v", "<leader>cc", ":ChatGPTRun continue_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cm", ":ChatGPTRun complete_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>co", ":ChatGPTRun optimize_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cb", ":ChatGPTRun fix_bugs<CR>", {noremap = true, silent = true})
