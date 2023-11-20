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
