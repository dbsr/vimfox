" File:     plugin/vimfox.vim
" Author:   Daan Mathot
" Email:    dydrmntion AT gmail
" Version:  0.2
" Date:     Thu Jun 13 19:22:50 2013

" vimfox global vars {{{
let g:vimfox_did_onetime_init = 0
let g:vimfox_debug = 1
" }}}

" options {{{
if !exists("g:vimfox_host")
  let g:vimfox_host = "127.0.0.1"
endif

if !exists("g:vimfox_port")
  let g:vimfox_port = 9000
endif

if !exists("g:vimfox_echo_toggle_state")
  let g:vimfox_echo_toggle_state = 1
endif

if !exists("g:vimfox_debug")
  let g:vimfox_debug = 0
endif

if !exists("g:vimfox_hide_status")
  let g:vimfox_hide_status = 0
endif
" }}}

" commands {{{
command! -nargs=0 VimfoxToggle call vimfox#toggle_vimfox()
" }}}

" vim:foldmethod=marker:sw=2:ts=4
