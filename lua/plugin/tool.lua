return function(use)
	-- 模糊搜索插件
	-- 搜索当前目录的文件名
	vim.cmd([[nnoremap <leader>ff <cmd>Telescope find_files<cr>]])
	-- 浏览访问频率最高文件
	vim.cmd([[nnoremap <leader>fc <cmd>Telescope frecency<cr>]])
	-- 文件浏览器
	vim.cmd([[nnoremap <leader>fs <cmd>Telescope file_browser<cr>]])
	-- 搜索当前目录文件的内容
	vim.cmd([[nnoremap <leader>fg <cmd>Telescope live_grep<cr>]])
	-- 搜索缓冲区的名称
	vim.cmd([[nnoremap <leader>fb <cmd>Telescope buffers<cr>]])
	-- 搜索帮助文件的标签
	vim.cmd([[nnoremap <leader>fh <cmd>Telescope help_tags<cr>]])
	use({
		"nvim-telescope/telescope.nvim",
		opt = true,
		cmd = "Telescope",
		requires = {
			{ "nvim-lua/popup.nvim", opt = true },
			{ "nvim-lua/plenary.nvim", opt = true },
		},
		config = function()
			-- 确保组件加载
			if not packer_plugins["plenary.nvim"].loaded then
				vim.cmd([[packadd plenary.nvim]])
			end
			if not packer_plugins["telescope-fzy-native.nvim"].loaded then
				vim.cmd([[packadd telescope-fzy-native.nvim]])
			end
			if not packer_plugins["sqlite.lua"].loaded then
				vim.cmd([[packadd sqlite.lua]])
			end
			-- 访问频率排序
			if not packer_plugins["telescope-frecency.nvim"].loaded then
				vim.cmd([[packadd telescope-frecency.nvim]])
			end
			require("telescope").load_extension("fzy_native")
			require("telescope").load_extension("frecency")

			require("telescope").setup({
				defaults = {
					prompt_prefix = "🔭 ",
					selection_caret = " ",
					path_display = { "absolute" },
					set_env = { ["COLORTERM"] = "truecolor" },
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					},
					frecency = {
						show_scores = true,
					},
				},
			})
		end,
	})
	-- telescope扩展插件
	use({ "nvim-telescope/telescope-fzy-native.nvim", opt = true, after = "telescope.nvim" })
	use({
		"nvim-telescope/telescope-frecency.nvim",
		opt = true,
		after = "telescope.nvim",
		requires = { { "tami5/sqlite.lua", opt = true } },
	})

	-- 远程内容复制插件
	use({
		"ojroques/vim-oscyank",
		config = function()
			vim.cmd([[
        vnoremap <leader>y :OSCYank<CR>
        nmap <leader>y <Plug>OSCYank
      ]])
		end,
	})

	-- 命令模式搜索补全
	use({
		"gelguy/wilder.nvim",
		event = "CmdlineEnter",
		requires = { { "romgrk/fzy-lua-native", after = "wilder.nvim" } },
		config = function()
			vim.cmd([[
        call wilder#setup({'modes': [':', '/', '?']})
        call wilder#set_option('pipeline', [
          \   wilder#branch(
          \     [
          \       wilder#check({_, x -> empty(x)}),
          \       wilder#history(),
          \       {_, x -> filter(x, {_, val -> len(val)>2})},
          \       wilder#result({'draw': [{_, x -> '📜 ' . x}]}),
          \     ],
          \     wilder#search_pipeline({'pattern': 'fuzzy'}),
          \     wilder#substitute_pipeline(),
          \     wilder#cmdline_pipeline({'fuzzy': 2, 'fuzzy_filter': wilder#lua_fzy_filter()}),
          \   )
          \ ])
      
        " 由于切换配色方案后自定义高亮会失效
        " 所以定义自动命令在切换配色方案后自动重新定义高亮
        augroup wilderColor
          autocmd!
          "autocmd ColorScheme * highlight WilderDefault        guifg=#c5cdd9 guibg=#363a49
          "autocmd ColorScheme * highlight WilderAccent         guifg=#f4468f guibg=#363a49
          autocmd ColorScheme * highlight WilderAccent         guifg=#f4468f
          autocmd ColorScheme * highlight WilderSelected       guifg=White   guibg=#a0c980 gui=italic
          autocmd ColorScheme * highlight WilderSelectedAccent guifg=Red     guibg=#a0c980 gui=italic
        augroup END
        " 在加载插件之后可能没有发生配色切换，所以手动触发
        doautocmd wilderColor ColorScheme
        call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
          \ 'highlights': {
          \   'default': 'WilderDefault',
          \   'accent': 'WilderAccent',
          \   'selected': 'WilderSelected',
          \   'selected_accent': 'WilderSelectedAccent',
          \ },
          \ 'highlighter': wilder#basic_highlighter(),
          \ 'left': [wilder#popupmenu_devicons()],
          \ 'right': [' ', wilder#popupmenu_scrollbar()],
          \ 'border': 'rounded',
          \ })))
      ]])
		end,
	})

	-- 翻译插件
	use({
		"voldikss/vim-translator",
		setup = function()
			vim.cmd([[
      nmap <silent> <Leader>t <Plug>Translate
      vmap <silent> <Leader>t <Plug>TranslateV
      nmap <silent> <Leader>w <Plug>TranslateW
      vmap <silent> <Leader>w <Plug>TranslateWV
    ]])
			vim.g.translator_default_engines = { "bing", "haici", "youdao" }
		end,
	})

	-- 显示语法错误的列表
	vim.cmd([[nnoremap <leader>b <cmd>TroubleToggle<cr>]])
	use({
		"folke/trouble.nvim",
		opt = true,
		cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
	})

	-- 快速运行单行代码
	vim.cmd([[nnoremap <leader>r <cmd>SnipRun<cr>]])
	vim.cmd([[vnoremap <leader>r :SnipRun<cr>]])
	use({
		"michaelb/sniprun",
		opt = true,
		run = "bash ./install.sh",
		cmd = { "SnipRun", "'<,'>SnipRun" },
	})

	use({
		"folke/which-key.nvim",
	})

	-- 可视化的显示vim启动时间
	use({ "dstein64/vim-startuptime", opt = true, cmd = "StartupTime" })

	-- 加速文件类型自动命令的创建，没有其他功能
	use({ "nathom/filetype.nvim", opt = false })
end
