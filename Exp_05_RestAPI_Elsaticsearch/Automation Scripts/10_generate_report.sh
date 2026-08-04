#!/bin/bash
OUT=report.txt
echo "Experiment Report" > $OUT
date >> $OUT
echo "Python: $(python3 --version)" >> $OUT
echo "Packages:" >> $OUT
pip freeze >> $OUT
echo "MongoDB Port:" >> $OUT
nc -z localhost 27017 && echo OK >> $OUT || echo FAIL >> $OUT
echo "Elasticsearch:" >> $OUT
curl -s http://localhost:9200 >> $OUT
tree . >> $OUT 2>/dev/null || find . >> $OUT
echo "Report saved to $OUT"
