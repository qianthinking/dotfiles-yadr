require('tabby').setup({
  preset = 'tab_only',
  option = {
    theme = {
      fill = 'TabLineFill',       -- tabline background
      head = 'TabLine',           -- head element highlight
      current_tab = 'TabLineSel', -- current tab label highlight
      tab = 'TabLine',            -- other tab label highlight
      win = 'TabLine',            -- window highlight
      tail = 'TabLine',           -- tail element highlight
    },
    nerdfont = true,              -- whether use nerdfont
    lualine_theme = 'nordfox',          -- lualine theme name
    buf_name = {
      mode = "shorten",
    },
  },
})
vim.api.nvim_set_keymap("n", "<leader>gn", "<Cmd>Tabby jump_to_tab<CR>", {noremap = true, silent = true})
