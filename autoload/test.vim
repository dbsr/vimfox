let g:vimfox_autocmds = {}

let g:vimfox_autocmds['less'] = [
                            \ "au BufWritePost <buffer> :call b:LessCssCompress()|
                              \ VimfoxReloadFile . expand(\"%:r\") . \".css\""
                            \]



let g:str = '"au BufWritePost <buffer> :let g:kiks = " . expand("%:r") . "css"'

exe g:str
