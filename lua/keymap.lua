local set_keymap = vim.api.nvim_set_keymap
vim.cmd([[let mapleader = "s"]])
set_keymap("i", "jk", "<esc>", { noremap = true })
-- <c-s>保存
set_keymap("n", "<c-s>", ":w<cr>", { noremap = true })
-- 快速缩进
set_keymap("n", "<", "<<", { noremap = true })
set_keymap("n", ">", ">>", { noremap = true })
-- <F5>运行lua文件
set_keymap("n", "<f5>", ":lua Run()<cr>", { noremap = true })
function Run()
	local filetype = vim.o.filetype
	vim.cmd([[silent write]])
	if filetype == "lua" then
		vim.cmd([[luafile %]])
	elseif filetype == "vim" then
		vim.cmd([[source %]])
	end
end
-- Y复制到行尾
set_keymap("n", "Y", "y$", { noremap = true })
-- 远程复制内容
set_keymap("v", ";y", ":OSCYank<cr>", { noremap = true })
-- 命令模式回到开始位置
set_keymap("c", "<c-a>", "<c-b>", { noremap = true })
-- 切换是否高亮搜索结果
set_keymap("n", "\\", ":set hlsearch!<cr>", { noremap = true })
-- 切换到当前文件夹
set_keymap("n", "<leader>.", ":cd %:p:h<cr>", { noremap = true, silent = true })
