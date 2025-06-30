-- Whether to enable the dynamic error background in Lualine's diagnostics component.
local enable_error_bg = true

--- Lualine component for enhanced diagnostics.
-- Dynamically changes background color based on error count if enable_error_bg is true.
local function enhanced_diagnostics()
    if not enable_error_bg then
        -- Return simple 'diagnostics' component if background enhancement is disabled.
        return 'diagnostics'
    end

    -- Return a custom Lualine component table.
    return {
        'diagnostics',
        diagnostics_color = { error = { fg = "#FF8888" } },
        -- Custom color function for the component.
        color = function()
            -- Get the number of ERROR diagnostics in the current buffer.
            local error_count = vim.diagnostic.count(0)[vim.diagnostic.severity.ERROR] or 0
            if error_count > 0 then
                -- Calculate intensity based on error count, capping at 100.
                -- This makes the background more red as error count increases.
                local intensity = math.min(error_count * 15, 100)
                -- Calculate the red component of the RGB color (scaled from 50% to 100% of 255).
                local red_value = math.floor(255 * (35 + intensity / 2) / 100)
                -- Format the color as a hex string for the background.
                return { bg = string.format('#%02x0000', red_value) }
            end
            -- Return nil if no errors, letting Lualine use its default background.
            return nil
        end,
    }
end

return {
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy", -- Load Lualine very late.
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- Required for icons.
            'nvim-treesitter/nvim-treesitter', -- Often used with LSPs and for syntax highlighting.
        },
        config = function()
            -- Variable to track the state of virtual text
            local virtual_text_enabled = true

            -- Keymap to toggle virtual text for diagnostics
            vim.keymap.set('n', '<leader>dv', function()
                if virtual_text_enabled then
                    vim.diagnostic.config({ virtual_text = false })
                    vim.notify("Virtual text disabled", vim.log.levels.INFO, { title = "Diagnostics" })
                else
                    vim.diagnostic.config({
                        virtual_text = {
                            severity = { min = vim.diagnostic.severity.ERROR },
                            format = function(diagnostic)
                                return diagnostic.message
                            end,
                        }
                    })
                    vim.notify("Virtual text enabled", vim.log.levels.INFO, { title = "Diagnostics" })
                end
                virtual_text_enabled = not virtual_text_enabled
            end, { noremap = true, silent = false, desc = "Toggle diagnostic virtual text" })

            -- Define custom highlight groups once here.
            -- FIX: Moved DiagnosticVirtualTextError definition outside the format function.
            -- This highlight group applies to virtual text messages of ERROR severity.
            vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', {
                bg = '#800000', -- Dark red background for error virtual text.
                fg = '#ffffff'  -- White foreground for error virtual text.
            })

            -- This highlight group applies to underlines for ERROR severity diagnostics.
            vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', {
                undercurl = true, -- Use undercurl (wavy underline).
                sp = '#ff0000',  -- Special color for the undercurl (red).
                bg = '#600000'   -- Background color under the error (darker red).
            })

            -- Configure Neovim's built-in diagnostics.
            vim.diagnostic.config({
                virtual_text = {
                    -- Only show virtual text for ERROR severity and above.
                    severity = { min = vim.diagnostic.severity.ERROR },
                    -- Format function for virtual text.
                    -- This function should only return the message string.
                    -- Neovim automatically applies highlight groups like 'DiagnosticVirtualTextError'
                    -- if they are defined globally.
                    format = function(diagnostic)
                        return diagnostic.message
                    end,
                },
                signs = {
                    -- Custom text for diagnostic signs in the sign column.
                    text = {
                        [vim.diagnostic.severity.ERROR] = "E",
                        [vim.diagnostic.severity.WARN] = "W",
                        [vim.diagnostic.severity.INFO] = "I",
                        [vim.diagnostic.severity.HINT] = "H",
                    }
                }
            })

            -- Setup Lualine status line.
            require('lualine').setup {
                options = {
                    theme = 'auto', -- Use current colorscheme's Lualine theme.
                    component_separators = '|', -- Separator between components within a section.
                    section_separators = '', -- Separator between sections.
                    refresh = { statusline = 100 }, -- Refresh statusline every 100ms.
                },
                sections = {
                    lualine_a = {'mode'}, -- Leftmost section: Vim mode.
                    lualine_b = {'branch', 'diff', enhanced_diagnostics()}, -- Branch, Git diff, and custom diagnostics.
                    lualine_c = {
                      {'filename', path = 1}, -- Filename with full path.
                      {
                        "aerial", -- Component from nvim-treesitter-textobjects (aerial.nvim).
                        -- The separator to be used to separate symbols in status line.
                        sep = " ) ",
                        -- The number of symbols to render top-down.
                        -- Negative numbers render N last symbols (e.g., -1 for current symbol).
                        depth = nil, -- Show all symbols up to current.
                        -- When 'dense' mode is on, icons are not rendered near their symbols.
                        -- Only a single icon for the current symbol's kind is rendered at the beginning.
                        dense = false,
                        -- The separator to be used to separate symbols in dense mode.
                        dense_sep = ".",
                        -- Color the symbol icons.
                        colored = true,
                      },
                    },
                    lualine_x = {'encoding', 'fileformat', 'filetype'}, -- Encoding, file format, file type.
                    lualine_y = {'progress'}, -- Progress through the file.
                    lualine_z = {'location'}, -- Cursor location (line:column).
                },
            }
        end,
    },
}
