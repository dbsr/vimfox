# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import time

from socketio import socketio_manage
from socketio.namespace import BaseNamespace
from flask import Flask, send_file, Response, request

app = Flask(__name__)
app.debug = True
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
    def socketio_send(self, event, fname):
        app.logger.info("event emit request: {0!r}.\n{1}.".format(event, repr(fname)))
        for ws in self.sockets.values():
            ws.emit(event, fname)


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
        event = request.json['event']
        fname = request.json.get('fname')
        VimFoxNamespace.socketio_send(event, fname)

        return Response('OK', 200)
    else:

        return Response('zZz', 503)


@app.route('/debug')
def debug():
    return Response("""
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
        </html>""", status=200)
