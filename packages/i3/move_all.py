#!/usr/bin/python3

import i3
from subprocess import call

for w in i3.get_workspaces():
    if w['focused']:
        cur_wks = w['name']

for w in i3.get_workspaces():
    i3.workspace(w['name'])
    i3.command('move', 'workspace to output right')

i3.command('workspace', cur_wks)

for w in i3.get_workspaces():
    if w['focused']:
        cur_output = w['output']
        break

call("xrandr --output {} --primary".format(cur_output), shell=True)
