# -*- coding: utf-8 -*-
# dydrmntion@gmail.com ~ 2013

import vim


def vim_setting(*settings):
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
