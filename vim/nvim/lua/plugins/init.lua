local legacy_path = vim.fn.stdpath("config") .. "/legacy/"
local legacy_files = { "next-textobject.vim", "mapping.vim" }

for _, file in ipairs(legacy_files) do
    local file_path = legacy_path .. file
    if vim.fn.filereadable(file_path) == 1 then
        vim.cmd("source " .. file_path)
    end
end

return {
    { import = "plugins.editor" },
    { import = "plugins.ui" },
}

-- TODO setup folke/trouble.nvim
