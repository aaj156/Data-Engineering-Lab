#!/bin/bash
echo "OS:"; uname -a
echo "Python:"; python3 --version
echo "Memory:"; free -h
echo "Disk:"; df -h
echo "MongoDB:"; mongod --version | head -1
echo "Elasticsearch:"; curl -s http://localhost:9200
