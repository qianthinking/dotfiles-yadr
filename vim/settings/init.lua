require("trouble").setup {}
require("nvim-autopairs").setup {}

-- Activate the custom theme
vim.cmd("colorscheme nordfox")

-- 创建命令：通过 `CocAction("getHover")` 获取光标下的类型信息并插入到代码中
vim.api.nvim_create_user_command('AddHoverType', function()
  -- 执行 CocAction("getHover") 获取光标下的悬浮信息
  local result = vim.fn.CocAction("getHover")

  -- 打印 result 的类型和内容以便调试
  -- print("Result Type: " .. type(result))
  -- print("Hover Result: ", vim.inspect(result))

  -- 检查是否有 hover 信息
  if not result or vim.tbl_isempty(result) then
    print("No hover information found.")
    return
  end

  -- 提取 hover 的类型信息
  local hover_text = ""

  if type(result) == 'table' then
    if result.contents then
      -- 如果 result 有 contents 字段，处理 contents
      if type(result.contents) == 'table' and result.contents[1] and result.contents[1].value then
        hover_text = result.contents[1].value
      elseif type(result.contents) == 'table' then
        -- 将所有内容拼接为一个字符串
        hover_text = table.concat(vim.tbl_map(function(content)
          return type(content) == 'table' and content.value or content
        end, result.contents), "\n")
      elseif type(result.contents) == 'string' then
        hover_text = result.contents
      end
    elseif #result > 0 then
      -- 如果 result 是一个数组，取第一个元素
      hover_text = result[1]
    end
  elseif type(result) == 'string' then
    hover_text = result
  end

  if hover_text == "" then
    print("No hover information found.")
    return
  end

  -- 打印提取出的 hover_text 内容以便进一步调试
  -- print("Extracted Hover Text: ", hover_text)

  -- 移除 Markdown 代码块标记
  hover_text = hover_text:gsub("```%w+\n", ""):gsub("\n```", "")

  -- 打印移除代码块后的 hover_text
  -- print("Cleaned Hover Text: ", hover_text)

  -- 移除悬浮信息中的上下文标识，例如 "(method) "、"(function) " 或 "(variable) "
  hover_text = hover_text:match("^%(%w+%)%s*(.+)$") or hover_text

  -- 打印移除上下文后的 hover_text
  -- print("Hover Text without Context: ", hover_text)

  -- 根据内容类型判断是函数/方法定义还是变量赋值
  if hover_text:find("^def ") or hover_text:find("^async def ") then
    -- 处理函数或方法定义
    handle_function_hover(hover_text)
  else
    -- 处理变量赋值
    handle_variable_hover(hover_text)
  end
end, {})

-- 为该命令绑定快捷键
vim.api.nvim_set_keymap('n', 'ta', ':AddHoverType<CR>', { noremap = true, silent = true })

-- 处理变量赋值的函数
function handle_variable_hover(hover_text)
  -- 使用正则匹配提取类型注释部分，匹配类似 `chat: ExampleType` 或 `fixed: Literal[False]`
  local type_annotation = hover_text:match(":%s*(.+)$") or
                          hover_text:match("type%s*:%s*(.+)$") or
                          hover_text:match("is a%s*(.+)$")

  -- print("Raw Type Annotation: ", type_annotation)

  -- 简化类型注释
  local simplified_type = simplify_type(type_annotation)

  -- print("Simplified Type Annotation: ", simplified_type)

  -- 如果没有找到有效的类型提示，返回
  if not simplified_type or simplified_type == "" then
    print("No valid type annotation found after simplification.")
    return
  end

  -- 获取光标位置
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_number = cursor[1] - 1 -- Lua 的行是从 0 开始
  local column_number = cursor[2]

  -- 获取当前行的内容
  local line_content = vim.api.nvim_buf_get_lines(0, line_number, line_number + 1, false)[1]

  -- 查找变量名，确保只在等号前插入类型注解
  local var_pattern = "([%w_]+)%s*=%s*"

  -- 找到变量名，并在等号前插入类型注解
  local new_line, count = line_content:gsub(var_pattern, function(var_name)
    local var_start, var_end = line_content:find(var_name, 1, true)
    local eq_pos = line_content:find("=", var_end, true)
    if var_start and eq_pos and column_number >= var_start and column_number <= eq_pos then
      -- 根据文件类型调整类型注释格式
      local filetype = vim.bo.filetype
      local formatted_type_annotation
      if filetype == 'typescript' or filetype == 'javascript' then
        formatted_type_annotation = ": " .. simplified_type
      elseif filetype == 'python' then
        formatted_type_annotation = ": " .. simplified_type
      else
        formatted_type_annotation = ": " .. simplified_type -- 默认
      end
      return var_name .. formatted_type_annotation .. " = "
    else
      return var_name .. " = " -- 保持原样
    end
  end)

  -- 如果有修改，更新当前行
  if count > 0 then
    vim.api.nvim_buf_set_lines(0, line_number, line_number + 1, false, {new_line})
    -- print("Type hint added: " .. simplified_type)
  else
    -- print("No changes made to the line.")
  end
end

-- 处理函数或方法定义的函数
function handle_function_hover(hover_text)
  -- 解析函数签名，提取参数和返回类型
  -- 示例:
  -- async def parse_subjects(
  --     self: Self@Example,
  --     raw_subjects_str: str
  -- ) -> list[ExampleSubject | None]

  -- 使用模式匹配提取参数和返回类型
  -- 提取参数部分
  local params_str = hover_text:match("%((.-)%)%s*->%s*(.+)$") or ""
  -- 提取返回类型部分
  local return_type = hover_text:match("->%s*(.+)$") or ""

  -- print("Raw Params: ", params_str)
  -- print("Raw Return Type: ", return_type)

  -- 分割参数
  local params = {}
  for param in params_str:gmatch("([^,]+)") do
    table.insert(params, param:match("^%s*(.-)%s*$")) -- 去除前后空格
  end

  -- 分割参数并简化类型，跳过 'self' 和 'cls' 以及可变参数
  local simplified_params = {}
  for _, param in ipairs(params) do
    -- 使用 ':' 分割参数，获取 name 和 type_str
    local name, type_str = param:match("^%s*([^:]+)%s*:%s*(.+)%s*$")

    -- print("param: ", param)
    -- print("Name: ", name)
    -- print("Type: ", type_str)

    if name then
      -- 检查 name 是否以 '*' 或 '**' 开头（可变参数）
      local stars = name:match("^(%*%*?)")
      name = name:gsub("^%*%*?", "")  -- 去掉 '*' 或 '**'

      if name == "self" or name == "cls" then
        -- 保持 'self' 和 'cls' 不带类型注释
        table.insert(simplified_params, name)
      elseif stars then
        -- 如果是可变参数（*args 或 **kwargs），不添加类型注释
        table.insert(simplified_params, stars .. name)
      else
        -- 简化类型
        local simplified_type = simplify_type(type_str)
        if simplified_type and simplified_type ~= "" then
          table.insert(simplified_params, name .. ": " .. simplified_type)
        else
          -- 如果类型为 Unknown 或简化后为空，不添加类型注释
          table.insert(simplified_params, name)
        end
      end
    else
      -- 参数没有类型注释，保持原样
      table.insert(simplified_params, param)
    end
  end

  -- 简化返回类型
  local simplified_return_type = simplify_type(return_type)

  -- print("Simplified Params: ", table.concat(simplified_params, ", "))
  -- print("Simplified Return Type: ", simplified_return_type)

  -- 获取光标位置
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor[1]

  -- 查找函数定义的起始行和结束行
  -- 获取当前单词（函数名）
  local func_name = vim.fn.expand("<cword>")

  local start_line = nil
  local end_line = nil
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 查找函数定义的起始行
  for i = current_line, 1, -1 do
    local line = buf_lines[i]
    if line:match("def%s+" .. func_name .. "%s*%(") or
       line:match("async%s+def%s+" .. func_name .. "%s*%(") then
      start_line = i - 1 -- Lua 从0开始
      break
    end
  end

  if not start_line then
    print("Unable to locate function definition start.")
    return
  end

  -- 查找函数定义的结束行（以 ':' 结尾）
  for i = start_line, #buf_lines - 1 do
    local line = buf_lines[i + 1]
    if line:find(":%s*$") then
      end_line = i
      break
    end
  end

  if not end_line then
    print("Unable to locate function definition end.")
    return
  end

  -- 构建新的函数定义
  local new_function_def = {}
  for i = start_line, end_line do
    table.insert(new_function_def, buf_lines[i + 1])
  end

  -- 提取函数签名行
  local function_signature = table.concat(new_function_def, "\n")

  -- 使用提取的参数和返回类型重建函数签名
  -- 替换参数部分
  local new_signature = function_signature:gsub("%((.-)%)", "(" .. table.concat(simplified_params, ", ") .. ")")

  -- 替换或添加返回类型
  if simplified_return_type ~= "" then
    -- 检查是否已有返回类型
    if function_signature:find("->") then
      -- 替换现有返回类型
      local converted_return_type = convert_union_syntax(simplified_return_type)
      new_signature = new_signature:gsub("->%s*(.+)", "-> " .. converted_return_type)
    else
      -- 添加返回类型 before ':'
      new_signature = new_signature:gsub(":%s*$", " -> " .. convert_union_syntax(simplified_return_type) .. ":")
    end
  else
    -- 如果没有返回类型需要添加，且没有简化后的返回类型
    -- 保持原样
    new_signature = new_signature
  end

  -- print("New Function Signature: ", new_signature)

  -- 分割新的签名为多行
  local new_signature_lines = {}
  for line in new_signature:gmatch("([^\n]+)") do
    table.insert(new_signature_lines, line)
  end

  -- 更新缓冲区中的函数定义
  vim.api.nvim_buf_set_lines(0, start_line, end_line + 1, false, new_signature_lines)

  -- print("Type hints added to function/method.")
end

-- 简化类型注释的函数
function simplify_type(type_str)
  -- print("Simplify type: " .. tostring(type_str))

  -- 处理 'Self@Type' 格式，将其简化为 'Type'
  type_str = type_str:gsub("Self@([%w_]+)", "%1")

  -- 如果类型为 'Unknown'，忽略
  if type_str == "Unknown" then
    return ""
  end

  -- 如果类型包含 'Unknown'，移除类型参数
  if type_str:match("Unknown") then
    -- 移除类型参数，例如 'list[Unknown]' -> 'list', 'dict[Unknown, Unknown]' -> 'dict'
    type_str = type_str:gsub("%[.*%]", "")
  end

  -- 如果简化后类型为 'Unknown'，忽略
  if type_str == "Unknown" then
    return ""
  end

  -- 处理具体类型
  if type_str == "Literal[False]" or type_str == "Literal[True]" then
    return "bool"
  elseif type_str:match("^Literal%[(.+)%]$") then
    -- 处理其他 Literal 类型，例如 Literal["value"]
    local literal_value = type_str:match("^Literal%[(.+)%]$")
    if literal_value then
      if literal_value:match("^%d+$") then
        return "int"
      elseif literal_value:match("^%d+%.%d+$") then
        return "float"
      elseif literal_value:match("^%b''") or literal_value:match('^%b""') then
        return "str"
      else
        -- 其他 Literal 类型，简化为基础类型或 'Any'
        return "Any"
      end
    else
      return "Any"
    end
  elseif type_str:match("^List%[(.+)%]$") then
    return type_str -- 例如 'List[int]'
  elseif type_str:match("^Dict%[(.+)%]$") then
    return type_str -- 例如 'Dict[str, int]'
  elseif type_str:match("^Union%[(.+)%]$") then
    -- 处理 Union 类型，例如 Union[str, int] -> str | int
    local union_types = type_str:match("^Union%[(.+)%]$")
    if union_types then
      -- 分割并连接类型
      local simplified_union = ""
      for t in union_types:gmatch("([^,]+)") do
        local trimmed = t:match("^%s*(.-)%s*$")
        local simplified = simplify_type(trimmed)
        if simplified ~= "" then
          if simplified_union ~= "" then
            simplified_union = simplified_union .. " | " .. simplified
          else
            simplified_union = simplified
          end
        end
      end
      return simplified_union
    else
      return "Any"
    end
  elseif type_str:match("^Optional%[(.+)%]$") then
    -- 处理 Optional 类型，例如 Optional[int] -> int | None
    local optional_type = type_str:match("^Optional%[(.+)%]$")
    if optional_type then
      local simplified = simplify_type(optional_type)
      if simplified ~= "" then
        return simplified .. " | None"
      else
        return "None"
      end
    else
      return "Any"
    end
  elseif type_str:match("^Tuple%[(.+)%]$") then
    -- 处理 Tuple 类型，例如 Tuple[int, str] -> tuple[int, str]
    local tuple_types = type_str:match("^Tuple%[(.+)%]$")
    if tuple_types then
      return "tuple[" .. tuple_types .. "]"
    else
      return "tuple"
    end
  else
    return type_str -- 例如 'ExampleType' 或简化后的 'list'
  end
end

-- 转换 Union 语法的函数（如果需要）
function convert_union_syntax(type_str)
  -- 处理 'Union[str, int]' -> 'str | int'
  if type_str:match("^Union%[(.+)%]$") then
    local union_types = type_str:match("^Union%[(.+)%]$")
    local converted = union_types:gsub("%s*,%s*", " | ")
    return converted
  else
    return type_str
  end
end
