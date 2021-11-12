local set_keymap = vim.api.nvim_set_keymap

return function(use)
  --use{'morhetz/gruvbox',config=function()
  --  vim.cmd[[colorscheme gruvbox]]
  --end}
  use 'kyazdani42/nvim-web-devicons' -- 支持特殊符号
  use {'sainnhe/edge',
    config = function()
      vim.g.edge_style = "aura"
      vim.g.edge_enable_italic = 1
      vim.g.edge_disable_italic_comment = 1
      vim.g.edge_show_eob = 1
      vim.g.edge_better_performance = 1
      vim.cmd [[set background=dark]]
      vim.cmd[[colorscheme edge]]
    end
  }

  use{'hoob3rt/lualine.nvim',
    opt = true,
    after = 'lualine-lsp-progress',
    config = function()
      local gps = require("nvim-gps")
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'onedark',
          disabled_filetypes = {},
          --component_separators = '|',
          component_separators = {left = '', right = ''},
          section_separators = {left = '', right = ''},
        },
        sections = {
          lualine_a = {{'mode', fmt = function(str) return str:sub(1,1) end}},
          lualine_b = {
            'branch',
            {
              'diff',
              colored = true,
              diff_color = {
                added = {fg = "#A0C980"},
                modified = {fg = "#6CB6EB"},
                removed = {fg = "#EC7279"},
              },
              -- 利用gitsigns插件来提供文件变动的信息
              source = function()
                local dict = vim.b.gitsigns_status_dict
                if(dict) then
                  return {added = dict.added, modified = dict.changed, removed = dict.removed}
                end
                return dict
              end
            }},
          lualine_c = {
            {'filename', path = 1}, {gps.get_location, condition = gps.is_available}, {'lsp_progress'}
          },
          lualine_x = {
            {
              'diagnostics',
              sources = {'nvim_lsp'},
              color_error = "#BF616A",
              color_warn = "#EBCB8B",
              color_info = "#81A1AC",
              color_hint = "#88C0D0",
              symbols = {error = ' ', warn = ' ', info = ' '}
            },
          },
          lualine_y = {'filetype', 'encoding', 'fileformat'},
          lualine_z = {{'progress', padding = 0}, {'%L'}, {"os.date('%H:%M')"}}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location', '%L'},
          lualine_y = {},
          lualine_z = {}
        },
        extensions = {}
      }
    end
  }

  -- <leader>f打开文件浏览器
  set_keymap("n","<leader>f", ":NvimTreeToggle<cr>", {noremap=true,silent=true})
  use{'kyazdani42/nvim-tree.lua',
    opt = true,
    cmd = {'NvimTreeToggle', 'NvimTreeOpen'},
    config = function()
      local tree_cb = require'nvim-tree.config'.nvim_tree_callback
      require('nvim-tree').setup {
        gitignore = true,
        ignore = {'.git', 'node_modules', '.cache'},
        open_on_tab = false,
        disable_netrw = true,
        hijack_netrw = true,
        auto_close = true,
        highlight_opened_files = true,
        auto_ignore_ft = {'startify', 'dashboard'},
        update_focused_file = {
          enable = true,
          update_cwd = true,
          ignore_list = {'help'}
        },
        view = {
          width = 30,
          side = 'left',
          auto_resize = false,
          mappings = {
            custom_only = true,
            -- list of mappings to set on the tree manually
            list = {
              {key = ".", cb = tree_cb("toggle_dotfiles")},
              {key = "h", cb = tree_cb("dir_up")},
              {key = "l", cb = tree_cb("dir_down")},
              {key = "o", cb = tree_cb("cd")},
              {key = "<cr>", cb = tree_cb("tabnew")},
              {key = "<C-v>", cb = tree_cb("vsplit")},
              {key = "<C-x>", cb = tree_cb("split")},
              {key = "<", cb = tree_cb("prev_sibling")},
              {key = ">", cb = tree_cb("next_sibling")},
              {key = "P", cb = tree_cb("parent_node")},
              {key = "<Tab>", cb = tree_cb("preview")},
              {key = "K", cb = tree_cb("first_sibling")},
              {key = "J", cb = tree_cb("last_sibling")},
              {key = "I", cb = tree_cb("toggle_ignored")},
              {key = "R", cb = tree_cb("refresh")},
              {key = "a", cb = tree_cb("create")},
              {key = "d", cb = tree_cb("remove")},
              {key = "r", cb = tree_cb("rename")},
              {key = "<C-r>", cb = tree_cb("full_rename")},
              {key = "x", cb = tree_cb("cut")},
              {key = "c", cb = tree_cb("copy")},
              {key = "p", cb = tree_cb("paste")},
              {key = "q", cb = tree_cb("close")},
              {key = "g?", cb = tree_cb("toggle_help")},
            }
          }
        }
      }
    end
  }

  -- 切换buffer的映射
  vim.cmd[[
    nnoremap <silent><leader>j :BufferLineCycleNext<CR>
    nnoremap <silent><leader>k :BufferLineCyclePrev<CR>
    nnoremap <silent><leader>> :BufferLineMoveNext<CR>
    nnoremap <silent><leader>< :BufferLineMovePrev<CR>
  ]]
  use{'akinsho/bufferline.nvim',
    opt = true,
    event = 'BufRead',
    config = function()
      require('bufferline').setup {
        options = {
          number = "none",
          modified_icon = '✥',
          buffer_close_icon = '',
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 14,
          max_prefix_length = 13,
          tab_size = 20,
          show_buffer_close_icons = true,
          show_buffer_icons = true,
          show_tab_indicators = true,
          diagnostics = "nvim_lsp",
          always_show_bufferline = true,
          separator_style = "thin",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              padding = 1
            }
          }
        }
      }
    end
  }

  -- 标记文件的变化
  use{'lewis6991/gitsigns.nvim',
    opt = true,
    event = {'BufRead', 'BufNewFile'},
    requires = {'nvim-lua/plenary.nvim', opt = true},
    config = function()
      if not packer_plugins['plenary.nvim'].loaded then
        vim.cmd [[packadd plenary.nvim]]
      end
      require('gitsigns').setup {
        signs = {
          add = {text = '▋'},
          change = {text = '▋'},
          delete = {text = '▋'},
          topdelete = {text = '‾'},
          changedelete = {text = '~'},
        },
        keymaps = {
          -- 以下定义了一系列按键操作
          noremap = true,
          buffer = true,
          -- 在hunk之间前后跳转
          ['n ]g'] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
          ['n [g'] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
          -- 保存或撤销暂存区
          ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          -- 将编辑内容恢复到git暂存区内容，可以恢复一个hunk或者恢复整个文件
          ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
          -- 对比当前hunk所做的修改
          ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
          -- 查看产生当前行的提交
          ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
          -- 定义文本对象
          ['o ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>',
          ['x ih'] = ':<C-U>lua require"gitsigns".select_hunk()<CR>'
        },
        diff_opts = {algorithm = "minimal"}
      }
    end
  }

  use{'lukas-reineke/indent-blankline.nvim',
    opt = true,
    event = 'BufRead',
    config = function()
      vim.cmd [[highlight IndentTwo guifg=#D08770 guibg=NONE gui=nocombine]]
      vim.cmd [[highlight IndentThree guifg=#EBCB8B guibg=NONE gui=nocombine]]
      vim.cmd [[highlight IndentFour guifg=#A3BE8C guibg=NONE gui=nocombine]]
      vim.cmd [[highlight IndentFive guifg=#5E81AC guibg=NONE gui=nocombine]]
      vim.cmd [[highlight IndentSix guifg=#88C0D0 guibg=NONE gui=nocombine]]
      vim.cmd [[highlight IndentSeven guifg=#B48EAD guibg=NONE gui=nocombine]]
      vim.g.indent_blankline_char_highlight_list = {
        "IndentTwo", "IndentThree", "IndentFour", "IndentFive", "IndentSix",
        "IndentSeven"
      }
      require("indent_blankline").setup {
        char = "│",
        show_first_indent_level = true,
        filetype_exclude = {
          "startify", "dashboard", "dotooagenda", "log", "fugitive",
          "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
          "vista", "help", "todoist", "NvimTree", "peekaboo", "git",
          "TelescopePrompt", "undotree", "flutterToolsOutline", "" -- for all buffers without a file type
        },
        buftype_exclude = {"terminal", "nofile"},
        show_trailing_blankline_indent = false,
        show_current_context = true,
        context_patterns = {
          "class", "function", "method", "block", "list_literal", "selector",
          "^if", "^table", "if_statement", "while", "for", "type", "var",
          "import"
        }
      }
      -- because lazy load indent-blankline so need readd this autocmd
      vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
    end
  }

  use{'folke/zen-mode.nvim',
    opt = true,
    cmd = 'ZenMode',
    config = function() require('zen-mode').setup {} end
  }

  use{'folke/twilight.nvim',
    opt = true,
    cmd = {'Twilight', 'TwilightEnable'},
    config = function() require('twilight').setup {} end
  }

  use{'arkav/lualine-lsp-progress',
    opt = true,
    after = 'nvim-gps',
  }

  use{'glepnir/dashboard-nvim',opt = true, event = "BufWinEnter"}

end
