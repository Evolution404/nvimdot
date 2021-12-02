return function(use)
	use({ "rust-lang/rust.vim", opt = true, ft = "rust" })
	use({
		"simrat39/rust-tools.nvim",
		opt = true,
		ft = "rust",
		--config = conf.rust_tools
	})
	use({
		"nvim-orgmode/orgmode",
		opt = true,
		ft = "org",
		--config = conf.lang_org
	})
	use({ "iamcco/markdown-preview.nvim", opt = true, ft = "markdown", run = "cd app && yarn install" })
	use({
		"fatih/vim-go",
		opt = true,
		ft = "go",
		config = function()
			vim.cmd([[
        nnoremap <leader>I :GoImplements<cr>
        nnoremap <leader>i :GoImports<cr>
        nnoremap <leader>c :GoCallers<cr>
      ]])
		end,
	})
end
