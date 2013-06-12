# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import os
import subprocess
import urllib2
import json

import vim


def start_server(force_restart=False):
    print "Starting server"
    global server_prc
    '''starts the websocketserver in a subprocess and writes
    the server's pid to /tmp/vimfox/vimfox.pid'''

    if force_restart:
        try:
            server_prc.kill()
        except:
            pass

    if not server_prc or server_prc.poll():

        server_prc = subprocess.Popen(['python', RUN_SERVER_PY, '--host', SERVER_HOST,
                                       '--port', str(SERVER_PORT)])


def kill_server():
    if server_prc and not server_prc.poll():
        server_prc.kill()


def websocket_send(data):
    '''POST serialized json to the HTTP server which acts as an intermediary
    between vim and the websockets'''
    req = urllib2.Request("http://{0}:{1}/socket".format(SERVER_HOST, SERVER_PORT),
                          json.dumps(data), {'Content-Type': 'application/json'})
    try:
        urllib2.urlopen(req)
    except urllib2.HTTPError as e:
        # websocket still processing previous reload event
        if e.code == 503:
            pass
        if e.code == 101:
            start_server()
        else:
            raise(e)


def create_reload_event(auto_call=False):
    '''Called from either vim after a buffer write or from the check_buffer
    function. Creates the reload event based on the filetype of the current buffer.'''
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


def auto_check_buffer():
    """Called after CursorHold and InsertLeave and determines whether
    current buffer has changes using vims builtin changenr()."""
    # get current number of changes for buffer
    cur_num_changes = vim_setting('changenr()')
    if not int(vim.eval('exists("s:num_changes")')):
        vim.command('let s:num_changes = ' + cur_num_changes)
    num_changes = vim_setting('s:num_changes')
    # only reload if buffer has been changed
    if num_changes != cur_num_changes:
        create_reload_event(True)
        vim_setting({'s:num_changes': cur_num_changes})


def vim_setting(*settings):
    '''Used to set en retrieve vim settings. When the argument is a dict
    assume its a set setting request, otherwise retrieve provided setting'''
    ret = []
    for s in settings:
        if isinstance(s, dict):
            vim.command("let {} = {}".format(*s.items()[0]))
        else:
            s = vim.eval(s)
            if s.rfind(',') != -1:
                s = [x.strip() for x in s.strip('[|]').split(',')]
            ret.append(s)
    ret = tuple(ret)
    if len(ret) == 1:
        ret = ret[0]
    return ret


# init vimfox
SERVER_HOST, SERVER_PORT = vim_setting('g:Vimfox_host', 'g:Vimfox_port')
RUN_SERVER_PY = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'server', 'run.py')
server_prc = None
