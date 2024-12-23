require("config.settings")
require("config.autocmds")

require("config.lazy")

-- Automatically load all Lua files in the specified directory as modules
local function import_modules(dir)
    local path = vim.fn.stdpath("config") .. "/lua/" .. dir
    local files = vim.fn.globpath(path, "*.lua", false, true)
    for _, file in ipairs(files) do
        local module = dir .. "." .. file:match(".*/(.*)%.lua$")
        local ok, err = pcall(require, module)
        if not ok then
            vim.notify("Error loading " .. module .. "\n\n" .. err, vim.log.levels.ERROR)
        end
    end
end

import_modules("mappings")

vim.cmd("colorscheme nordfox")
