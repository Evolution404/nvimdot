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
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "sv",
						node_incremental = "n",
						scope_incremental = "v",
						node_decremental = "b",
					},
				},
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
        -- 集成nvim-ts-context-commentstring注释插件
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
	use({
		"andymass/vim-matchup",
		opt = true,
		after = "nvim-treesitter",
	})
	-- 彩虹括号插件
	use({ "p00f/nvim-ts-rainbow", opt = true, after = "nvim-treesitter", event = "BufRead" })

	-- use({ "romgrk/nvim-treesitter-context", opt = true, after = "nvim-treesitter" })
  -- 注释插件
	use({ "JoosepAlviste/nvim-ts-context-commentstring", opt = true, after = "nvim-treesitter" })

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

	use({
		"itchyny/vim-cursorword",
		opt = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.cmd([[
        augroup user_plugin_cursorword
        autocmd!
        " 以下文件类型不对当前单词加上下划线
        autocmd FileType NvimTree,lspsagafinder,dashboard let b:cursorword = 0
        autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif
        autocmd InsertEnter * let b:cursorword = 0
        autocmd InsertLeave * let b:cursorword = 1
        augroup END
      ]])
		end,
	})

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
				languages = { -- You can disable any language individually here
					["c"] = true,
					["cpp"] = true,
					["go"] = true,
					["java"] = true,
					["javascript"] = true,
					["lua"] = true,
					["python"] = true,
					["rust"] = true,
				},
				separator = " > ",
			})
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		opt = true,
		ft = { "html", "xml" },
		config = function()
			require("nvim-ts-autotag").setup({
				filetypes = {
					"html",
					"xml",
					"javascript",
					"typescriptreact",
					"javascriptreact",
					"vue",
				},
			})
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		opt = true,
		event = "BufRead",
		config = function()
			require("colorizer").setup()
		end,
	})
	--use({
	--	"karb94/neoscroll.nvim",
	--	opt = true,
	--	event = "WinScrolled",
	--	config = function()
	--		require("neoscroll").setup({
	--			-- All these keys will be mapped to their corresponding default scrolling animation
	--			mappings = {
	--				"<C-u>",
	--				"<C-d>",
	--				"<C-b>",
	--				"<C-f>",
	--				"<C-y>",
	--				"<C-e>",
	--				"zt",
	--				"zz",
	--				"zb",
	--			},
	--			hide_cursor = true, -- Hide cursor while scrolling
	--			stop_eof = true, -- Stop at <EOF> when scrolling downwards
	--			use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
	--			respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	--			cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	--			easing_function = nil, -- Default easing function
	--			pre_hook = nil, -- Function to run before the scrolling animation starts
	--			post_hook = nil, -- Function to run after the scrolling animation ends
	--		})
	--	end,
	--})
	-- session操作，手动保存或恢复
	vim.cmd([[
    nnoremap <silent><leader>ss :SaveSession<CR>
    nnoremap <silent><leader>sr :RestoreSession<CR>
    nnoremap <silent><leader>sd :DeleteSession<CR>
  ]])
	use({
		"rmagatti/auto-session",
		opt = true,
		cmd = { "SaveSession", "RestoreSession", "DeleteSession" },
		config = function()
			require("auto-session").setup({
				log_level = "error",
			})
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
			function _G.set_terminal_keymaps()
				local opts = { noremap = true }
				vim.api.nvim_buf_set_keymap(0, "t", "<C-]>", [[<C-\><C-n>]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", [[<C-\><C-n><C-W>h]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", [[<C-\><C-n><C-W>j]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", [[<C-\><C-n><C-W>k]], opts)
				vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", [[<C-\><C-n><C-W>l]], opts)
			end
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	})
	local function dap_config()
		local dap = require("dap")

		dap.adapters.go = function(callback, _)
			local stdout = vim.loop.new_pipe(false)
			local handle
			local pid_or_err
			local port = 38697
			local opts = {
				stdio = { nil, stdout },
				args = { "dap", "-l", "127.0.0.1:" .. port },
				detached = true,
			}
			handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
				stdout:close()
				handle:close()
				if code ~= 0 then
					print("dlv exited with code", code)
				end
			end)
			assert(handle, "Error running dlv: " .. tostring(pid_or_err))
			stdout:read_start(function(err, chunk)
				assert(not err, err)
				if chunk then
					vim.schedule(function()
						require("dap.repl").append(chunk)
					end)
				end
			end)
			-- Wait for delve to start
			vim.defer_fn(function()
				callback({ type = "server", host = "127.0.0.1", port = port })
			end, 100)
		end
		-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
		dap.configurations.go = {
			{ type = "go", name = "Debug", request = "launch", program = "${file}" },
			{
				type = "go",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}",
			}, -- works with go.mod packages and sub packages
			{
				type = "go",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
		}

		dap.adapters.python = {
			type = "executable",
			command = os.getenv("HOME") .. "/.local/share/nvim/dapinstall/python_dbg/bin/python",
			args = { "-m", "debugpy.adapter" },
		}
		dap.configurations.python = {
			{
				-- The first three options are required by nvim-dap
				type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
				request = "launch",
				name = "Launch file",

				-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

				program = "${file}", -- This configuration will launch the current file if used.
				pythonPath = function()
					-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
					-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
					-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
						return cwd .. "/venv/bin/python"
					elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
						return cwd .. "/.venv/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
		}
	end
	use({
		"rcarriga/nvim-dap-ui",
		opt = false,
		requires = {
			{
				"mfussenegger/nvim-dap",
				config = dap_config,
			},
			{
				"Pocco81/DAPInstall.nvim",
				opt = true,
				cmd = { "DIInstall", "DIUninstall", "DIList" },
				--config = dapinstall_config
			},
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			require("dapui").setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					-- Use a table to apply multiple mappings
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
				},
				sidebar = {
					elements = {
						-- Provide as ID strings or tables with "id" and "size" keys
						-- size can be float or integer > 1
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 00.25 },
					},
					size = 40,
					position = "left",
				},
				tray = {
					elements = { "repl" },
					size = 10,
					position = "bottom",
				},
				floating = {
					max_height = nil,
					max_width = nil,
					mappings = { close = { "q", "<Esc>" } },
				},
				windows = { indent = 1 },
			})
		end,
	})
	use("yianwillis/vimcdoc") -- 中文文档
	use({ "junegunn/vim-easy-align", opt = true, cmd = "EasyAlign" })
	use({
		"terrortylor/nvim-comment",
		opt = false,
		config = function()
			require("nvim_comment").setup({
				hook = function()
					require("ts_context_commentstring.internal").update_commentstring()
				end,
			})
		end,
	})
	set_keymap("n", "<leader>n", ":Neoformat<cr>", { noremap = true, silent = true })
	use({ "sbdchd/neoformat", opt = true, cmd = "Neoformat" })
	use({ "rhysd/accelerated-jk", opt = true })
	use({ "hrsh7th/vim-eft", opt = true })
	use({ "romainl/vim-cool", opt = true, event = { "CursorMoved", "InsertEnter" } })
	use({
		"phaazon/hop.nvim",
		opt = true,
		branch = "v1",
		cmd = {
			"HopLine",
			"HopLineStart",
			"HopWord",
			"HopPattern",
			"HopChar1",
			"HopChar2",
		},
		config = function()
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	})
	use({ "vimlab/split-term.vim", opt = true, cmd = { "Term", "VTerm" } })
	use({ "numtostr/FTerm.nvim", opt = true, event = "BufRead" })
	use({ "jdhao/better-escape.vim", opt = true, event = "InsertEnter" })
end
