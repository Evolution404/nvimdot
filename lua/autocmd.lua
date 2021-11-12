vim.cmd[[
  augroup buf
    autocmd!
    " 打开文件时自动恢复到上次位置
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  augroup END

  augroup wins
    autocmd!
    " 只有正在活动的窗口才高亮当前行
    autocmd WinEnter,BufEnter,InsertLeave * if &filetype !~# '^\(dashboard\|clap_\)' | setlocal cursorline | endif
    autocmd WinLeave,BufLeave,InsertEnter * if &filetype !~# '^\(dashboard\|clap_\)' | setlocal nocursorline | endif
    autocmd FocusGained * checktime
    autocmd VimResized * tabdo wincmd =
  augroup END

  augroup yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})
  augroup END

  augroup filetype
    autocmd!
  augroup END
]]
