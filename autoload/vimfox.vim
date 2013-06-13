fu! vimfox#buffer_has_changed()
  let l:prev_num_changes = b:num_changes
  let b:num_changes = eval('changenr()')
  return b:num_changes != l:prev_num_changes
endf


fu! vimfox#dict_to_pydict(dict)
  let idx = 0
  let pydict = "{"
  for [key, val] in items(a:dict)
    let idx += 1
    let pydict .= "'" . key . "':"
    if type(val) == 0
      let pydict .= val 
    else
      let pydict .= "'" . val . "'"
    endif
    if idx == len(a:dict)
      let pydict .= "}"
    else
      let pydict .= ","
    endif
  endfor
  return pydict
endf

fu! vimfox#reload_file(event_data)
  let data = a:event_data
  let data['event'] = 'reload_file'
  exe "py vf.ws_send(" . vimfox#dict_to_pydict(data) . ")"
endf

fu! vimfox#reload_page(event_data)
  let data = a:event_data
  let data['event'] = 'reload_page'
  exe "py vf.ws_send(" . vimfox#dict_to_pydict(data) . ")"
endf
  

fu! vimfox#reload(do_write, force)
  if vimfox#buffer_has_changed() || a:force
    let event_data = vimfox#ft_hook({'fname': b:filename, 'delay': 0}, a:do_write)
    if expand('%:e') == 'html'
      call vimfox#reload_page(event_data)
    else
      call vimfox#reload_file(event_data)
    endif
  endif
endf

fu! vimfox#ft_hook(event_data, do_write)
  let Hook = get(g:vimfox_ft_hooks, b:filetype, 0)
  let event_data = a:event_data
  if type(Hook) == 1
    try
      exe Hook
    catch
      echoe "vimfox error! ft hook failed: \"execute: '" . Hook . "'\""
    endtry
  elseif type(Hook) == 2
    try
      let opts = Hook(a:do_write)
    catch
      try
        let opts = Hook()
      catch
        echom "vimfox error! ft hook failed: FuncRef: '" . string(Hook) . "'."
        let opts = 0
      endtry
    endtry
    if type(opts) == 4
      let event_data.fname = get(opts, 'fname', b:filename)
      let event_data.delay = get(opts, 'delay', 0)
    endif
  endif
  return event_data
endf

fu! vimfox#toggle_vimfox()
  if !exists('b:vimfox_toggle')
    let b:vimfox_toggle = 1
  endif
  if b:vimfox_toggle
    if ! g:vimfox_did_onetime_init
      runtime! vimfox/vimfox.vim
      let g:vimfox_did_onetime_init = 1
    endif
    cal vimfox#enable_vimfox()
    let b:vimfox_toggle = 0
    let toggle_state = 'enabled'
  else
    cal vimfox#disable_vimfox()
    let b:vimfox_toggle = 1
    let toggle_state = 'disabled'
  endif
  if g:vimfox_echo_toggle_state
    echo "vimfox is now " . toggle_state . " for this buffer."
  endif
endf

fu! vimfox#enable_vimfox()
  augroup Vimfox_Autocmds
    let b:filetype = eval('&ft')
    let b:filename = expand('%')
    let b:num_changes = eval('changenr()')
    command! -nargs=* VimfoxReloadBuffer call vimfox#reload(0,1)
    command! -nargs=0 VimfoxReloadPage call vimfox#reload_page({})
    if (index(g:vimfox_reload_insert_leave_filetypes, b:filetype) != -1)
      au InsertLeave <buffer> :sil w|cal vimfox#reload(1, 0)
    elseif (index(g:vimfox_reload_post_write_filetypes, b:filetype) != -1)
      au BufWritePost <buffer> :cal vimfox#reload(0, 0)
    endif
  augroup END
endf

fu! vimfox#disable_vimfox()
  delcommand VimfoxReloadBuffer
  delcommand VimfoxReloadPage
  augroup Vimfox_Autocmds
    au!
  augroup END
endf

fu! vimfox#less_ft_hook(do_write)
  let basename = expand('%:t:r')
  let fname = basename . '.css'
  if a:do_write
    let cwd = expand('<afile>:p:h')
    let name = expand('<afile>:t:r')
    if (executable('lessc'))
      cal system('lessc '.cwd.'/'.name.'.less > '.cwd.'/'.name.'.css &')
    endif
  endif
  return {'fname': fname}
endf

fu! vimfox#coffee_ft_hook(do_write)
  let basename = expand('%':t:r)
  let fname = basename . '.css'
  if a:do_write
    silent CoffeeMake! -b
  endif
  return {'fname': fname}
endf
