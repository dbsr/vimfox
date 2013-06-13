fu! vimfox#init_buffer()
  let b:filetype = eval('&ft')
  let b:filename = expand('%')
  let l:filename_base = expand('%:r')
  if b:filetype == 'coffee'
    let b:filename = l:filename_base . '.js'
  elseif b:filetype == 'less'
    let b:filename = l:filename_base . '.css'
  endif
  let b:num_changes = eval('changenr()')
endf

fu! vimfox#buffer_has_changed()
  let l:prev_num_changes = b:num_changes
  let b:num_changes = eval('changenr()')
  return b:num_changes != l:prev_num_changes
endf!


fu! vimfox#create_reload_request_json()
  if b:filetype == 'html'
    let event = 'reload_page'
  else
    let event = 'reload_file'
  endif
  return "{'fname': '" . b:filename . "', 'event': '" . event . "'}"
endf

fu! vimfox#auto_reload_buffer(force)
  if vimfox#buffer_has_changed() || a:force
    if b:filetype == 'coffee'
      exe "w|silent! CoffeeMake! -b"
    elseif b:filetype == 'less'
      exe "w|call vimfox#less_css_compress()"
    else
      exe "w"
    endif
    exe "py vf.ws_send(" . vimfox#create_reload_request_json() . ")"
  endif
endf

fu! vimfox#reload_buffer(force)
  if vimfox#buffer_has_changed() || a:force
    exe "py vf.ws_send(" . vimfox#create_reload_request_json() . ")"
  endif
endf

fu! vimfox#toggle_vimfox()
  if !exists('b:vimfox_toggle')
    let b:vimfox_toggle = 1
  endif
  if b:vimfox_toggle
    call vimfox#init_buffer()
    if ! g:vimfox_did_onetime_init
      runtime! vimfox/vimfox.vim
      let g:vimfox_did_onetime_init = 1
    endif
    call vimfox#enable_vimfox()
    let b:vimfox_toggle = 0
    let toggle_state = 'enabled'
  else
    call vimfox#disable_vimfox()
    let b:vimfox_toggle = 1
    let toggle_state = 'disabled'
  endif
  if g:vimfox_echo_toggle_state
    echo "vimfox is now " . toggle_state . " for this buffer."
  endif
endf

fu! vimfox#enable_vimfox()
if (index(g:vimfox_reload_auto_filetypes, b:filetype) != -1)
  augroup vimfox
    au CursorHold,InsertLeave <buffer> :call vimfox#auto_reload_buffer(0)
  augroup END
elseif (index(g:vimfox_reload_write_filetypes, b:filetype) != -1)
  augroup vimfox
    au BufWritePost <buffer> :call vimfox#reload_buffer(0)
  augroup END
endif
endf

fu! vimfox#disable_vimfox()
  augroup vimfox
    au!
  augroup END
endf

fu! vimfox#less_css_compress()
  let cwd = expand('<afile>:p:h')
  let name = expand('<afile>:t:r')
  if (executable('lessc'))
    cal system('lessc '.cwd.'/'.name.'.less > '.cwd.'/'.name.'.css &')
  endif
endf
