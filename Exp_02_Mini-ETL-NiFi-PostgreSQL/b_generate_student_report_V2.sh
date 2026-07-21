#!/usr/bin/env bash
#==============================================================================
# generate_student_report_V2.sh
#
# Professional Student Report Generator v2.0
# Generates Markdown, TXT and HTML reports with automatic environment summary.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$HOME/Mini-ETL-NiFi-PostgreSQL}"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

STAMP=$(date +%F_%H-%M-%S)

REPORT_MD="$REPORT_DIR/student_execution_report.md"
REPORT_TXT="$REPORT_DIR/student_execution_report.txt"
REPORT_HTML="$REPORT_DIR/student_execution_report.html"
LOG_FILE="$LOG_DIR/student_report_v2_$STAMP.log"

COLLEGE="SIES Graduate School of Technology"
COURSE="Data Engineering Laboratory"
EXP="Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL"

green="\033[0;32m"; blue="\033[0;34m"; nc="\033[0m"

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }

clear
echo "============================================================"
echo " Student Report Generator v2.0"
echo "============================================================"

read -rp "Student Name        : " NAME
read -rp "Roll Number         : " ROLL
read -rp "Class/Division      : " CLASS
read -rp "Batch               : " BATCH
read -rp "Experiment Date     : " EXPDATE

JAVA=$(command -v java >/dev/null && echo PASS || echo FAIL)
POSTGRES=$(sudo -u postgres psql -d etl_lab -c "SELECT 1;" >/dev/null 2>&1 && echo PASS || echo FAIL)

if curl -ks https://localhost:8443/nifi >/dev/null 2>&1 || curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
 NIFI=PASS
else
 NIFI=FAIL
fi

API=$( [ "$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)" = "200" ] && echo PASS || echo FAIL )

COUNT=$(sudo -u postgres psql -d etl_lab -tAc "SELECT COUNT(*) FROM products;" 2>/dev/null || echo 0)
TEMPLATE=$( [ -f "$PROJECT_ROOT/nifi-template/MiniETL.json" ] && echo YES || echo NO )

cat > "$REPORT_MD" <<EOF
# Student Execution Report

## Student Details

|Field|Value|
|---|---|
|Name|$NAME|
|Roll No|$ROLL|
|Class|$CLASS|
|Batch|$BATCH|
|Date|$EXPDATE|

## Experiment

$EXP

## Validation

|Component|Status|
|---|---|
|Java|$JAVA|
|PostgreSQL|$POSTGRES|
|Apache NiFi|$NIFI|
|REST API|$API|
|Records Loaded|$COUNT|
|MiniETL.json Exported|$TEMPLATE|

## ETL Pipeline

- InvokeHTTP
- SplitJson
- JoltTransformJSON
- UpdateRecord
- PutDatabaseRecord

## Reflection

- Challenges:
- Learning Outcome:
- Improvements:

## Faculty Remarks

___________________________
EOF

cat > "$REPORT_TXT" <<EOF
$COLLEGE
$COURSE

STUDENT EXECUTION REPORT

Name        : $NAME
Roll No     : $ROLL
Class        : $CLASS
Batch        : $BATCH
Date         : $EXPDATE

Java         : $JAVA
PostgreSQL   : $POSTGRES
Apache NiFi  : $NIFI
REST API     : $API
Records      : $COUNT
Template     : $TEMPLATE
EOF

cat > "$REPORT_HTML" <<EOF
<!DOCTYPE html>
<html><head><meta charset="utf-8">
<title>Student Execution Report</title>
<style>
body{font-family:Arial;margin:35px}
table{border-collapse:collapse;width:80%}
td,th{border:1px solid #444;padding:8px}
th{background:#1f4e79;color:#fff}
.pass{color:green;font-weight:bold}
.fail{color:red;font-weight:bold}
</style></head>
<body>
<h1>$COLLEGE</h1>
<h2>$COURSE</h2>
<h3>$EXP</h3>

<table>
<tr><th>Field</th><th>Value</th></tr>
<tr><td>Name</td><td>$NAME</td></tr>
<tr><td>Roll No</td><td>$ROLL</td></tr>
<tr><td>Class</td><td>$CLASS</td></tr>
<tr><td>Batch</td><td>$BATCH</td></tr>
<tr><td>Date</td><td>$EXPDATE</td></tr>
</table>

<br>

<table>
<tr><th>Component</th><th>Status</th></tr>
<tr><td>Java</td><td>$JAVA</td></tr>
<tr><td>PostgreSQL</td><td>$POSTGRES</td></tr>
<tr><td>Apache NiFi</td><td>$NIFI</td></tr>
<tr><td>REST API</td><td>$API</td></tr>
<tr><td>Records Loaded</td><td>$COUNT</td></tr>
<tr><td>MiniETL.json</td><td>$TEMPLATE</td></tr>
</table>

<p><strong>Generated:</strong> $(date)</p>
</body></html>
EOF

log "Reports generated"

echo
echo -e "${green}Reports generated successfully.${nc}"
echo "Markdown : $REPORT_MD"
echo "Text     : $REPORT_TXT"
echo "HTML     : $REPORT_HTML"
echo "Log      : $LOG_FILE"
