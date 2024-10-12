require('flash').setup({
  modes = {
    search = {
      enabled = true
    },
    char = {
      enabled = false
    }
  }
})

-- vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump({
--   search = {
--     mode = function(str)
--       return "\\<" .. str
--     end,
--   },
-- }) end, { desc = "Flash" })
--
-- Normal, visual, and operator-pending mode mapping for Flash Treesitter
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- Operator-pending mode mapping for Remote Flash
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })

-- Operator-pending and visual mode mapping for Treesitter Search
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

-- Command-line mode mapping for toggling Flash Search
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
