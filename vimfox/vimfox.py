# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import subprocess
import urllib2
import json


RUN_SERVER_PY = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'server', 'run.py')


class VimFox(object):

    server_prc = None

    def __init__(self, host, port, debug):
        self.host = host
        self.port = port
        self.debug = debug

    def start_server(self):
        cmd = ['python', RUN_SERVER_PY, '--host', str(self.host), '--port', str(self.port)]
        if self.debug:
            cmd.append('--debug')
        if not self.server_prc or self.server_prc.poll():
            self.server_prc = subprocess.Popen(cmd)

    def kill_server(self):
        if self.server_prc and not self.server_prc.poll():
            self.server_prc.kill()

    def ws_send(self, data):
        req = urllib2.Request("http://{0}:{1}/socket".format(self.host, self.port),
                              json.dumps(data), {'Content-Type': 'application/json'})
        try:
            urllib2.urlopen(req)
        except urllib2.HTTPError as e:
            # websocket still processing previous reload event
            if e.code == 503:
                pass
            if e.code == 101:
                self.start_server()
            else:
                raise(e)
