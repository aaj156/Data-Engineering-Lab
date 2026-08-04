#!/bin/bash
echo "=== Verifying Prerequisites ==="
for cmd in python3 pip git curl; do
  command -v $cmd >/dev/null && echo "✓ $cmd" || echo "✗ $cmd"
done
python3 --version
pip --version
curl -s http://localhost:9200 >/dev/null && echo "✓ Elasticsearch reachable" || echo "✗ Elasticsearch not reachable"
nc -z localhost 27017 && echo "✓ MongoDB port open" || echo "✗ MongoDB port closed"
