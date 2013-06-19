" File:         vimfox/vimfox_server.vim
" Author:       Daan Mathot
" Email:        dydrmntion AT gmail
" Version:      0.1
" Date:         Mon Jun 17 20:58:00 2013
" Description:  gets / sets vimfox server instance

python << EOF
def get_vf():
    import sys
    import vim
    _here = vim.eval('expand("<sfile>:h")')
    sys.path.append(_here)
    from vimfox import VimFox
    vf = VimFox(vim.eval('g:vimfox_host'), vim.eval('g:vimfox_port'),
                vim.eval("g:vimfox_debug"), vim.eval('g:vimfox_hide_status'))
    vim.command("exe 'au VimLeave * :exe \"py vf.kill_server()\"'")
    return vf

vf = vars()['vf'] if vars().get('vf') else get_vf()
EOF
