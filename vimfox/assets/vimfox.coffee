### vimfox.js ~ initiates websocket / reload script ###
window.onload = ->
  # retrieve vimfox host address
  for script in document.getElementsByTagName('script')
    if script.src.match('vimfox.js')
      vimfoxHost = script.src.replace('/vimfox/vimfox.js', '')

  # add the socket.io library
  unless io?
    s = document.createElement('script')
    s.type = 'text/javascript'
    s.async = true
    s.onload = ->
      initWebSocket(vimfoxHost)
    s.src = vimfoxHost + "/vimfox/socket.io.js"
    document.body.appendChild(s)

initWebSocket = (host) ->
  socket = io.connect(host + "/ws")

  # listen for reload command
  socket.on('reload', (target_file) ->
    for css in document.getElementsByTagName('link')
      if css.href.match(target_file)
        new_href = css.href.replace(/\?[0-9]+$/, '') + "?#{+new Date}"
        css.href = new_href
  )
