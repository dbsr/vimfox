" File:     vimfox.vim
" Author:   daanmathot@gmail.com
" Date:     Thu Jun 13 01:24:00 CEST 2013
" Version:  0.1

" vimfox global vars {{{
let g:vimfox_did_onetime_init = 0
" }}}

" Options {{{
if !exists("g:vimfox_host")
  echo 1
  let g:vimfox_host = "127.0.0.1"
endif

if !exists("g:vimfox_port")
  let g:vimfox_port = 9000
endif

if !exists("g:vimfox_reload_auto_filetypes")
  let g:vimfox_reload_auto_filetypes = ["less", "css"]
endif

if !exists("g:vimfox_reload_write_filetypes")
  let g:vimfox_reload_write_filetypes = ["coffee", "js", "html", "jinja"]
endif

if !exists("g:vimfox_echo_toggle_state")
  let g:vimfox_echo_toggle_state = 1
endif
" }}}

fu! g:VimfoxDebug()
  call vimfox#init_buffer()
  runtime! vimfox/vimfox.vim
  call vimfox#reload_buffer(1)
endf

command! -nargs=0 VimfoxToggle call vimfox#toggle_vimfox()
