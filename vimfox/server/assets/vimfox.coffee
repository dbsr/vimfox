### vimfox.js ~ initiates websocket / reload script ###
namespace = (target, name, block) ->
  [target, name, block] = [(if typeof exports isnt 'undefined' then exports else window), arguments...] if arguments.length < 3
  top    = target
  target = target[item] or= {} for item in name.split '.'
  block target, top

window.onload = ->
  vimfox.initVimfox()

namespace 'vimfox', (exports) ->
  exports._initLog = []
  exports.log = (m) ->
    if not vimfox.settings?
      vimfox._initLog.push(m)
    else if vimfox.settings.debug_mode
      console.log("vimfox_debug >> #{m}")

  exports.initVimfox = ->
    vimfox.log("Initiating vimfox.js.")
    vimfox.status = new vimfox.Status()

    for script in document.getElementsByTagName('script')
      if script.src.match('vimfox.js')
        exports.HOST = script.src.replace('/vimfox/vimfox.js', '')
        vimfox.log("Retrieved vimfox server HOST: #{vimfox.HOST}.")
        break

    if io?
      vimfox.log("'io' found in namespace. Skipping js injection.")
      vimfox.createSockets()
    else
      vimfox.log("'io' not found in namespace. Injecting 'socket.io.js'.")
      document.body.appendChild(
        vimfox.injectJS("#{vimfox.HOST}/vimfox/socket.io.min.js", ->
          vimfox.createSockets()
        )
      )

    vimfox.cssFiles = {}
    vimfox.log("Searching for reloadable stylesheets.")
    for link in document.getElementsByTagName('link')
      vimfox.cssFiles[link.href.match(/[^/]+$/)[0]] =
        link: link,
        reload: (delay=0) ->
          setTimeout (=>
            @link.href = @link.href.replace(/\?[0-9]+$/, "") + "?#{+new Date}"
          ), delay * 1000

  exports.createSockets = ->
    vimfox.log("Connecting to vimfox socket server.")
    # Create the websocket
    socket = io.connect("#{vimfox.HOST}/ws")
    # on error socket
    socket.on('error', (e) ->
      vimfox.log("Connection error!")
      vimfox.status.update_status(2)
    )
    # on d/c socket
    socket.on('disconnect', ->
      vimfox.log("Connection lost!")
      vimfox.status.update_status(2)
    )
    # settings socket
    vimfox.log("Requesting vimfox settings.")
    socket.emit("settings")
    socket.on("settings", (data) ->
      vimfox.log("Connected. Parsing settings.")
      vimfox.status.update_status(0)
      vimfox.settings =
        debug_mode: data.debug_mode,
        hide_status: data.hide_status
      if vimfox.settings.hide_status then vimfox.status.kill_me()
      if vimfox.settings.debug_mode == true
        for m in vimfox._initLog
          vimfox.log(m)
    )

    # reload stylesheet socket
    socket.on('reload_file', (data) ->
      vimfox.log("'reload_file' socket activated: file: #{data.fname}.")
      socket.emit("busy")
      if not vimfox.cssFiles[data.fname]
        vimfox.status.update_status(1, "could not find #{data.fname} in DOM.")
      else
        vimfox.cssFiles[data.fname].reload(data.delay)
      socket.emit("ready")
    )

    # reload page socket
    socket.on('reload_page', (data) ->
      vimfox.log("'reload_page' socket activated.")
      setTimeout (->
        location.reload()
      ), data.delay * 1000
    )

  exports.injectJS = (src, onload) ->
    s = document.createElement('script')
    s.type = 'text/javascript'
    s.onload = onload
    s.src = src
    return s


  class exports.Status
    constructor: ->
      d = document.createElement('div')
      d.id = "vimfox_status"
      document.body.appendChild(d)
      @me = document.getElementById('vimfox_status')
      @update_status(1)

    update_status: (status_code=0, tooltip="") ->
      status_color = [
        'green', 'orange', 'red'
      ][status_code]
      for k, v of {
          position: 'absolute',
          height: '10px',
          width: '10px',
          margin: '10px',
          top: '0',
          right: '0',
          backgroundColor: status_color}
        @me.style[k] = v

      @me.title = tooltip

    kill_me: ->
      document.body.removeChild(@me)
