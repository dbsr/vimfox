" File:     vimfox.vim
" Author:   daanmathot@gmail.com
" Date:     Sun Jun  9 13:50:46 CEST 2013
" Version:  0.1

" vimfox vars {{{
let g:Vimfox_server_up = 0
let g:Vimfox_toggle_auto_reload = 1
" }}}

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

" reload buffer post write for which fts?
if !exists("g:Vimfox_reload_write_fts")
  let g:Vimfox_reload_write_fts = ["coffee", "js", "html", "jinja"]
endif
" }}}

" Server / Import vimfox. {{{
python << EOF
import sys
import vim
_here = vim.eval('expand("<sfile>:h")')
sys.path.append(_here)
import vimfox
EOF
" }}}

" functions / Commands. {{{
fu! s:CheckBuffer()
  if &buftype == "" && g:Vimfox_toggle_auto_reload > 0
    exe "python vimfox.auto_check_buffer()"
  endif
endf

fu! s:ReloadBuffer()
  if &buftype == "" && g:Vimfox_toggle_auto_reload > 0
    exe "python vimfox.create_reload_event(False)"
  endif
endf

fu! s:VimfoxToggleAutoReload()
  let g:Vimfox_toggle_auto_reload = (g:Vimfox_toggle_auto_reload * -1)
endf

fu! b:LessCSSCompress()
  let cwd = expand('<afile>:p:h')
  let name = expand('<afile>:t:r')
  if (executable('lessc'))
    cal system('lessc '.cwd.'/'.name.'.less > '.cwd.'/'.name.'.css &')
  endif
endf

fu! s:StartIfTarget()
    let fts = g:Vimfox_reload_auto_fts + g:Vimfox_reload_write_fts
    if index(fts, eval('&ft')) != -1 || index(fts, expand('%:e')) != -1
        vimfox#start_server_if_down()
    endif
endf

command! -nargs=0 VimfoxCheckBuffer call s:CheckBuffer()

command! -nargs=0 VimfoxToggleAutoReload call s:VimfoxToggleAutoReload()

command! -nargs=0 VimfoxReloadBuffer call s:ReloadBuffer()
" }}}

" Autocommands. {{{
exe "au! CursorHold,InsertLeave *." . join(g:Vimfox_reload_auto_fts, ',*.') . " :call s:CheckBuffer()"
exe "au! BufWritePost *." . join(g:Vimfox_reload_write_fts, ',*.') . " :call s:ReloadBuffer()"
au! BufRead,BufNewFile,FileReadPost call s:StartIfTarget()
" }}
" vim:foldmethod=marker:



