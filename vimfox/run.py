# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013
import sys
import os
_here = os.path.dirname(os.path.abspath(__file__))
sys.path.extend([
    _here,
    os.path.join(_here, '../lib')
])

from socketio.server import SocketIOServer
from gevent import monkey
monkey.patch_all()

from server import app


def _run_server(host_address):
    try:
        SocketIOServer(host_address, app, resource='socket.io').serve_forever()
    except:
        # Server is already up.
        pass

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--host")
    parser.add_argument("--port", type=int)
    args = vars(parser.parse_args())
    host_address = (args['host'], args['port'])
    _run_server(host_address)
