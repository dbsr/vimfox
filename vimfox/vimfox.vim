python << EOF
import sys
import vim
_here = vim.eval('expand("<sfile>:h")')
sys.path.append(_here)
from vimfox import VimFox
vf = VimFox(vim.eval('g:vimfox_host'), vim.eval('g:vimfox_port'))
vf.start_server()
EOF

au VimLeave * :exe "py vf.kill_server()"
