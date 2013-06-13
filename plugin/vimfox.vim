" File:     plugin/vimfox.vim
" Author:   Daan Mathot
" Email:    dydrmntion AT gmail
" Version:  0.2
" Date:     Thu Jun 13 19:22:50 2013

" vimfox global vars {{{
let g:vimfox_did_onetime_init = 0
" }}}

" options {{{
if !exists("g:vimfox_host")
  let g:vimfox_host = "127.0.0.1"
endif

if !exists("g:vimfox_port")
  let g:vimfox_port = 9000
endif

if !exists("g:vimfox_reload_insert_leave_filetypes")
  let g:vimfox_reload_insert_leave_filetypes = ["less", "css"]
endif

if !exists("g:vimfox_reload_post_write_filetypes")
  let g:vimfox_reload_post_write_filetypes = ["coffee", "js", "html", "jinja"]
endif

if !exists("g:vimfox_echo_toggle_state")
  let g:vimfox_echo_toggle_state = 1
endif
" }}}


" ft hooks {{{
let g:vimfox_ft_hooks = {
      \ 'less': function('vimfox#less_ft_hook'), 
      \ 'coffee': function('vimfox#coffee_ft_hook')
      \}
if exists('g:vimfox_user_ft_hooks')
  if type(g:vimfox_user_ft_hooks) != 4
    echoe "g:vimfox_user_ft_hooks is not a dictionary. Skipping."
  else
    for [ft, Hook] in items(g:vimfox_user_ft_hooks)
      try
        let g:vimfox_ft_hooks[ft] = Hook
      catch
        echoe "vimfox error! could not assign hook " . string(Hook) . " to ft: " . string(ft) . "."
      endtry
    endfor
  endif
endif
" }}}

" commands {{{
command! -nargs=0 VimfoxToggle call vimfox#toggle_vimfox()
" }}}

" vim:foldmethod=marker:sw=2:ts=4
