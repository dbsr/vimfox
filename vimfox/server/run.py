# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013
import sys
import os

_here = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(_here, 'ext'))

from socketio.server import SocketIOServer
from gevent import monkey

monkey.patch_all()

from server import app


def start_server(host_address):
    try:
        server = SocketIOServer(host_address, app, resource='socket.io')
        server.serve_forever()
    except:
        # assume for now server is already running
        pass


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--host")
    parser.add_argument("--port", type=int)
    parser.add_argument("--debug", type=int)
    parser.add_argument("--hide-status", type=int)
    args = parser.parse_args()
    host_address = (args.host, args.port)
    app.debug = bool(args.debug)
    print args.debug
    if not args.debug:
        import logging
        app.logger.propagate = False
        app.logger.setLevel(logging.ERROR)
        print app.logger_name
        print app.debug

    app.vimfox['hide_status'] = args.hide_status

    start_server(host_address)
