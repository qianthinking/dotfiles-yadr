require("chatgpt").setup({
  actions_paths = {
    vim.fn.expand("$VIM_CHATGPT_ACTIONS_PATH")
  },
  edit_with_instructions = {
     diff = true,
     keymaps = {
       close = "<C-c>",
       accept = "<C-y>",
       toggle_diff = "<C-d>",
       toggle_settings = "<C-o>",
       toggle_help = "<C-h>",
       cycle_windows = "<Tab>",
       use_output_as_input = "<C-a>",
     },
  },
  openai_params = {
    model = "claude-3.5-sonnet",
    frequency_penalty = 0,
    presence_penalty = 0,
    max_tokens = 2000,
    temperature = 0.1,
    top_p = 1,
    n = 1,
  },
  openai_edit_params = {
    model = "claude-3.5-sonnet",
    max_tokens = 2000,
    frequency_penalty = 0,
    presence_penalty = 0,
    temperature = 0.1,
    top_p = 1,
    n = 1,
  },
})
vim.api.nvim_set_keymap("v", "<leader>cgt", ":ChatGPTRun add_tests<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgc", ":ChatGPTRun complete_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgi", ":ChatGPTRun implement_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgr", ":ChatGPTRun refactor_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgm", ":ChatGPTRun comments<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgd", ":ChatGPTRun docstring<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgf", ":ChatGPTRun fix_bugs<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cga", ":ChatGPTRun code_readability_analysis<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cge", ":ChatGPTRun explain_code<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>cgs", ":ChatGPTRun summarize<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<leader>ci", ":ChatGPTEditWithInstruction<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>ci", ":ChatGPTEditWithInstruction<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>co", ":ChatGPT<CR>", {noremap = true, silent = true})
