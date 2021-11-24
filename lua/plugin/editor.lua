local set_keymap = vim.api.nvim_set_keymap
return function(use)
	set_keymap("n", "<leader>l", ":SymbolsOutline<cr>", { noremap = true, silent = true })
	use({
		"simrat39/symbols-outline.nvim",
		opt = true,
		cmd = { "SymbolsOutline", "SymbolsOulineOpen" },
		-- 使用setup配置，需要在插件启动前修改全局变量
		setup = function()
      -- 注释掉的为默认配置
			vim.g.symbols_outline = {
				--highlight_hovered_item = true,
				--show_guides = true,
				auto_preview = false,
				--position = "right",
				--show_numbers = false,
				--show_relative_numbers = false,
				--show_symbol_details = true,
				keymaps = {
					close = "q",
					--goto_location = "<Cr>",
					--focus_location = "o",
					hover_symbol = "<leader>k",
					--rename_symbol = "r",
					--code_actions = "a",
				},
				--lsp_blacklist = {},
				--symbols = {
				--	File = { icon = "", hl = "TSURI" },
				--	Module = { icon = "", hl = "TSNamespace" },
				--	Namespace = { icon = "", hl = "TSNamespace" },
				--	Package = { icon = "", hl = "TSNamespace" },
				--	Class = { icon = "𝓒", hl = "TSType" },
				--	Method = { icon = "ƒ", hl = "TSMethod" },
				--	Property = { icon = "", hl = "TSMethod" },
				--	Field = { icon = "", hl = "TSField" },
				--	Constructor = { icon = "", hl = "TSConstructor" },
				--	Enum = { icon = "ℰ", hl = "TSType" },
				--	Interface = { icon = "ﰮ", hl = "TSType" },
				--	Function = { icon = "", hl = "TSFunction" },
				--	Variable = { icon = "", hl = "TSConstant" },
				--	Constant = { icon = "", hl = "TSConstant" },
				--	String = { icon = "𝓐", hl = "TSString" },
				--	Number = { icon = "#", hl = "TSNumber" },
				--	Boolean = { icon = "⊨", hl = "TSBoolean" },
				--	Array = { icon = "", hl = "TSConstant" },
				--	Object = { icon = "⦿", hl = "TSType" },
				--	Key = { icon = "🔐", hl = "TSType" },
				--	Null = { icon = "NULL", hl = "TSType" },
				--	EnumMember = { icon = "", hl = "TSField" },
				--	Struct = { icon = "𝓢", hl = "TSType" },
				--	Event = { icon = "🗲", hl = "TSType" },
				--	Operator = { icon = "+", hl = "TSOperator" },
				--	TypeParameter = { icon = "𝙏", hl = "TSParameter" },
				--},
			}
		end,
	})
	use({
		"itchyny/vim-cursorword",
		opt = true,
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.api.nvim_command("augroup user_plugin_cursorword")
			vim.api.nvim_command("autocmd!")
			vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard let b:cursorword = 0")
			vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
			vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
			vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
			vim.api.nvim_command("augroup END")
		end,
	})
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
				highlight = { enable = true, disable = { "vim" } },
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]["] = "@function.outer",
							["]m"] = "@class.outer",
						},
						goto_next_end = {
							["]]"] = "@function.outer",
							["]M"] = "@class.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
							["[m"] = "@class.outer",
						},
						goto_previous_end = {
							["[]"] = "@function.outer",
							["[M"] = "@class.outer",
						},
					},
				},
				rainbow = {
					enable = true,
					extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
					max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
				},
				context_commentstring = { enable = true, enable_autocmd = false },
				matchup = { enable = true },
				context = { enable = true, throttle = true },
			})
		end,
	})
	--use({
	--	"andymass/vim-matchup",
	--	opt = true,
	--	after = "nvim-treesitter",
	--	config = function()
	--		vim.cmd([[let g:matchup_matchparen_offscreen = {'method': 'popup'}]])
	--	end,
	--})
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
	use({ "nvim-treesitter/nvim-treesitter-textobjects", opt = true, after = "nvim-treesitter" })
	--use({ "romgrk/nvim-treesitter-context", opt = true, after = "nvim-treesitter" })
	use({ "p00f/nvim-ts-rainbow", opt = true, after = "nvim-treesitter", event = "BufRead" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring", opt = true, after = "nvim-treesitter" })
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
