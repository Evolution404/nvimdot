return function(use)
	use({
		"neovim/nvim-lspconfig",
		opt = true,
		event = "BufReadPre",
		config = function()
			if not packer_plugins["nvim-lspconfig"].loaded then
				vim.cmd([[packadd nvim-lspconfig]])
			end

			if not packer_plugins["nvim-lsp-installer"].loaded then
				vim.cmd([[packadd nvim-lsp-installer]])
			end

			if not packer_plugins["lsp_signature.nvim"].loaded then
				vim.cmd([[packadd lsp_signature.nvim]])
			end

			if not packer_plugins["lspsaga.nvim"].loaded then
				vim.cmd([[packadd lspsaga.nvim]])
			end
		end,
	})

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
			-- 服务端启动后执行内部的回调函数
			lsp_installer.on_server_ready(function(server)
				local opts = {}
				-- 通过判断服务端名称来单独配置各个服务端
				if server.name == "sumneko_lua" then
					opts.settings = {
						Lua = {
							-- 避免对配置文件里的vim和packer_plugins变量报错
							diagnostics = { globals = { "vim", "packer_plugins" } },
							workspace = {
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								},
								maxPreload = 100000,
								preloadFileSize = 10000,
							},
							-- 禁止发送统计数据
							telemetry = { enable = false },
						},
					}
					--elseif (server.name == "clangd") then
				end
				-- 配置服务端的兼容性
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				local completionItem = capabilities.textDocument.completion.completionItem
				completionItem.documentationFormat = {
					"markdown",
					"plaintext",
				}
				completionItem.snippetSupport = true
				completionItem.preselectSupport = true
				completionItem.insertReplaceSupport = true
				completionItem.labelDetailsSupport = true
				completionItem.deprecatedSupport = true
				completionItem.commitCharactersSupport = true
				completionItem.tagSupport = { valueSet = { 1 } }
				completionItem.resolveSupport = {
					properties = { "documentation", "detail", "additionalTextEdits" },
				}
				opts.capabilities = capabilities
				opts.flags = { debounce_text_changes = 500 }
				opts.on_attach = function(_, bufnr)
					require("lsp_signature").on_attach({
						bind = true,
						use_lspsaga = false,
						floating_window = true,
						fix_pos = true,
						hint_enable = true,
						hi_parameter = "Search",
						handler_opts = { "double" },
					})
					local function buf_set_keymap(...)
						vim.api.nvim_buf_set_keymap(bufnr, ...)
					end
					local map_opts = { noremap = true, silent = true }
					buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", map_opts)
					buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", map_opts)
					buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", map_opts)
					buf_set_keymap(
						"n",
						"<leader>wl",
						"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
						map_opts
					)
					buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", map_opts)
					buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", map_opts)
					buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", map_opts)
					buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", map_opts)
					--buf_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.buf.formatting()<CR>', map_opts)
				end
				server:setup(opts)
			end)
		end,
	})
	use({ "tami5/lspsaga.nvim", opt = true, after = "nvim-lspconfig" })
	use({
		"kosayoda/nvim-lightbulb",
		opt = true,
		after = "nvim-lspconfig",
		config = function()
			vim.cmd([[
          autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
        ]])
		end,
	})
	use({ "ray-x/lsp_signature.nvim", opt = true, after = "nvim-lspconfig" })
	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		requires = {
			{ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
			{ "hrsh7th/cmp-buffer", after = "cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp", after = "cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lua", after = "cmp-nvim-lsp" },
			{ "andersevenrud/compe-tmux", branch = "cmp", after = "cmp-nvim-lua" },
			{ "hrsh7th/cmp-path", after = "compe-tmux" },
			{ "f3fora/cmp-spell", after = "cmp-path" },
			-- {
			--     'tzachar/cmp-tabnine',
			--     run = './install.sh',
			--     after = 'cmp-spell',
			--     config = conf.tabnine
			-- }
		},
		config = function()
			local t = function(str)
				return vim.api.nvim_replace_termcodes(str, true, true, true)
			end
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				if col == 0 then
					return false
				end
				return vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local cmp = require("cmp")
			cmp.setup({
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
						-- load lspkind icons
						vim_item.kind = string.format("%s %s", lspkind_icons[vim_item.kind], vim_item.kind)

						vim_item.menu = ({
							-- cmp_tabnine = "[TN]",
							orgmode = "[ORG]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[Lua]",
							buffer = "[BUF]",
							path = "[PATH]",
							tmux = "[TMUX]",
							luasnip = "[SNIP]",
							spell = "[SPELL]",
						})[entry.source.name]

						return vim_item
					end,
				},
				-- You can set mappings if you want
				mapping = {
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.close(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-h>"] = function(fallback)
						if require("luasnip").jumpable(-1) then
							vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
						else
							fallback()
						end
					end,
					["<C-l>"] = function(fallback)
						if require("luasnip").expand_or_jumpable() then
							vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
						else
							fallback()
						end
					end,
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				-- You should specify your *installed* sources.
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "spell" },
					{ name = "tmux" },
					{ name = "orgmode" },
					-- {name = 'cmp_tabnine'},
				},
			})
		end,
	})
	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
		--config = conf.luasnip,
		requires = "rafamadriz/friendly-snippets",
	})
	use({
		"windwp/nvim-autopairs",
		after = "nvim-cmp",
		--config = conf.autopairs
	})
	use({ "github/copilot.vim", opt = true, cmd = "Copilot" })
end
