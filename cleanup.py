#!/bin/env python
# This cleans existing evolution and goa data

import os

folders = ['~/.local/share/evolution', '~/.cache/evolution', '~/.config/evolution']
for folder in folders:
    os.system("rm -rf %s &> /dev/null" % folder)

# Clean up goa data
os.system("rm -rf ~/.config/goa-1.0/accounts.conf")
os.system("killall goa-daemon 2&> /dev/null")
