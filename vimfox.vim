" File:     vimfox.vim
" Author:   daanmathot@gmail.com
" Date:     Sun Jun  9 13:50:46 CEST 2013
" Version:  0.1

" Options {{{
if exists("g:vimfox_did_vim")
    finish
endif

if !exists("g:Vimfox_host")
    let g:Vimfox_host = "127.0.0.1"
endif

if !exists("g:Vimfox_port")
    let g:Vimfox_port = 9000
endif

if !exists("g:Vimfox_au_check")
    let g:Vimfox_au_check = 1
endif
" }}}

" Server / Import vimfox. {{{
python << EOF
import sys
import vim
new_path = vim.eval('expand("<sfile>:h")')
sys.path.append(new_path)
from vimfox._vimfox import start_server, check_buffer

start_server(*vim.eval('g:Vimfox_host . ", " . g:Vimfox_port').split(','))
EOF
" }}}

" Functions / Commands. {{{
function! s:CheckBuffer()
    " make sure we're not checking a plugin buffer (like ctrlP)
    if &buftype == ""
        exe "python check_buffer()"
    endif
endfunction
command! -nargs=0 VimfoxCheckBuffer call s:CheckBuffer()
" }}}

" Autocommands. {{{
if g:Vimfox_au_check
    au! CursorMoved,InsertLeave * :call s:CheckBuffer()
endif
" }}}

" vim:foldmethod=marker:
