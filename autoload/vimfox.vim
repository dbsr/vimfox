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

" function vimfox#_reload_buffer {{{
fu! vimfox#_reload_buffer(opts)
  let force = get(a:opts, 'force', 0)
  let fname = get(a:opts, 'fname', b:filename)
  let event = "reload_file"
  if vimfox#buffer_has_changed() || force
    exe "py vimfox.ws_event(fname='" . fname . "', event='" . event . "')"
  endif
endf
" }}}

" function vimfox#reload_buffer {{{
fu! vimfox#reload_buffer(...)
  " takes two optional positional arguments
  " a1 = force reload
  " a2 = filename
  let opts = {}
  if a:0 > 0
    let opts['force'] = a:1
  endif
  if a:0 > 1
    let opts['fname'] = a:2
  endif
  call vimfox#_reload_buffer(opts)
endf
" }}}

" function vimfox#_reload_page {{{
fu! vimfox#_reload_page(opts)
  let force = get(a:opts, 'force', 0)
  if vimfox#buffer_has_changed || force
    exe "py vimfox.ws_event(event='reload_page')"
  endif
endf
" }}}

" function vimfox#reload_page {{{
fu! vimfox#reload_page(...)
  " takes one optional argument
  " a:1 = force reload
  let opts = {}
  if a:0 > 0
    let opts['force'] = a:1
  endif
  call vimfox#_reload_page(opts)
endf
" }}}

" function vimfox#toggle_vimfox {{{
fu! vimfox#toggle_vimfox()
  " enables / disables vimfox for the current buffer
  " and starts the server if its not up
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
" }}}

" function vimfox#enable_vimfox {{{
fu! vimfox#enable_vimfox()
    let b:filetype = eval('&ft')
    let b:filename = expand('%')
    let b:num_changes = eval('changenr()')
    command! -nargs=* VimfoxReloadBuffer call vimfox#reload_buffer() <args>
    command! -nargs=0 VimfoxReloadPage call vimfox#reload_page() <args>
endf
" }}}

" function vimfox#disable_vimfox {{{
fu! vimfox#disable_vimfox()
  delcommand VimfoxReloadBuffer
  delcommand VimfoxReloadPage
endf
" }}}

" vim:foldmethod=marker:sw=2:ts=4
