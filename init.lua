require("option")
require("keymap")
require("autocmd")
local vim_path = vim.fn.stdpath('config')
local plugins_dir = vim_path .. '/lua/plugin'

-- 将所有插件分成若干个模块，每个模块代表~/.config/nvim/lua/plugin文件夹下的一个lua文件
-- 每个lua文件内部有一个加载函数，用于加载此模块的所有插件
function get_modules()
  -- 保存各个模块的加载函数
  local modules = {}
  -- 找到plugin目录下的所有lua文件
  local tmp = vim.split(vim.fn.globpath(plugins_dir, '*.lua'), '\n')
  for _, f in ipairs(tmp) do
    -- 将文件名处理成可以直接加载的模块名称
    -- "123456":sub(2,-3)的结果为 234
    -- 例如：~/.config/nvim/lua/plugin/tool.lua -> plugin/tool
    -- #plugins_dir-6 代表去掉开头的 ~/.config/nvim/lua/ 这些多余内容
    -- -5 代表去掉 .lua 后缀
    module_name = f:sub(#plugins_dir - 6, -5)
    modules[#modules + 1] = require(module_name)
  end

  return modules
end

require('packer').startup({
  function()
    use 'wbthomason/packer.nvim'
    -- 依次调用各个模块的加载函数，加载用户插件
    for _, module in ipairs(get_modules()) do
      module(use)
    end
  end,
  config = {
    git = {
      default_url_format = 'git@github.com:%s.git' -- Lua format string used for "aaa/bbb" style plugins
    },
  }
})
