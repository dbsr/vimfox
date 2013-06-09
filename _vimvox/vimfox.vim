" File:     vimfox.vim
" Author:   daanmathot@gmail.com
" Date:     Sun Jun  9 13:50:46 CEST 2013
" Version:  0.1

" Options {{{
if exists("g:vimfox_did_vim")
    finish
endif

if !exists("g:Vimfox_host")
    let g:Vimfox_host = ""
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
import vimfox

vimfox.start_server(vim.eval('g:Vimfox_host . ", " . g:Vimfox_port'))
EOF
" }}}

" Functions / commands. {{{
function! s:CheckBuffer()
    python "vimfox.check_buffer()"
endfunction
command!        -nargs=0 VimfoxCheckBuffer        call s:CheckBuffer()
" }}}

" Autocommands. {{{
if g:Vimfox_au_check
    au! CursorMoved,InsertLeave * :call s:CheckBuffer()
endif
" }}}

" vim:foldmethod=marker:
