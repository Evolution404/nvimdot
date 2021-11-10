vim.cmd[[
  augroup buf
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
  augroup END

  augroup wins
    autocmd!
    autocmd WinEnter,BufEnter,InsertLeave * if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif
    autocmd WinLeave,BufLeave,InsertEnter * if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif
    autocmd VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif
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
