#!/bin/bash
if pgrep mongod >/dev/null; then
 echo "MongoDB already running"
else
 sudo service mongod start 2>/dev/null || sudo systemctl start mongod
fi
