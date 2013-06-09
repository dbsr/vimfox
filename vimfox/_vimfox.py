# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import vim
import subprocess
import urllib2
import json


cur_path = vim.eval('expand("<sfile>:h")') + '/vimfox'

host = None
port = None


def start_server(h, p):
    global host, port
    host = h
    port = p

    subprocess.Popen(['python', os.path.join(cur_path, 'run.py'), host, str(port)])


def websocket_send(data):
    '''request server to initiate reload request through websocket'''
    req = urllib2.Request("http://{0}:{1}/socket".format(host, port), json.dumps(data),
                          {'Content-Type': 'application/json'})
    urllib2.urlopen(req)


def check_buffer():
    '''compares number of changes to decide whether a reload is needed.'''
    # get current number of changes for buffer
    cur_num_changes = vim.eval('changenr()')
    if not int(vim.eval('exists("s:num_changes")')):
        vim.command('let s:num_changes = ' + cur_num_changes)
    num_changes = vim.eval('s:num_changes')
    # only reload if buffer has been changed
    if num_changes != cur_num_changes:
        # write buffer
        vim.command('w')
        # chose namespace socketio based on mimetype
        buffer_file = os.path.basename(vim.current.buffer.name)
        ext = buffer_file.split('.')[-1]
        if ext in ['css', 'less']:
            css_file = buffer_file.replace('.less', '.css')
            # request the reload
            websocket_send({'event': 'reload_file', 'data': {'target_file': css_file}})
        elif ext == 'html':
            websocket_send({'event': 'reload_page', 'data': {'page': buffer_file}})
        # update num_changes
        vim.command('let s:num_changes = ' + cur_num_changes)
