return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require'nvim-treesitter.configs'.setup {
              -- A list of parser names, or "all" (the listed parsers MUST always be installed)
              ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python", "ruby", "java", "go", "html", "css", "javascript", "typescript", "tsx", "json", "yaml", "toml", "regex", "comment", "dockerfile", "rust", "scss", "vue", "nginx"},

              -- Install parsers synchronously (only applied to `ensure_installed`)
              sync_install = false,

              -- Automatically install missing parsers when entering buffer
              -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
              auto_install = true,

              -- List of parsers to ignore installing (or "all")
              ignore_install = {},

              ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
              -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

              incremental_selection = {
                  enable = true,
                  keymaps = {
                      init_selection = "gnn",
                      node_incremental = "grn",
                      scope_incremental = "grc",
                      node_decremental = "grm",
                  },
              },

              indent = { enable = true },
              highlight = {
                enable = true,

                -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                -- the name of the parser)
                -- list of language that will be disabled
                disable = {},
                -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
              },
            }

            vim.cmd('set foldmethod=expr')
            vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
            vim.cmd('set foldlevelstart=99')

            -- Option+f to move to the next function start
            vim.api.nvim_set_keymap('n', '<A-f>', [[:lua require'nvim-treesitter.textobjects.move'.goto_next_start('@class.outer')<CR>]], { noremap = true, silent = true })

            -- Option+b to move to the previous function start
            vim.api.nvim_set_keymap('n', '<A-b>', [[:lua require'nvim-treesitter.textobjects.move'.goto_previous_start('@class.outer')<CR>]], { noremap = true, silent = true })
            --
            -- Option+f to move to the next function start
            vim.api.nvim_set_keymap('n', '<A-d>', [[:lua require'nvim-treesitter.textobjects.move'.goto_next_start('@function.outer')<CR>]], { noremap = true, silent = true })

            -- Option+b to move to the previous function start
            vim.api.nvim_set_keymap('n', '<A-u>', [[:lua require'nvim-treesitter.textobjects.move'.goto_previous_start('@function.outer')<CR>]], { noremap = true, silent = true })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                          ["]m"] = "@function.outer", -- Go to the start of the next function
                          ["]]"] = "@class.outer",    -- Go to the start of the next class
                        },
                        goto_next_end = {
                          ["]M"] = "@function.outer", -- Go to the end of the next function
                          ["]["] = "@class.outer",    -- Go to the end of the next class
                        },
                        goto_previous_start = {
                          ["[m"] = "@function.outer", -- Go to the start of the previous function
                          ["[["] = "@class.outer",    -- Go to the start of the previous class
                        },
                        goto_previous_end = {
                          ["[M"] = "@function.outer", -- Go to the end of the previous function
                          ["[]"] = "@class.outer",    -- Go to the end of the previous class
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>sal"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>sah"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    },
    {
        "tree-sitter-grammars/tree-sitter-markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
}
