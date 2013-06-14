" File:     autoload/vimfox.vim
" Author:   Daan Mathot
" Email:    dydrmntion AT gmail
" Version:  0.6
" Date:     Fri Jun 14 21:28:11 2013

" function vimfox#buffer_has_changed {{{
fu! vimfox#buffer_has_changed()
  let l:prev_num_changes = b:num_changes
  let b:num_changes = eval('changenr()')
  return b:num_changes != l:prev_num_changes
endf
" }}}

" function vimfox#_reload_file {{{
fu! vimfox#_reload_file(force, fname, delay)
  if vimfox#buffer_has_changed() || a:force
    exe "py vf.ws_send(fname='" . a:fname . "', event='reload_file', delay=" . string(a:delay) . ")"
  endif
endf
" }}}

" function vimfox#reload_file {{{
fu! vimfox#reload_file(...)
  let force = 0
  let fname = b:filename
  let delay = 0.0
  if a:0 > 3
    echohl WarningMsg|"vimfox warning! VimfoxReloadFile takes a maximum of 3 optional arguments."
    echohl None
  else
    for param in a:000
      echom type(param)
      if type(param) == 0
        " int is bool = force
        let force = param
      elseif type(param) == 1
        " str = fname
        let fname = param
      elseif type(param) == 5
        " float = delay
        let delay = param
      endif
      unlet param
    endfor
  endif
  cal vimfox#_reload_file(force, fname, delay)
endf
" }}}

" function vimfox#_reload_page {{{
fu! vimfox#_reload_page(force, delay)
  if vimfox#buffer_has_changed() || a:force
    exe "py vf.ws_send(event='reload_page', delay=" . string(a:delay) . ")"
  endif
endf
" }}}

" function vimfox#reload_page {{{
fu! vimfox#reload_page(...)
  let force = 0
  let delay = 0
  if a:0 > 2
    echohl WarningMsg|"vimfox warning! VimfoxReloadPage takes a maximum of 2 optional arguments."
    echohl None
  endif
  for param in a:000
    if type(param) == 0
      let force = param
    elseif type(param) == 5
      let delay = param
    endif
    unlet param
  endfor
  cal vimfox#_reload_page(force, delay)
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
    cal vimfox#toggle_autocommands(1)
endf
" }}}

" function vimfox#disable_vimfox {{{
fu! vimfox#disable_vimfox()
  delcommand VimfoxReloadFile
  delcommand VimfoxReloadPage
  cal vimfox#toggle_autocommands(0)
endf
" }}}

" function vimfox#toggle_autocommands {{{
fu! vimfox#toggle_autocommands(do_enable)
  augroup <buffer> VimfoxAuGroup
    au!
    if a:do_enable
      for aucmd in get(g:vimfox_autocommands, b:filetype, [])
        exe aucmd
      endfor
    endif
  augroup END
endf
" }}}


" vim:foldmethod=marker:sw=2:ts=4
