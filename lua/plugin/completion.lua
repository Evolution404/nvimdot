return function(use)
  use{'neovim/nvim-lspconfig',
    opt = true,
    event = 'BufReadPre',
    --config = conf.nvim_lsp
  }
  use{'williamboman/nvim-lsp-installer', opt = true, after = 'nvim-lspconfig'}
  use{'tami5/lspsaga.nvim', opt = true, after = 'nvim-lspconfig'}
  use{'kosayoda/nvim-lightbulb',
      opt = true,
      after = 'nvim-lspconfig',
      --config = conf.lightbulb
  }
  use{'ray-x/lsp_signature.nvim', opt = true, after = 'nvim-lspconfig'}
  use{'hrsh7th/nvim-cmp',
      --config = conf.cmp,
      event = 'InsertEnter',
      requires = {
          {'saadparwaiz1/cmp_luasnip', after = 'LuaSnip'},
          {'hrsh7th/cmp-buffer', after = 'cmp_luasnip'},
          {'hrsh7th/cmp-nvim-lsp', after = 'cmp-buffer'},
          {'hrsh7th/cmp-nvim-lua', after = 'cmp-nvim-lsp'},
          {'andersevenrud/compe-tmux', branch = 'cmp', after = 'cmp-nvim-lua'},
          {'hrsh7th/cmp-path', after = 'compe-tmux'},
          {'f3fora/cmp-spell', after = 'cmp-path'}
          -- {
          --     'tzachar/cmp-tabnine',
          --     run = './install.sh',
          --     after = 'cmp-spell',
          --     config = conf.tabnine
          -- }
      }
  }
  use{'L3MON4D3/LuaSnip',
      after = 'nvim-cmp',
      --config = conf.luasnip,
      requires = 'rafamadriz/friendly-snippets'
  }
  use{'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      --config = conf.autopairs
  }
  use{'github/copilot.vim', opt = true, cmd = "Copilot"}
end
