# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import sys
import os
from errno import EADDRINUSE

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from socketio.server import SocketIOServer
from gevent import monkey

from server import app

monkey.patch_all()


def _run_server():
    try:
        SocketIOServer(('', 9000), app, resource='socket.io').serve_forever()
    except EADDRINUSE:
        sys.stderr.write('using old socketserver.')

if __name__ == '__main__':
    _run_server()
