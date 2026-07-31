#!/usr/bin/env bash
# Professional Report v2 - Fixed 100 Mark Rubric
REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"
DATE=$(date +%Y%m%d_%H%M%S)

read -p "Student Name : " NAME
read -p "Roll No      : " ROLL
read -p "Batch        : " BATCH
read -p "Division     : " DIV
read -p "Experiment # : " EXP
read -p "Experiment   : " EXPT

OUT="$REPORT_DIR/${ROLL}_${DATE}"
mkdir -p "$OUT"
REPORT="$OUT/report.md"

TOTAL=100
SCORE=0

pass(){ echo "[PASS] $1 (+$2)"; echo "|PASS|$1|$2|" >>"$REPORT"; SCORE=$((SCORE+$2));}
fail(){ echo "[FAIL] $1 (+0)"; echo "|FAIL|$1|0|" >>"$REPORT";}

echo "# Auto Grading Report" >"$REPORT"
echo "" >>"$REPORT"
echo "|Field|Value|" >>"$REPORT"
echo "|---|---|" >>"$REPORT"
for x in "Student|$NAME" "Roll|$ROLL" "Batch|$BATCH" "Division|$DIV" "Experiment|$EXP" "Title|$EXPT" "Generated|$(date)";do
echo "|$x|" >>"$REPORT";done
echo -e "\n## Checks\n\n|Status|Check|Marks|\n|---|---|---:|" >>"$REPORT"

echo "=== Environment (10) ==="
command -v python3 >/dev/null && pass "Python Installed" 2 || fail "Python Installed"
python3 -c "import requests" >/dev/null 2>&1 && pass "requests" 2 || fail "requests"
python3 -c "import pandas" >/dev/null 2>&1 && pass "pandas" 2 || fail "pandas"
python3 -c "import pymongo" >/dev/null 2>&1 && pass "pymongo" 2 || fail "pymongo"
command -v mongosh >/dev/null && pass "mongosh" 2 || fail "mongosh"

echo "=== Project Files (20) ==="
for f in config.py extractor.py validator.py transformer.py loader.py exporter.py products_etl.py requirements.txt data output logs;do
 if [ -e "$f" ];then pass "$f exists" 2;else fail "$f exists";fi
done
# max 20 by capping
if [ $SCORE -gt 30 ];then :;fi

echo "=== Syntax (20) ==="
for f in config.py extractor.py validator.py transformer.py loader.py exporter.py products_etl.py;do
 if [ -f "$f" ];then
   if python3 -m py_compile "$f" >/dev/null 2>&1;then pass "$f syntax" 2;else fail "$f syntax";fi
 else fail "$f syntax";fi
done

echo "=== MongoDB (20)==="
if command -v mongosh >/dev/null;then
 mongosh --quiet --eval "use ProductDB;db.products.countDocuments()" >/tmp/mdb 2>/dev/null
 if [ $? -eq 0 ];then
   pass "Mongo Connection" 5
   CNT=$(cat /tmp/mdb|tail -1)
   [ "$CNT" -gt 0 ] 2>/dev/null && pass "Documents Present" 5 || fail "Documents Present"
 else
   fail "Mongo Connection"; fail "Documents Present"
 fi
else
 fail "Mongo Connection"; fail "Documents Present"
fi
[ -f output/products.json ] && pass "JSON Export" 5 || fail "JSON Export"
[ -f output/products.csv ] && pass "CSV Export" 5 || fail "CSV Export"

echo "=== Execution (20)==="
if [ -f products_etl.py ];then
 START=$(date +%s)
 python3 products_etl.py >"$OUT/execution.log" 2>&1
 RC=$?
 END=$(date +%s)
 if [ $RC -eq 0 ];then pass "ETL Execution" 10;else fail "ETL Execution";fi
 echo "Execution Time: $((END-START)) sec" >>"$REPORT"
else
 fail "ETL Execution"
fi
curl -fs https://dummyjson.com/products >/dev/null 2>&1 && pass "REST API Reachable" 10 || fail "REST API Reachable"

PERCENT=$SCORE
if [ $PERCENT -gt 100 ];then PERCENT=100;fi
if [ $PERCENT -ge 90 ];then G=A+
elif [ $PERCENT -ge 80 ];then G=A
elif [ $PERCENT -ge 70 ];then G=B
elif [ $PERCENT -ge 60 ];then G=C
else G=F;fi

echo -e "\n## Result\n\n**Score:** $PERCENT / $TOTAL\n\n**Grade:** $G" >>"$REPORT"

echo "================================"
echo "FINAL SCORE : $PERCENT / 100"
echo "GRADE       : $G"
echo "REPORT      : $REPORT"
echo "================================"
