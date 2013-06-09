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
    def request_reload(self, target_file):
        for ws in self.sockets.values():
            ws.emit('reload', target_file)


@app.route('/socket.io/<path:remaining>')
def socketio(remaining):
    try:
        socketio_manage(request.environ, {'/ws': VimFoxNamespace}, request)
    except:
        app.logger.error("Socket Error.", exc_info=True)

    return Response()


@app.route('/do_reload', methods=['GET'])
def reload():
    target_file = request.args.get('target_file')
    VimFoxNamespace.request_reload(target_file)
    return Response('OK', 200)
