# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from socketio.server import SocketIOServer
from gevent import monkey
monkey.patch_all()

from server import app


def _run_server(host_address):
    try:
        SocketIOServer(host_address, app, resource='socket.io').serve_forever()
    except:
        pass

if __name__ == '__main__':
    try:
        host_address = tuple([x.strip() for x in sys.argv[1:3]])
    except (ValueError, IndexError):
        host_address = ("", 9000)

    _run_server(host_address)
