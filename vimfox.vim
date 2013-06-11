" File:     vimfox.vim
" Author:   daanmathot@gmail.com
" Date:     Sun Jun  9 13:50:46 CEST 2013
" Version:  0.1
if exists("g:vimfox_did_vim")
    finish
endif
let g:vimfox_div_vim = 1

" Options {{{

if !exists("g:Vimfox_host")
    let g:Vimfox_host = "127.0.0.1"
endif

if !exists("g:Vimfox_port")
    let g:Vimfox_port = 9000
endif

" auto reload active for which fts?
if !exists("g:Vimfox_reload_auto_fts")
    let g:Vimfox_reload_auto_fts = ["less", "css"]
endif

" max auto reloads per second?
if !exists("g:Vimfox_max_reload_interval") 
    let g:Vimfox_max_reload_interval = 1.0
endif

" reload buffer post write for which fts?
if !exists("g:Vimfox_reload_write_fts")
    let g:Vimfox_reload_write_fts = ["coffee", "js", "html"]
endif
" }}}

" Server / Import vimfox. {{{
python << EOF
import sys
import vim
cur_dir = vim.eval('expand("<sfile>:h")')
my_paths = [cur_dir, os.path.join(cur_dir, 'lib')] 
sys.path.extend(my_paths)

from vimfox._vimfox import start_server, check_buffer, reload_buffer

start_server()
EOF
" }}}

" Functions / Commands. {{{
function! s:CheckBuffer()
    " make sure we're not checking a plugin buffer (like ctrlP)
    if &buftype == ""
        exe "python check_buffer()"
    endif
endfunction

function! s:ReloadBuffer()
    if &buftype == ""
        exe "python reload_buffer"
    endif
endfunction

function! b:LessCSSCompress()
  let cwd = expand('<afile>:p:h')
  let name = expand('<afile>:t:r')
  if (executable('lessc'))
    cal system('lessc '.cwd.'/'.name.'.less > '.cwd.'/'.name.'.css &')
  endif
endfunction

command! -nargs=0 VimfoxCheckBuffer call s:CheckBuffer()

command! -nargs=0 VimfoxReloadBuffer call s:ReloadBuffer()
" }}}

" Autocommands. {{{
exe "au CursorMoved,InsertLeave *." . join(g:Vimfox_reload_auto_fts, ',*.') . " :call s:CheckBuffer()"
exe "au BufWritePost *." . join(g:Vimfox_reload_write_fts, ',*.') . " :call s:ReloadBuffer()"
" }}}

" vim:foldmethod=marker:
