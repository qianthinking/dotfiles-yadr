return {
    {
        "echasnovski/mini.ai",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("mini.ai").setup({
                custom_textobjects = {
                    -- Custom text objects: key is the trigger character, value is the matching rule
                    f = function()
                        return require("mini.ai").gen_spec.function_call()
                    end,
                },
            })
        end,
    },
}
