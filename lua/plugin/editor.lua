local set_keymap = vim.api.nvim_set_keymap
return function(use)
	-- 语法高亮增强插件
	use({
		"nvim-treesitter/nvim-treesitter",
		opt = true,
		run = ":TSUpdate",
		event = "BufRead",
		config = function()
			vim.cmd([[set foldmethod=expr]])
			vim.cmd([[set foldexpr=nvim_treesitter#foldexpr()]])

			require("nvim-treesitter.configs").setup({
				ensure_installed = "maintained",
				highlight = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>L"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>H"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
				-- 集成vim-matchup插件
				matchup = { enable = true },
				-- 集成nvim-ts-rainbow，彩虹括号功能
				rainbow = {
					enable = true,
					extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
					max_file_lines = 5000, -- Do not enable for files with more than n lines, int
				},
				-- 集成nvim-ts-context-commentstring，实现语义相关的注释
				context_commentstring = {
					enable = true,
				},
			})
		end,
	})
	-- 接下来是一系列nvim-treesitter的扩展模块
	-- 各种文本对象功能
	use({ "nvim-treesitter/nvim-treesitter-textobjects", opt = true, after = "nvim-treesitter" })
	-- 增强%的跳转功能
	-- use({
	-- 	"andymass/vim-matchup",
	-- 	opt = true,
	-- 	after = "nvim-treesitter",
	-- })
	-- 彩虹括号插件
	use({ "p00f/nvim-ts-rainbow", opt = true, after = "nvim-treesitter", event = "BufRead" })

	-- use({ "romgrk/nvim-treesitter-context", opt = true, after = "nvim-treesitter" })
	-- 增强注释功能
	use({ "JoosepAlviste/nvim-ts-context-commentstring", opt = true, after = "nvim-treesitter" })
	-- 在状态栏显示当前代码结构路径
	use({
		"SmiteshP/nvim-gps",
		opt = true,
		after = "nvim-treesitter",
		config = function()
			require("nvim-gps").setup({
				icons = {
					["class-name"] = " ", -- Classes and class-like objects
					["function-name"] = " ", -- Functions
					["method-name"] = " ", -- Methods (functions inside class-like objects)
					["container-name"] = "▦ ", -- Containers (example: lua tables)
					["tag-name"] = "炙", -- Tags (example: html tags)
				},
			})
		end,
	})

	-- 选中区域扩展插件
	use({
		"terryma/vim-expand-region",
		setup = function()
			vim.cmd([[
        vmap v <Plug>(expand_region_expand)
        vmap b <Plug>(expand_region_shrink)
      ]])
		end,
	})

	-- 大纲插件
	set_keymap("n", "<leader>o", ":SymbolsOutline<cr>", { noremap = true, silent = true })
	use({
		"simrat39/symbols-outline.nvim",
		opt = true,
		cmd = { "SymbolsOutline", "SymbolsOulineOpen" },
		-- 使用setup配置，需要在插件启动前修改全局变量
		setup = function()
			vim.g.symbols_outline = {
				auto_preview = false,
				keymaps = {
					close = "q",
					hover_symbol = "<leader>k",
				},
			}
		end,
	})

	-- 着色器(颜色高亮)插件
	use({
		"norcalli/nvim-colorizer.lua",
		opt = true,
		event = "BufRead",
		config = function()
			require("colorizer").setup()
		end,
	})

	-- 浮动终端
	use({
		"akinsho/toggleterm.nvim",
		opt = true,
		event = "BufRead",
		config = function()
			require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
				open_mapping = [[<c-\>]],
				direction = "vertical",
			})
		end,
	})

	-- 中文文档插件
	use("yianwillis/vimcdoc")

	-- 快速对齐插件
	-- use({ "junegunn/vim-easy-align", opt = true, cmd = "EasyAlign" })

	-- 注释插件
	use({
		"terrortylor/nvim-comment",
		opt = false,
		config = function()
			require("nvim_comment").setup({
        -- 空白行不注释
				comment_empty = false,
				-- 增强注释功能，根据语义更新注释内容
				hook = function()
					require("ts_context_commentstring.internal").update_commentstring()
				end,
			})
		end,
	})

	-- 格式化插件
	use({ "sbdchd/neoformat", opt = true, cmd = "Neoformat" })
	set_keymap("n", "<leader>n", ":Neoformat<cr>", { noremap = true, silent = true })

	-- 加速j和k的移动速度，注释掉感觉没有影响
	-- use({ "rhysd/accelerated-jk", opt = true })

	-- 增强f和t的功能
	use({
		"unblevable/quick-scope",
		setup = function()
			vim.cmd([[
        augroup qs_colors
          autocmd!
          autocmd ColorScheme * highlight QuickScopePrimary guifg='Orange' gui=underline cterm=underline
          autocmd ColorScheme * highlight QuickScopeSecondary guifg='Gray' gui=underline cterm=underline
        augroup END
      ]])
			vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
		end,
	})

	-- 移动光标后禁用搜索高亮
	use({ "romainl/vim-cool", opt = true, event = { "CursorMoved", "InsertEnter" } })

	-- 悬浮终端
	use({
		"numtostr/FTerm.nvim",
		opt = true,
		event = "BufRead",
		config = function()
			local map = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }
			map("n", "<F2>", [[<cmd>lua require('FTerm').open()<cr>]], opts)
			map("t", "<F2>", [[<C-\><C-n><cmd>lua require("FTerm").toggle()<cr>]], opts)
		end,
	})
end
