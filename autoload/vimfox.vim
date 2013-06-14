" File:     autoload/vimfox.vim
" Author:   Daan Mathot
" Email:    dydrmntion AT gmail
" Version:  0.5
" Date:     Thu Jun 13 19:22:40 2013

" function vimfox#buffer_has_changed {{{
fu! vimfox#buffer_has_changed()
  let l:prev_num_changes = b:num_changes
  let b:num_changes = eval('changenr()')
  return b:num_changes != l:prev_num_changes
endf
" }}}

" function vimfox#_reload_file {{{
fu! vimfox#_reload_file(force, fname)
  if vimfox#buffer_has_changed() || a:force
    exe "py vf.ws_send(fname='" . a:fname . "', event='reload_file')"
  endif
endf
" }}}

" function vimfox#reload_file {{{
fu! vimfox#reload_file(...)
  let force = 0
  let fname = b:filename
  if a:0 > 2
    echohl WarningMsg|"vimfox warning! VimfoxReloadFile takes a maximum of 2 optional arguments."
    echohl None
  else
    for arg in a:000
      if type(arg) == 0
        let force = arg
      elseif type(arg) == 1
        let fname = arg
      endif
    endfor
  endif
  cal vimfox#_reload_file(force, fname)
endf
" }}}

" function vimfox#_reload_page {{{
fu! vimfox#_reload_page(force)
  if vimfox#buffer_has_changed() || a:force
    py vf.ws_send(event='reload_page')
  endif
endf
" }}}

" function vimfox#reload_page {{{
fu! vimfox#reload_page(...)
  let force = 0
  if a:0 > 0
    let force = a:1
  endif
  cal vimfox#_reload_page(force)
endf
" }}}

" function vimfox#toggle_vimfox {{{
fu! vimfox#toggle_vimfox()
  if !exists('b:vimfox_toggle')
    let b:vimfox_toggle = 1
    if ! g:vimfox_did_onetime_init
      runtime! vimfox/vimfox.vim
      let g:vimfox_did_onetime_init = 1
    endif
    cal vimfox#enable_vimfox()
    let b:vimfox_toggle = 0
    let toggle_state = 'enabled'
  else
    unlet b:vimfox_toggle
    cal vimfox#disable_vimfox()
    let b:vimfox_toggle = 1
    let toggle_state = 'disabled'
  endif
  if g:vimfox_echo_toggle_state
    echo "vimfox is now " . toggle_state . " for this buffer."
  endif
endf
" }}}

" function vimfox#enable_vimfox {{{
fu! vimfox#enable_vimfox()
    let b:filetype = eval('&ft')
    let b:filename = expand('%')
    let b:num_changes = eval('changenr()')
    command! -nargs=* VimfoxReloadFile cal vimfox#reload_file(<args>)
    command! -nargs=* VimfoxReloadPage cal vimfox#reload_page(<args>)
endf
" }}}

fu! vimfox#is_enabled()
  return exists('b:vimfox_toggle')
endf

" function vimfox#disable_vimfox {{{
fu! vimfox#disable_vimfox()
  delcommand VimfoxReloadFile
  delcommand VimfoxReloadPage
endf
" }}}

" vim:foldmethod=marker:sw=2:ts=4
