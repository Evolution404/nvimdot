return function(use)
	use("romgrk/fzy-lua-native")

	-- 远程内容复制插件
	use({
		"ojroques/vim-oscyank",
		config = function()
      vim.cmd[[
        vnoremap <leader>y :OSCYank<CR>
        nmap <leader>y <Plug>OSCYank
      ]]
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
	use({
		"nvim-telescope/telescope.nvim",
		opt = true,
		cmd = "Telescope",
		requires = {
			{ "nvim-lua/popup.nvim", opt = true },
			{ "nvim-lua/plenary.nvim", opt = true },
		},
		config = function()
			local home = os.getenv("HOME")

			if not packer_plugins["plenary.nvim"].loaded then
				vim.cmd([[packadd plenary.nvim]])
			end

			if not packer_plugins["popup.nvim"].loaded then
				vim.cmd([[packadd popup.nvim]])
			end

			if not packer_plugins["telescope-fzy-native.nvim"].loaded then
				vim.cmd([[packadd telescope-fzy-native.nvim]])
			end

			if not packer_plugins["telescope-project.nvim"].loaded then
				vim.cmd([[packadd telescope-project.nvim]])
			end

			if not packer_plugins["sql.nvim"].loaded then
				vim.cmd([[packadd sql.nvim]])
			end

			if not packer_plugins["telescope-frecency.nvim"].loaded then
				vim.cmd([[packadd telescope-frecency.nvim]])
			end

			if not packer_plugins["telescope-media-files.nvim"].loaded then
				vim.cmd([[packadd telescope-media-files.nvim]])
			end

			if not packer_plugins["telescope-zoxide"].loaded then
				vim.cmd([[packadd telescope-zoxide]])
			end

			require("telescope").load_extension("fzy_native")
			require("telescope").load_extension("project")
			require("telescope").load_extension("frecency")
			require("telescope").load_extension("media_files")
			require("telescope").load_extension("zoxide")

			require("telescope").setup({
				defaults = {
					prompt_prefix = "🔭 ",
					selection_caret = " ",
					layout_config = {
						horizontal = { prompt_position = "bottom", results_width = 0.6 },
						vertical = { mirror = false },
					},
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
					file_sorter = require("telescope.sorters").get_fuzzy_file,
					file_ignore_patterns = {},
					generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
					path_display = { "absolute" },
					winblend = 0,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					use_less = true,
					set_env = { ["COLORTERM"] = "truecolor" },
				},
				extensions = {
					fzy_native = {
						override_generic_sorter = false,
						override_file_sorter = true,
					},
					frecency = {
						show_scores = true,
						show_unindexed = true,
						ignore_patterns = { "*.git/*", "*/tmp/*" },
						workspaces = {
							["conf"] = home .. "/.config",
							["data"] = home .. "/.local/share",
							["nvim"] = home .. "/.config/nvim",
							["code"] = home .. "/code",
							["c"] = home .. "/code/c",
							["cpp"] = home .. "/code/cpp",
							["go"] = home .. "/go/src",
							["rust"] = home .. "/code/rs",
						},
					},
					media_files = {
						filetypes = { "png", "webp", "jpg", "jpeg", "pdf" },
						find_cmd = "fd",
					},
				},
			})
		end,
	})
	use({
		"folke/trouble.nvim",
		opt = true,
		cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
		config = function()
			require("trouble").setup({
				position = "bottom", -- position of the list can be: bottom, top, left, right
				height = 10, -- height of the trouble list when position is top or bottom
				width = 50, -- width of the list when position is left or right
				icons = true, -- use devicons for filenames
				mode = "lsp_workspace_diagnostics", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
				fold_open = "", -- icon used for open folds
				fold_closed = "", -- icon used for closed folds
				action_keys = { -- key mappings for actions in the trouble list
					-- map to {} to remove a mapping, for example:
					-- close = {},
					close = "q", -- close the list
					cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
					refresh = "r", -- manually refresh
					jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
					open_split = { "<c-x>" }, -- open buffer in new split
					open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
					open_tab = { "<c-t>" }, -- open buffer in new tab
					jump_close = { "o" }, -- jump to the diagnostic and close the list
					toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
					toggle_preview = "P", -- toggle auto_preview
					hover = "K", -- opens a small popup with the full multiline message
					preview = "p", -- preview the diagnostic location
					close_folds = { "zM", "zm" }, -- close all folds
					open_folds = { "zR", "zr" }, -- open all folds
					toggle_fold = { "zA", "za" }, -- toggle fold of current file
					previous = "k", -- preview item
					next = "j", -- next item
				},
				indent_lines = true, -- add an indent guide below the fold icons
				auto_open = false, -- automatically open the list when you have diagnostics
				auto_close = false, -- automatically close the list when you have no diagnostics
				auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
				auto_fold = false, -- automatically fold a file trouble list at creation
				signs = {
					-- icons / text used for a diagnostic
					error = "",
					warning = "",
					hint = "",
					information = "",
					other = "﫠",
				},
				use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
			})
		end,
	})
	use({
		"michaelb/sniprun",
		opt = true,
		run = "bash ./install.sh",
		cmd = { "SnipRun", "'<,'>SnipRun" },
		config = function()
			require("sniprun").setup({
				selected_interpreters = {}, -- " use those instead of the default for the current filetype
				repl_enable = {}, -- " enable REPL-like behavior for the given interpreters
				repl_disable = {}, -- " disable REPL-like behavior for the given interpreters

				interpreter_options = {}, -- " intepreter-specific options, consult docs / :SnipInfo <name>

				-- " you can combo different display modes as desired
				display = {
					"Classic", -- "display results in the command-line  area
					"VirtualTextOk", -- "display ok results as virtual text (multiline is shortened)

					"VirtualTextErr", -- "display error results as virtual text
					-- "TempFloatingWindow",      -- "display results in a floating window
					"LongTempFloatingWindow", -- "same as above, but only long results. To use with VirtualText__
					-- "Terminal"                 -- "display results in a vertical split
				},

				-- " miscellaneous compatibility/adjustement settings
				inline_messages = 0, -- " inline_message (0/1) is a one-line way to display messages
				-- " to workaround sniprun not being able to display anything

				borders = "shadow", -- " display borders around floating windows
				-- " possible values are 'none', 'single', 'double', or 'shadow'
			})
		end,
	})
	use({ "nvim-telescope/telescope-fzy-native.nvim", opt = true, after = "telescope.nvim" })

	use({ "nvim-telescope/telescope-project.nvim", opt = true, after = "telescope.nvim" })
	use({
		"nvim-telescope/telescope-frecency.nvim",
		opt = true,
		after = "telescope.nvim",
		requires = { { "tami5/sql.nvim", opt = true } },
	})
	use({ "nvim-telescope/telescope-media-files.nvim", opt = true, after = "telescope.nvim" })
	use({ "jvgrootveld/telescope-zoxide", opt = true, after = "telescope.nvim" })
	use({ "thinca/vim-quickrun", opt = true, cmd = { "QuickRun", "Q" } })
	use({
		"folke/which-key.nvim",
		opt = true,
		keys = ",",
		--config = function() require("which-key").setup {} end
	})
	use({ "dstein64/vim-startuptime", opt = true, cmd = "StartupTime" })
	use({ "nathom/filetype.nvim", opt = false })
end
