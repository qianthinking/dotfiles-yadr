return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      debug = true,
      provider = "openai",
      cursor_applying_provider = 'groq',
      providers = {
        openai = {
          endpoint = "https://fomo.qingchuai.com/openai/v1",
          model = "gpt-4.1",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            max_tokens = 4096,
            temperature = 0.1,
          },
        },
        gemini = {
          endpoint = "https://fomo.qingchuai.com/gemini",
          model = "gemini-2.5-pro-preview-03-25",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            max_tokens = 4096,
            temperature = 0.1,
          },
        },
        groq = { -- define groq provider
          api_key_name = 'GROQ_API_KEY',
          endpoint = 'https://api.groq.com/openai/v1/',
          model = 'llama-3.3-70b-versatile',
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            max_completion_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
            temperature = 0.1,
          },
        },
      },
      dual_boost = {
        enabled = false,
        first_provider = "openai",
        second_provider = "gemini",
        prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
        timeout = 60000, -- Timeout in milliseconds
      },
      --[[ behaviour = { ]]
      --[[   auto_suggestions = false, -- Experimental stage ]]
      --[[   auto_set_highlight_group = true, ]]
      --[[   auto_set_keymaps = true, ]]
      --[[   auto_apply_diff_after_generation = false, ]]
      --[[   support_paste_from_clipboard = false, ]]
      --[[   minimize_diff = true, ]]
      --[[ }, ]]
      behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
        enable_token_counting = true, -- Whether to enable token counting. Default to true.
        enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
        enable_claude_text_editor_tool_mode = true, -- Whether to enable Claude Text Editor Tool Mode.
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
