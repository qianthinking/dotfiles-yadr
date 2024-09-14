vim.o.showtabline = 2
require('tabby').setup({
  preset = 'active_tab_with_wins',
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
