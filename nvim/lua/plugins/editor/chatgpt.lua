local map = vim.keymap.set
return {
    {
        "qianthinking/ChatGPT.nvim",
        event = "VeryLazy",
        dependencies = {
          "MunifTanjim/nui.nvim",
          "nvim-lua/plenary.nvim",
          "folke/trouble.nvim", -- optional
          "nvim-telescope/telescope.nvim"
        },
        config = function()
            require("chatgpt").setup({
              actions_paths = {
                vim.fn.expand("$VIM_CHATGPT_ACTIONS_PATH")
              },
              edit_with_instructions = {
                 diff = true,
                 model = "chatgpt-4o-latest",
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
                model = "chatgpt-4o-latest",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 2000,
                temperature = 0.1,
                top_p = 1,
                n = 1,
              },
              openai_edit_params = {
                model = "chatgpt-4o-latest",
                max_tokens = 2000,
                frequency_penalty = 0,
                presence_penalty = 0,
                temperature = 0.1,
                top_p = 1,
                n = 1,
              },
            })
            map("v", "<leader>cgt", ":ChatGPTRun add_tests<CR>", {silent = true})
            map("v", "<leader>cgc", ":ChatGPTRun complete_code<CR>", {silent = true})
            map("v", "<leader>cgi", ":ChatGPTRun implement_code<CR>", {silent = true})
            map("v", "<leader>cgr", ":ChatGPTRun refactor_code<CR>", {silent = true})
            map("v", "<leader>cgm", ":ChatGPTRun comments<CR>", {silent = true})
            map("v", "<leader>cgd", ":ChatGPTRun docstring<CR>", {silent = true})
            map("v", "<leader>cgf", ":ChatGPTRun fix_bugs<CR>", {silent = true})
            map("v", "<leader>cga", ":ChatGPTRun code_readability_analysis<CR>", {silent = true})
            map("v", "<leader>cge", ":ChatGPTRun explain_code<CR>", {silent = true})
            map("v", "<leader>cgs", ":ChatGPTRun summarize<CR>", {silent = true})
            map("v", "<leader>ci", ":ChatGPTEditWithInstruction<CR>", {silent = true})
            map("n", "<leader>ci", ":ChatGPTEditWithInstruction<CR>", {silent = true})
            map("n", "<leader>co", ":ChatGPT<CR>", {silent = true})
        end,
    },
}
