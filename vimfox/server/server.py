# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import time

from socketio import socketio_manage
from socketio.namespace import BaseNamespace
from flask import Flask, send_file, Response, request, render_template

app = Flask(__name__)
app.vimfox = {
    'ready': 0
}


@app.route('/vimfox/<path:filename>')
def send_vimfox_file(filename):
    app.logger.info(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'assets', filename))
    try:
        return send_file(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'assets', filename))
    except:
        return Response(':(', status=404)


class VimFoxNamespace(BaseNamespace):
    sockets = {}

    def initialize(self):
        self.logger = app.logger
        self.log('socket initialized')
        self.sockets[id(self)] = self

        return True

    def log(self, msg):
        self.logger.info("[{0}] {1}".format(self.socket.sessid, msg))

    def disconnect(self, *args, **kwargs):
        self.log("connection lost")
        if id(self) in self.sockets:
            del self.sockets[id(self)]
        app.vimfox['ready'] = True

    def on_busy(self):
        self.log("processing event request.")
        app.vimfox['ready'] = time.time()

    def on_ready(self):
        self.log("ready for new event requests.")
        app.vimfox['ready'] = True

    @classmethod
    def socketio_send(self, data):
        event = data['event']
        del data['event']
        app.logger.info("event emit request: {0!r}.".format(repr(data)))
        for ws in self.sockets.values():
            ws.emit(event, data)


@app.route('/socket.io/<path:remaining>')
def socketio(remaining):
    try:
        socketio_manage(request.environ, {'/ws': VimFoxNamespace}, request)
    except:
        app.logger.error("Socket Error.", exc_info=True)

    return Response()


@app.route('/socket', methods=['POST'])
def reload():
    if app.vimfox['ready'] or time.time() - app.vimfox['ready'] > 5:
        VimFoxNamespace.socketio_send(dict(request.json))

        return Response('OK', 200)
    else:

        return Response('zZz', 503)


@app.route('/get-server-pid')
def get_server_pid():
    return Response(str(os.getpid()), 200)


@app.route('/debug')
def debug():
    return render_template("""
            {% block lol %}
            <!DOCTYPE html>
        <html>
        <head>
            <title></title>
            <meta charset="utf-8" />
            <link rel="stylesheet" href="/assets/css/style2.css">
        </head>
        <body>
            <script rel="text/javascript" src="/vimfox/vimfox.js"></script>
        </body>
        </html>""")
