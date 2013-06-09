# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import vim
import subprocess
import urllib2

import server

cur_path = vim.eval('expand("<sfile>:h")')


def start_server(host, port):
    subprocess.Popen(['python', os.path.join(cur_path, 'run.py'), host, str(port)])


def request_reload(host, port, target_file):
    '''request server to initiate reload request through websocket'''
    urllib2.urlopen('http://{host}:{port}/do_reload?target_file={target_file}'.format(*vars()))


def check_buffer():
    '''compares number of changes to decide whether a reload is needed.'''
    # get current number of changes for buffer
    cur_num_changes = vim.eval('changenr()')
    if not int(vim.eval('exists("s:num_changes")')):
        vim.command('let s:num_changes = ' + cur_num_changes)
    num_changes = vim.eval('s:num_changes')

    # only reload if buffer has been changed
    if num_changes != cur_num_changes:
        css_file = vim.current.buffer.name.replace('.less', '.css')
        vim.command('noautocmd w')
        if vim.current.buffer.name.endswith('.less'):
            # only reload if the less compiled to css succesfully
            def get_mtime(fpath):
                try:
                    return os.stat(css_file).st_mtime
                except IOError:
                    pass

            mtime = get_mtime(css_file)
            vim.command('call LessCSSCompress()')

            if mtime and mtime == get_mtime(css_file):
                return
        # request the reload
        server.request_reload(css_file)
        # update num_changes
        vim.command('let s:num_changes = ' + cur_num_changes)
