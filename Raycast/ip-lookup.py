#!/usr/local/bin/python3

# @raycast.title IP Lookup
# @raycast.description Lookup an IP address or host.

# @raycast.icon 🌐
# @raycast.mode fullOutput
# @raycast.packageName Internet
# @raycast.schemaVersion 1

# @raycast.argument1 { "type": "text", "placeholder": "target" }

import sys
import socket
import requests

query = sys.argv[1]
try:
    ip = socket.gethostbyname(query)
    url = 'http://cip.cc/' + ip
    rsp = requests.get(url, headers={'User-Agent': 'curl/7.64.1'}, timeout=3)
    print(rsp.text)
except Exception as e:
    print(e)
