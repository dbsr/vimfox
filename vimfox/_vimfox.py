# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import vim
import subprocess
import urllib2
import json

from util import vim_setting

cur_path = vim.eval('expand("<sfile>:h")') + '/vimfox'


def start_server():
    host, port = vim_setting('g:Vimfox_host', 'g:Vimfox_port')
    subprocess.Popen(['python', os.path.join(cur_path, 'run.py'), '--host', host,
                      '--port', str(port)])


def websocket_send(data):
    '''request server to initiate reload request through websocket'''
    host, port = vim_setting('g:Vimfox_host', 'g:Vimfox_port')
    req = urllib2.Request("http://{0}:{1}/socket".format(host, port), json.dumps(data),
                          {'Content-Type': 'application/json'})

    try:
        urllib2.urlopen(req)
    except urllib2.HTTPError as e:
        # If 503 it means server is still processing previous reload
        # request, else reraise
        if e.code == 503:
            pass
        else:
            raise(e)


def reload_buffer(auto_call=False):
    fname = os.path.basename(vim.current.buffer.name)
    ext = fname.split('.')[-1]
    vim_cmd = 'w'
    if ext in ['css', 'less']:
        data = {
            'data': {
                'fname': fname.replace('.less', '.css'),
                'element': 'link',
                'tag': 'href'
            },
            'event': 'reload_file'
        }
        if ext == 'less':
            vim_cmd += '|call b:LessCSSCompress()'
    elif ext in ['coffee', 'js']:
        data = {
            'data': {
                'fname': fname.replace('.coffee', '.js'),
                'element': 'script',
                'tag': 'src'
            },
            'event': 'reload_file'
        }
        if ext == 'coffee':
            vim_cmd += '|silent! CoffeeMake! -b'
    else:
        data = {
            'data': {
                'force_get': False,
            },
            'event': 'reload_page'
        }

    if auto_call:
        vim.command(vim_cmd)
    websocket_send(data)


def check_buffer():
    '''compares number of changes to decide whether a reload is needed.'''
    # get current number of changes for buffer
    cur_num_changes = vim_setting('changenr()')
    if not int(vim.eval('exists("s:num_changes")')):
        vim.command('let s:num_changes = ' + cur_num_changes)
    num_changes = vim_setting('s:num_changes')
    # only reload if buffer has been changed
    if num_changes != cur_num_changes:
        reload_buffer(True)
        vim_setting({'s:num_changes': cur_num_changes})
