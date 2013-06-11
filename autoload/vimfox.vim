fu! vimfox#start_server_if_down()
  if !g:Vimfox_server_up
    exe "py vimfox.start_server()"
  endif
endf
