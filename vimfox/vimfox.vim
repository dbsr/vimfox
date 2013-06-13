" File:     vimfox/vimfox.vim
" Author:   Daan Mathot
" Email:    dydrmntion AT gmail
" Version:  0.1
" Date:     Thu Jun 13 19:23:33 2013

python << EOF
import sys
import vim
_here = vim.eval('expand("<sfile>:h")')
sys.path.append(_here)
from vimfox import VimFox
vf = VimFox(vim.eval('g:vimfox_host'), vim.eval('g:vimfox_port'),
            bool(int(vim.eval("exists('g:vimfox_debug')"))))
vf.start_server()
EOF

au VimLeave * :exe "py vf.kill_server()"
