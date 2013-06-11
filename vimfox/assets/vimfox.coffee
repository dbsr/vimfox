### vimfox.js ~ initiates websocket / reload script ###
window.onload = ->
  console.log "vimfox.js onload script initiating"
  # retrieve vimfox host address
  for script in document.getElementsByTagName('script')
    if script.src.match('vimfox.js')
      vimfoxHost = script.src.replace('/vimfox/vimfox.js', '')
      console.log "vimfox host  => #{vimfoxHost}"

  # add the socket.io library
  unless io?
    console.log "injecting socket.io.min.js"
    injectJS(vimfoxHost + "/vimfox/socket.io.min.js", ->
      initSocketIO(vimfoxHost)
    )

initSocketIO = (hostAddress) ->
  socket = io.connect("#{hostAddress}/ws")
  # broadcast we're ready for new events
  socket.emit('ready')

  # reload file listener
  socket.on('reload_file', (data) ->
    console.log "received reload_file event."
    socket.emit('busy')
    for e, idx in document.getElementsByTagName(data.element)
      if e[data.tag].match(data.target_file)
        if data.element == 'script'
          src = e.src.replace(/\?[0-9]+$/, '') + "?#{+new Date}"
          # First remove the original script
          e.parentNode.removeChild(e)
          # And inject it back in
          injectJS(src, ->
            socket.emit('ready')
          )
        else
          # Add timestamp to href to force browser reload
          v = e[data.tag].replace(/\?[0-9]+$/, '') + "?#{+new Date}"
          e[data.tag] = v
          socket.emit('ready')
  )

  # reload page listener
  socket.on('reload_page', (data) ->
    console.log "received reload page event"
    socket.emit('busy')
    location.reload(if data.force_get then true else false)
  )

injectJS = (src, callback=null) ->
  s = document.createElement('script')
  s.type = 'text/javascript'
  s.async = true
  s.onload = ->
    if callback?
      callback()
  s.src = src
  document.body.appendChild(s)
