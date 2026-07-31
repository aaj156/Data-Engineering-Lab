#!/usr/bin/env bash
# Data Engineering Laboratory Auto Report Generator
# Experiment 04 - Part 1 & Part 2
set -e

REPORT_ROOT="reports"
DATE=$(date +"%Y%m%d_%H%M%S")

echo "========================================="
echo " DATA ENGINEERING LAB AUTO REPORT"
echo "========================================="

read -p "Student Name        : " STUDENT
read -p "Roll Number         : " ROLL
read -p "Batch               : " BATCH
read -p "Division            : " DIV
read -p "Experiment No       : " EXPNO
read -p "Experiment Title    : " EXPTITLE
read -p "Faculty             : " FACULTY

SAFE=$(echo "${STUDENT}_${ROLL}" | tr ' ' '_')
OUTDIR="${REPORT_ROOT}/${SAFE}_${DATE}"
mkdir -p "$OUTDIR"

REPORT="$OUTDIR/report.md"

PASS=0
TOTAL=0

check(){
 TOTAL=$((TOTAL+1))
 TITLE="$1"
 CMD="$2"

 echo "### $TITLE" >> "$REPORT"
 echo '```' >> "$REPORT"

 if eval "$CMD" >> "$REPORT" 2>&1; then
    echo "STATUS : PASS" >> "$REPORT"
    PASS=$((PASS+1))
 else
    echo "STATUS : FAIL" >> "$REPORT"
 fi
 echo '```' >> "$REPORT"
 echo "" >> "$REPORT"
}

echo "# Data Engineering Lab Report" > "$REPORT"
echo "" >> "$REPORT"
echo "|Field|Value|" >> "$REPORT"
echo "|---|---|" >> "$REPORT"
echo "|Student|$STUDENT|" >> "$REPORT"
echo "|Roll|$ROLL|" >> "$REPORT"
echo "|Batch|$BATCH|" >> "$REPORT"
echo "|Division|$DIV|" >> "$REPORT"
echo "|Experiment|$EXPNO|" >> "$REPORT"
echo "|Title|$EXPTITLE|" >> "$REPORT"
echo "|Faculty|$FACULTY|" >> "$REPORT"
echo "|Generated|$(date)|" >> "$REPORT"
echo "" >> "$REPORT"

echo "# Environment Checks" >> "$REPORT"

check "Ubuntu Version" "lsb_release -a"
check "Python Version" "python3 --version"
check "Pip Version" "pip3 --version"
check "Git Version" "git --version"
check "Curl Version" "curl --version | head -1"
check "MongoDB Shell" "mongosh --version"
check "MongoDB Service" "systemctl is-active mongod"

echo "# Python Packages" >> "$REPORT"
check "requests" "python3 -c 'import requests;print(requests.__version__)'"
check "pymongo" "python3 -c 'import pymongo;print(pymongo.__version__)'"
check "pandas" "python3 -c 'import pandas;print(pandas.__version__)'"

echo "# Project Structure" >> "$REPORT"
for f in config.py extractor.py validator.py transformer.py loader.py exporter.py products_etl.py requirements.txt
do
 TOTAL=$((TOTAL+1))
 echo "### $f" >> "$REPORT"
 if [ -s "$f" ]; then
   echo "PASS" >> "$REPORT"
   PASS=$((PASS+1))
 else
   echo "FAIL - Missing or Empty" >> "$REPORT"
 fi
 echo "" >> "$REPORT"
done

echo "# Python Syntax" >> "$REPORT"
for f in config.py extractor.py validator.py transformer.py loader.py exporter.py products_etl.py
do
 [ -f "$f" ] && check "Compile $f" "python3 -m py_compile $f"
done

echo "# MongoDB Checks" >> "$REPORT"
check "Databases" "mongosh --quiet --eval 'show dbs'"
check "Collections" "mongosh --quiet --eval 'use ProductDB; show collections'"
check "Document Count" "mongosh --quiet --eval 'use ProductDB; db.products.countDocuments()'"

echo "# REST API" >> "$REPORT"
check "DummyJSON API" "curl -s https://dummyjson.com/products | python3 -c 'import sys,json;print(len(json.load(sys.stdin)[\"products\"]))'"

echo "# Export Files" >> "$REPORT"
for f in output/products.json output/products.csv logs/etl.log
do
 TOTAL=$((TOTAL+1))
 echo "### $f" >> "$REPORT"
 if [ -s "$f" ]; then
   echo "PASS" >> "$REPORT"
   PASS=$((PASS+1))
 else
   echo "FAIL" >> "$REPORT"
 fi
 echo "" >> "$REPORT"
done

if [ -f products_etl.py ]; then
 echo "# ETL Execution" >> "$REPORT"
 START=$(date +%s)
 python3 products_etl.py > "$OUTDIR/execution.log" 2>&1 || true
 END=$(date +%s)
 echo "- Execution Time : $((END-START)) sec" >> "$REPORT"
 echo "- Execution Log  : execution.log" >> "$REPORT"
fi

PERCENT=$((PASS*100/TOTAL))
if [ "$PERCENT" -ge 90 ]; then GRADE="A+"
elif [ "$PERCENT" -ge 80 ]; then GRADE="A"
elif [ "$PERCENT" -ge 70 ]; then GRADE="B"
elif [ "$PERCENT" -ge 60 ]; then GRADE="C"
else GRADE="Needs Improvement"
fi

echo "" >> "$REPORT"
echo "# Final Result" >> "$REPORT"
echo "- Passed Checks : $PASS / $TOTAL" >> "$REPORT"
echo "- Percentage    : $PERCENT%" >> "$REPORT"
echo "- Grade         : $GRADE" >> "$REPORT"

cp "$REPORT" "$OUTDIR/report.txt"

echo ""
echo "======================================"
echo "Report Generated Successfully"
echo "Location: $OUTDIR"
echo "Score : $PASS / $TOTAL"
echo "Grade : $GRADE"
echo "======================================"
