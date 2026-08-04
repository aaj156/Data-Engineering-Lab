#!/bin/bash
if curl -s http://localhost:9200 >/dev/null; then
 echo "Elasticsearch already running"
else
 read -p "Enter Elasticsearch installation path: " ESPATH
 cd "$ESPATH/bin" && ./elasticsearch &
 sleep 15
 curl http://localhost:9200
fi
