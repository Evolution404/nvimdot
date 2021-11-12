local set_keymap = vim.api.nvim_set_keymap

return function(use)
  -- 之前使用的gruvbox配色
  --use{'morhetz/gruvbox',config=function()
  --  vim.cmd[[colorscheme gruvbox]]
  --end}
  -- 当前使用edge配色
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
  -- 用于支持特殊符号
  use 'kyazdani42/nvim-web-devicons'

  -- 底部显示的状态栏插件
  use{'hoob3rt/lualine.nvim',
    opt = true,
    after = 'lualine-lsp-progress',
    config = function()
      local gps = require("nvim-gps")
      require('lualine').setup {
        options = {
          -- 状态栏的配色方案
          theme = 'onedark',
          -- 组件之间使用圆滑的分隔符，默认是尖锐的分隔符
          component_separators = {left = '', right = ''},
          section_separators = {left = '', right = ''},
        },
        sections = {
          -- a部分：显示vim的当前模式，只展示模式名称的第一个字母
          lualine_a = {
            {'mode', fmt = function(str) return str:sub(1,1) end}
          },
          -- b部分：显示分支名称和文件变动信息
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
            }
          },
          -- c部分：显示文件名，路径位置，lsp进度
          lualine_c = {
            {'filename', path = 1},
            {gps.get_location, condition = gps.is_available},
            {'lsp_progress'},
          },
          -- x部分：显示诊断信息
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
          -- y部分：显示文件类型，文件编码，文件格式
          lualine_y = {'filetype', 'encoding', 'fileformat'},
          -- z部分：显示光标进度，文件总行数，当前时间
          lualine_z = {{'progress', padding = 0}, {'%L'}, {"os.date('%H:%M')"}}
        },
        -- 不活跃窗口显示光标位置和文件总行数
        inactive_sections = {
          lualine_x = {'location', '%L'},
        },
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
          -- <leader>hs和<leader>hu的所有操作都不会修改当前文件，都是对git暂存区的操作
          -- 保存到暂存区
          ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
          ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>hS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
          -- 撤销上一次添加到暂存区的hunk
          ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
          -- 撤销当前文件添加到暂存区的所有hunk，也就是将当前文件的暂存区内容恢复为版本库内容
          ['n <leader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
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
        diff_opts = {algorithm = "histogram"}
      }
    end
  }

  use{'lukas-reineke/indent-blankline.nvim',
    opt = true,
    event = 'BufRead',
    config = function()
      -- 定义各个缩进标记线的颜色
      vim.cmd[[
        augroup indentBlanklineCharColor
          autocmd ColorScheme * highlight IndentCurrent guifg=#EC7279 guibg=NONE gui=nocombine
          autocmd ColorScheme * highlight IndentTwo guifg=#D08770 guibg=NONE gui=nocombine
          autocmd ColorScheme * highlight IndentThree guifg=#EBCB8B guibg=NONE gui=nocombine
          autocmd ColorScheme * highlight IndentFour guifg=#A3BE8C guibg=NONE gui=nocombine
          autocmd ColorScheme * highlight IndentFive guifg=#5E81AC guibg=NONE gui=nocombine
          autocmd ColorScheme * highlight IndentSix guifg=#88C0D0 guibg=NONE gui=nocombine
          autocmd ColorScheme * highlight IndentSeven guifg=#B48EAD guibg=NONE gui=nocombine
        augroup END
        " 在加载插件之后可能没有发生配色切换，所以手动触发
        doautocmd indentBlanklineCharColor ColorScheme
      ]]
      require("indent_blankline").setup {
        char = "│",
        char_highlight_list = {
          "IndentTwo", "IndentThree", "IndentFour",
          "IndentFive", "IndentSix", "IndentSeven"
        },
        -- 禁用标记线的文件类型
        filetype_exclude = {
          "startify", "dashboard", "dotooagenda", "log", "fugitive",
          "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
          "vista", "help", "todoist", "NvimTree", "peekaboo", "git",
          "TelescopePrompt", "undotree", "flutterToolsOutline", "" -- for all buffers without a file type
        },
        -- 禁用标记线的buffer类型
        buftype_exclude = {"terminal", "nofile"},
        -- 禁用空白行显示标记线(如果空白行真有空格还是会显示)
        show_trailing_blankline_indent = false,
        -- 特殊处理当前所在的层级标记线
        show_current_context = true,
        -- 当前层级标记线变红
        context_highlight_list = {'IndentCurrent'},
        -- 当前层级标记线变粗
        context_char = '┃',
        context_patterns = {
          "class", "function", "method", "block", "list_literal", "selector",
          "^if", "^table", "if_statement", "while", "for", "type", "var", "import"
        }
      }
    end
  }

  use{'folke/zen-mode.nvim',
    opt = true,
    cmd = 'ZenMode',
    config = function() require('zen-mode').setup {} end
  }

  use{'arkav/lualine-lsp-progress',
    opt = true,
    after = 'nvim-gps',
  }

  use{'glepnir/dashboard-nvim',
    opt = true,
    event = "BufWinEnter",
    setup = function()
       vim.g.dashboard_default_executive = 'telescope'
    end,
    config = function()
    end
  }

end
