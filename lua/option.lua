local option = vim.o
option.mouse = "a"
option.number = true
option.hidden = true
--option.relativenumber = true
--option.cursorcolumn = true
option.cursorline = true
option.swapfile = false
-- 刚打开文件时禁用所有折叠
option.foldlevelstart = 99

-- 缩进设置
option.shiftround = true -- vim自动处理非整数倍缩进的空格
option.shiftwidth = 2
option.tabstop = 2
option.expandtab = true

option.wrap = false
option.termguicolors = true
option.undofile = true
--option.shada = "!,'300,<50,@100,s10,h"
