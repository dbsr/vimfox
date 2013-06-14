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
    fname = data.fname
    console.log "received reload_file event."
    socket.emit('busy')
    console.log data
    setTimeout (->
      if fname.match(/\.css/)
        element = 'link'
        tag = 'href'
      else
        element = 'script'
        tag = 'src'
      for e, idx in document.getElementsByTagName(element)
        if e[tag].match(fname)
          if element == 'script'
            src = e.src.replace(/\?[0-9]+$/, '') + "?#{+new Date}"
            # First remove the original script
            e.parentNode.removeChild(e)
            # And inject it back in
            injectJS(src, ->
              socket.emit('ready')
            )
          else
            # Add timestamp to href to force browser reload
            v = e[tag].replace(/\?[0-9]+$/, '') + "?#{+new Date}"
            e[tag] = v
            socket.emit('ready')
    ),  data.delay * 1000
  )

  # reload page listener
  socket.on('reload_page', ->
    console.log "received reload page event"
    socket.emit('busy')
    location.reload()
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
