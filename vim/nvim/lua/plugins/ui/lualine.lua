return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'auto',
                    component_separators = '|',
                    section_separators = '',
                    refresh = { statusline = 100 },
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {
                      {'filename', path = 1},
                      {
                        "aerial",
                        -- The separator to be used to separate symbols in status line.
                        sep = " ) ",

                        -- The number of symbols to render top-down. In order to render only 'N' last
                        -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
                        -- be used in order to render only current symbol.
                        depth = nil,

                        -- When 'dense' mode is on, icons are not rendered near their symbols. Only
                        -- a single icon that represents the kind of current symbol is rendered at
                        -- the beginning of status line.
                        dense = false,

                        -- The separator to be used to separate symbols in dense mode.
                        dense_sep = ".",

                        -- Color the symbol icons.
                        colored = true,
                      },
                    },
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'},
                },
            }
        end,
    },
}
