# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import subprocess
import urllib2
import json


RUN_SERVER_PY = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'server', 'run.py')


class VimFox(object):

    server_prc = None
    server_prc_pid = None

    def __init__(self, host, port, debug, hide_status):
        self.host = host
        self.port = port
        self.debug = debug
        self.hide_status = hide_status
        self.start_server()

    def start_server(self):
        if self.server_is_down():
            cmd = ['python', RUN_SERVER_PY, '--host', str(self.host), '--port', str(self.port),
                   '--debug', str(self.debug), '--hide-status', str(self.hide_status)]
            if not self.server_prc or self.server_prc.poll():
                self.server_prc = subprocess.Popen(cmd)
                self.server_prc_pid = self.server_prc.pid

    def kill_server(self):
        """Attempts to terminate the server's subprocess. First it will try to
        send the SIGTERM straight to the subprocess instance. This should work most
        of the time. If vim crashed while vimfox was running we might have missed
        the on close autocmd which means the server was still running when we started
        vim. Now we'll have to try and use the pid send to us from the server when
        we checked it was alive."""

        if self.server_prc and not self.server_prc.poll():
            self.server_prc.kill()
        else:
            from signal import SIGTERM
            try:
                os.kill(self.server_prc_pid, SIGTERM)
            except OSError:
                pass

    def ws_send(self, event, delay, fname=None):
        """Sends commands to the vimfox HTTP server which acts as a relay between
        vim and the websockets on the page."""

        req = urllib2.Request("http://{0}:{1}/socket".format(self.host, self.port),
                              json.dumps({'event': event, 'fname': fname, 'delay': delay}),
                              {'Content-Type': 'application/json'})
        try:
            urllib2.urlopen(req)
        except urllib2.HTTPError as e:
            if e.code == 503:
                # ws is busy, ignore this request"
                pass
            else:
                raise(e)

    def server_is_down(self):
        """Checks whether the vimfox server is up and running. If it's up the response
        contains the pid number of the vimfox server process."""
        req = urllib2.Request("http://{0}:{1}/get-server-pid".format(self.host, self.port))
        try:
            r = urllib2.urlopen(req)
        except urllib2.URLError:
            return True
        else:
            self.server_prc_pid = int(r.read())
            return False

if __name__ == '__main__':
    vf = VimFox('l27.0.0.1', 9999, True)
