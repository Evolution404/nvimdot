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
end
