return function(use)
	-- neovim官方插件，为主流的lsp server设置基础配置
	use({
		"neovim/nvim-lspconfig",
		opt = true,
		event = "BufReadPre",
	})

	-- 用于一键安装各类lsp server，并在此插件内部设置各个server的配置项
	use({
		"williamboman/nvim-lsp-installer",
		opt = true,
		after = "nvim-lspconfig",
		config = function()
			local lsp_installer = require("nvim-lsp-installer")

			lsp_installer.settings({
				ui = {
					icons = {
						server_installed = "",
						server_pending = "",
						server_uninstalled = "",
					},
				},
			})
			-- lsp server连接一个缓冲区的时候执行的回调函数
			local function lsp_on_attach()
				local function set_key_map(mode, lhs, rhs)
					vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, { noremap = true, silent = true })
				end
				-- 在悬浮窗口中打开文档
				set_key_map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
				-- 变量名重命名
				set_key_map("n", "gr", "<cmd>Lspsaga rename<CR>")
				-- 跳转到定义
				set_key_map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
				-- 打开实现
				set_key_map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
				set_key_map("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
				set_key_map("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>")
				-- 查看当前位置可以使用的codeaction
				set_key_map("n", "gx", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>")
				set_key_map("x", "gx", ":<c-u>lua require('lspsaga.codeaction').code_action()<CR>")
				-- 在诊断信息中前后跳转
				set_key_map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
				set_key_map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
				set_key_map("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>")
				set_key_map("n", "<leader>lw", "<cmd>lua print(vim.lsp.buf.list_workspace_folders()[1])<CR>")
			end
			-- 服务端启动后执行内部的回调函数，通过setup函数为每个lsp server设置配置选项
			lsp_installer.on_server_ready(function(server)
				-- 设置所有lsp server的默认选项
				local opts = {
					flags = { debounce_text_changes = 500 },
					on_attach = lsp_on_attach,
				}
				-- 通过判断服务端名称来单独配置各个服务端
				if server.name == "sumneko_lua" then
					opts.settings = {
						Lua = {
							-- 避免对配置文件里的vim和packer_plugins变量报错
							diagnostics = { globals = { "vim", "packer_plugins" } },
							-- 禁止发送统计数据
							telemetry = { enable = false },
						},
					}
				elseif server.name == "gopls" then
					-- 单个go文件也启用lsp
					opts.single_file_support = true
				end
				-- 为服务端最终设置配置选项
				server:setup(opts)
			end)
		end,
	})

	-- 在输入函数参数的时候展示当前正在输入的参数
	use({
		"ray-x/lsp_signature.nvim",
		opt = true,
		after = "nvim-lspconfig",
		config = function()
			require("lsp_signature").setup({
				bind = true,
				use_lspsaga = false,
				floating_window = true,
				fix_pos = true,
				hint_enable = true,
				hi_parameter = "Search",
				handler_opts = {
					border = "rounded",
				},
			})
		end,
	})

	-- 对lsp的各类功能提供悬浮窗口展示
	use({
		"tami5/lspsaga.nvim",
		opt = true,
		after = "nvim-lspconfig",
	})

	-- 在存在code action的行显示一个灯泡符号💡，用来提醒
	use({
		"kosayoda/nvim-lightbulb",
		opt = true,
		after = "nvim-lspconfig",
		config = function()
			-- 重新定义标记的符号，避免灯泡下面出现下划线
			vim.fn.sign_define("LightBulbSign", { text = "💡", texthl = "", linehl = "", numhl = "" })
			vim.cmd([[
          autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
        ]])
		end,
	})

	-- 以下是一系列为nvim-cmp提供补全内容的插件
	use({ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" })
	-- 提供当前缓冲区的内容作为补全项
	use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
	use({ "f3fora/cmp-spell", after = "nvim-cmp" })
	-- 代码片段插件
	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
		config = function()
			require("luasnip").config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})
			-- 加载friendly_snippets
			local friendly_snippets_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/friendly-snippets"
			require("luasnip/loaders/from_vscode").load({ paths = friendly_snippets_path })
		end,
		requires = "rafamadriz/friendly-snippets",
	})
	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				-- 定义补全列表展示出来的格式，包括kind和menu两部分
				-- kind：一个特殊符号以及类型名称
				-- menu：展示补全的来源
				formatting = {
					format = function(entry, vim_item)
						local lspkind_icons = {
							Text = "",
							Method = "",
							Function = "",
							Constructor = "",
							Field = "ﰠ",
							Variable = "",
							Class = "ﴯ",
							Interface = "",
							Module = "",
							Property = "ﰠ",
							Unit = "塞",
							Value = "",
							Enum = "",
							Keyword = "",
							Snippet = "",
							Color = "",
							File = "",
							Reference = "",
							Folder = "",
							EnumMember = "",
							Constant = "",
							Struct = "פּ",
							Event = "",
							Operator = "",
							TypeParameter = "",
						}
						-- 构造出来 特殊符号+类型名称 的格式
						vim_item.kind = string.format("%s %s", lspkind_icons[vim_item.kind], vim_item.kind)
						-- 补全条目的各种来源名称
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							buffer = "[BUF]",
							path = "[PATH]",
							luasnip = "[SNIP]",
							spell = "[SPELL]",
						})[entry.source.name]

						return vim_item
					end,
				},
				-- 定义补全过程中使用的映射
				mapping = {
					-- 回车键确定选项
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- <Tab>键使用代码片段，继续按切换下一个填充位置
					["<Tab>"] = cmp.mapping(function(fallback)
						local ls = require("luasnip")
						if ls.expand_or_locally_jumpable() then
							ls.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					-- <S-Tab>键切换代码片段上一个位置
					["<S-Tab>"] = cmp.mapping(function(fallback)
						local ls = require("luasnip")
						if ls.jumpable(-1) then
							ls.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					-- 通过<C-l>跳转到代码片段下一个位置
					["<C-l>"] = cmp.mapping(function()
						local ls = require("luasnip")
						if ls.expand_or_locally_jumpable() then
							ls.expand_or_jump()
						end
					end, { "i", "s" }),
					-- 通过<C-h>跳转到代码片段上一个位置
					["<C-h>"] = cmp.mapping(function()
						local ls = require("luasnip")
						if ls.jumpable(-1) then
							ls.jump(-1)
						end
					end, { "i", "s" }),
					-- <C-n>和<C-p>用来前后切换选项
					["<C-n>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item()
						else
							cmp.complete()
						end
					end),
					["<C-p>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						end
					end),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.close(),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				-- 指定补全项的来源都有哪些
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "spell" },
				},
			})
		end,
	})
	-- 括号自动补全插件
	use({
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		config = function()
			local npairs = require("nvim-autopairs")
			-- 启用fast_wrap，可以利用<M-e>快速补全括号
			npairs.setup({ fast_wrap = {} })

			-- 自定义一个补全规则
			--local Rule = require('nvim-autopairs.rule')
			--npairs.add_rules({
			--  Rule("u%d%d%d%d$", "number", "lua")
			--    :use_regex(true)
			--})
			-- 补全后自动添加括号
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		end,
	})
end
