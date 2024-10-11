local ts_utils = require 'nvim-treesitter.ts_utils'

-- 获取节点的文本
local function get_node_text(node)
  if not node then return '' end
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col = node:range()
  local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
  return table.concat(lines, '\n')
end

-- 获取函数或类的名称
local function get_definition_name(node)
  -- 遍历子节点以找到名称
  for i = 0, node:child_count() - 1 do
    local child = node:child(i)
    if child:type() == 'identifier' then  -- 查找 identifier 节点
      return get_node_text(child)
    end
  end
  return nil
end

-- 查找当前光标所在的类和方法的名称
local function get_class_and_function_name()
  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return nil, nil end

  local class_name = nil
  local function_name = nil

  -- 向上递归查找，找到 class_definition 和 function_definition
  while current_node do
    local node_type = current_node:type()

    if node_type == 'class_definition' then
      class_name = get_definition_name(current_node)  -- 获取类名
    elseif node_type == 'function_definition' or node_type == 'decorated_definition' then
      function_name = get_definition_name(current_node)  -- 获取函数名
    end

    current_node = current_node:parent()
  end

  return class_name, function_name
end

-- 用于更新 lualine 显示的上下文信息
local current_class_or_function = ''

function update_class_or_function_context()
  -- 获取类和方法名
  local class_name, function_name = get_class_and_function_name()

  -- 构造显示内容为 method_name/class_name
  if function_name and class_name then
    current_class_or_function = function_name .. '/' .. class_name
  elseif function_name then
    current_class_or_function = function_name
  elseif class_name then
    current_class_or_function = class_name
  else
    current_class_or_function = ''
  end
end

-- 使用 CursorHold 事件延迟更新类或函数名上下文
vim.api.nvim_exec([[
  augroup UpdateClassOrFunctionContext
    autocmd!
    autocmd CursorHold * lua update_class_or_function_context()
  augroup END
]], false)

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      'diff',
      {
        'diagnostics',
        symbols = {error = '❌ '},
      },
    },
    lualine_c = {
      {
        'filename',
        path = 1
      },
      {
        function()
          return current_class_or_function
        end,
        icon = '',
      },
      'searchcount'
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
