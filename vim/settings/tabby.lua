vim.o.showtabline = 2

local api = require('tabby.module.api')
local buf_name = require('tabby.feature.buf_name')

-- Retrieve the TabLineSel background dynamically
local tabline_sel_bg = vim.api.nvim_get_hl_by_name('TabLineSel', true).background
local tabline_bg = vim.api.nvim_get_hl_by_name('TabLine', true).background

-- Define custom highlight groups for modified symbol and current window
vim.api.nvim_set_hl(0, 'TabbyModifiedSel', { fg = '#dd5f5f', bold = true, bg = tabline_sel_bg })  -- Color for modified buffers
vim.api.nvim_set_hl(0, 'TabbyModified', { fg = '#dd5f5f', bold = true, bg = tabline_sel })  -- Color for modified buffers
-- Define the TabbyCurrentWin highlight group using the retrieved background
vim.api.nvim_set_hl(0, 'TabbyCurrentWin', { fg = '#ffffff', bold = true, bg = tabline_sel_bg })
vim.api.nvim_set_hl(0, 'TabbyCurrentWinSep', { fg = '#ffff00', bold = true, bg = tabline_sel_bg })

local theme = {
  fill = 'TabLineFill',
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

require('tabby').setup({
  preset = 'tab_only',
  option = {
    theme = theme,
    nerdfont = true,              -- whether to use nerdfont
    lualine_theme = 'nordfox',    -- lualine theme name
    buf_name = {
      mode = "shorten",
    },
    tab_name = {
      name_fallback = function(tabid)
        local wins = api.get_tab_wins(tabid)
        local cur_win = api.get_tab_current_win(tabid)  -- Get the current window in the tab
        local current_tab = api.get_current_tab()  -- Get the current active tab
        local tab_name = ''
        local valid_win_count = 0  -- Track windows that aren't 'NvimTree'

        -- Iterate over each window in the tab
        for i, win in ipairs(wins) do
          local bufid = api.get_win_buf(win)
          local name = buf_name.get(win)  -- Get the buffer name

          -- Skip windows with 'NvimTree' or 'CocTree' in the name
          if name:find('NvimTree') or name:find('CocTree') then
            goto continue
          end

          -- Add indicator if buffer is modified (unsaved changes)
          if api.get_buf_is_changed(bufid) then
            if tabid == current_tab then
              name = name .. '%#TabbyModifiedSel#*%#TabLineSel#'  -- Append * with highlight for modified buffers
            else
              name = name .. '%#TabbyModified#*%#TabLine#'  -- Append * with highlight for modified buffers
            end
          end

          -- Highlight the current window only if this tab is active
          if tabid == current_tab and win == cur_win then
            name = '%#TabbyCurrentWin#' .. name .. '%#TabLineSel#'  -- Highlight the current window (fg only)
          end

          -- Append window name to the tab name
          if valid_win_count > 0 then
            tab_name = tab_name .. ' | '  -- Use '|' as a separator for valid windows
          end
          tab_name = tab_name .. name
          valid_win_count = valid_win_count + 1

          ::continue::
        end

        -- Return the concatenated name with all window names and modified indicators
        return tab_name
      end,
    }
  },
})

-- Keymap for jumping to tabs
vim.api.nvim_set_keymap("n", "<leader>gn", "<Cmd>Tabby jump_to_tab<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-M-h>", ":-tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-M-l>", ":+tabmove<CR>", { noremap = true })
