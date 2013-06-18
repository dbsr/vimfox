" File:         vimfox/vimfox.vim
" Author:       Daan Mathot
" Email:        dydrmntion AT gmail
" Version:      0.2
" Date:         Mon Jun 17 19:31:35 2013 
" Description:  Starts the vimfox server in a subprocess.

let s:vimfox_server_up = 0
python << EOF
def get_vf():
    import sys
    import vim
    _here = vim.eval('expand("<sfile>:h")')
    sys.path.append(_here)
    from vimfox import VimFox
    vf = VimFox(vim.eval('g:vimfox_host'), vim.eval('g:vimfox_port'),
                bool(int(vim.eval("exists('g:vimfox_debug')"))))
    return vf
vf = vars()['vf'] if vars().get('vf') else get_vf()
if not vf.server_is_up():
    vf.start_server()
EOF

au VimLeave * :exe "py vf.kill_server()"
