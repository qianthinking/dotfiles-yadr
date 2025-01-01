return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      lint.linters.ruff = {
        name = "Ruff",
        cmd = "ruff",
        stdin = false,
        parser = function(output, _)
          print("Ruff Output: ", output) -- 打印 Ruff 的原始输出
          local diagnostics = {}
          local ok, results = pcall(vim.fn.json_decode, output)
          if not ok then
            print("JSON Decode Error: ", results) -- 打印解码错误信息
            return diagnostics
          end
          print("Parsed Results: ", vim.inspect(results)) -- 打印解析结果
          for _, item in ipairs(results) do
            table.insert(diagnostics, {
              lnum = item.location.row - 1,
              col = item.location.column - 1,
              end_lnum = item.end_location and (item.end_location.row - 1),
              end_col = item.end_location and (item.end_location.column - 1),
              message = item.message,
              severity = vim.diagnostic.severity[item.severity],
              source = "ruff",
            })
          end
          return diagnostics
        end,
      }

      lint.linters_by_ft = {
        python = { "ruff" },
      }

      --[[ vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, { ]]
      --[[   callback = function() ]]
      --[[     -- 设置 Ruff 的参数并运行 linting 对于 Python 文件 ]]
      --[[     if vim.bo.filetype == "python" then ]]
      --[[       local file_path = vim.fn.expand("%:p") ]]
      --[[       require("lint").linters.ruff.args = { "check", file_path, "--output-format", "json" } ]]
      --[[     end ]]
      --[[]]
      --[[     -- 运行通用 linting ]]
      --[[     require("lint").try_lint() ]]
      --[[]]
      --[[   end, ]]
      --[[ }) ]]

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, {
        pattern = "*.py",
        callback = function()
            local file_path = vim.fn.expand("%:p")
            require("lint").linters.ruff.args = { "check", file_path, "--output-format", "json" }
            require("lint").try_lint()
        end,
      })
      -- 显示诊断信息浮动窗口
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false, -- 浮动窗口不可交互
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded", -- 窗口边框样式
            source = "always", -- 显示诊断来源
            prefix = " ",
          })
        end,
      })
    end,
  },
}
