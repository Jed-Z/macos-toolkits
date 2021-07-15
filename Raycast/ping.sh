#!/bin/bash

# @raycast.title Ping
# @raycast.author Caleb Stauffer
# @raycast.authorURL https://github.com/crstauf
# @raycast.description Ping an IP address or URL.

# @raycast.icon 🌐
# @raycast.mode fullOutput
# @raycast.packageName Internet
# @raycast.schemaVersion 1

# @raycast.argument1 { "type": "text", "placeholder": "target" }

ping "$1"