# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

from socketio import socketio_manage
from socketio.namespace import BaseNamespace

from flask import Flask, send_file, Response, request
import os


app = Flask(__name__)
app.debug = True
_here = os.path.dirname(os.path.abspath(__file__))


@app.route('/vimfox/<path:filename>')
def send_vimfox_file(filename):
    try:
        return send_file(os.path.join(_here, 'assets', filename))
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

    @classmethod
    def socketio_send(self, event, data):
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
    event = request.json['event']
    data = request.json['data']
    VimFoxNamespace.socketio_send(event, data)
    return Response('OK', 200)
