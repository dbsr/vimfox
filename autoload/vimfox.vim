fu! vimfox#start_server_if_down()
  echom "HALLO"
  if !g:Vimfox_server_up
    echo "JA HALLO"
    exe "py vimfox.start_server()"
  endif
endf
