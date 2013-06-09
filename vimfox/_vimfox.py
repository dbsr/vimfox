# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import vim
import subprocess
import urllib2

cur_path = vim.eval('expand("<sfile>:h")') + '/vimfox'

host = None
port = None


def start_server(h, p):
    global host, port
    host = h
    port = p

    subprocess.Popen(['python', os.path.join(cur_path, 'run.py'), host, str(port)])


def request_reload(target_file):
    '''request server to initiate reload request through websocket'''
    urllib2.urlopen('http://{}:{}/do_reload?target_file={}'.format(host, port, target_file))


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
        css_file = vim.current.buffer.name.replace('.less', '.css')
        # request the reload
        request_reload(os.path.basename(css_file))
        # update num_changes
        vim.command('let s:num_changes = ' + cur_num_changes)
