#!/usr/bin/env bash
#==============================================================================
# final_lab_report.sh
#
# Mini ETL Laboratory - Final Consolidated Report Generator v2.0
# Collects outputs from all validation scripts and produces a final report
# in Markdown, TXT and HTML formats.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$HOME/Mini-ETL-NiFi-PostgreSQL}"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

STAMP=$(date +%F_%H-%M-%S)

MD="$REPORT_DIR/final_lab_report.md"
TXT="$REPORT_DIR/final_lab_report.txt"
HTML="$REPORT_DIR/final_lab_report.html"
LOG="$LOG_DIR/final_lab_report_$STAMP.log"

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }

status_file(){
    [ -f "$1" ] && echo "AVAILABLE" || echo "MISSING"
}

check_service(){
    "$@" >/dev/null 2>&1 && echo "PASS" || echo "FAIL"
}

clear
echo "=============================================================="
echo " Mini ETL Laboratory - Final Report Generator v2.0"
echo "=============================================================="

read -rp "Student Name  : " NAME
read -rp "Roll Number   : " ROLL
read -rp "Class         : " CLASS
read -rp "Faculty Name  : " FACULTY

JAVA=$(check_service command -v java)
PYTHON=$(check_service command -v python3)
GIT=$(check_service command -v git)
POSTGRES=$(check_service sudo -u postgres psql -d etl_lab -c "SELECT 1;")

if curl -ks https://localhost:8443/nifi >/dev/null 2>&1 || \
   curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
    NIFI="PASS"
else
    NIFI="FAIL"
fi

API=$( [ "$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)" = "200" ] && echo PASS || echo FAIL )

DB="FAIL"; TABLE="FAIL"; RECORDS=0
if sudo -u postgres psql -lqt 2>/dev/null | cut -d'|' -f1 | grep -qw etl_lab; then
    DB="PASS"
    if sudo -u postgres psql -d etl_lab -tAc "SELECT to_regclass('public.products');" | grep -q products; then
        TABLE="PASS"
        RECORDS=$(sudo -u postgres psql -d etl_lab -tAc "SELECT COUNT(*) FROM products;" 2>/dev/null || echo 0)
    fi
fi

FILES=(
"$REPORT_DIR/environment_report.md"
"$REPORT_DIR/student_execution_report.md"
"$REPORT_DIR/assignment_grading_report.md"
"$REPORT_DIR/pipeline_validation_report.md"
"$PROJECT_ROOT/nifi-template/MiniETL.json"
"$PROJECT_ROOT/sql/create_database.sql"
"$PROJECT_ROOT/sql/create_tables.sql"
"$PROJECT_ROOT/sql/sample_queries.sql"
)

AVAILABLE=0
for f in "${FILES[@]}"; do
    [ -f "$f" ] && AVAILABLE=$((AVAILABLE+1))
done

TOTAL=${#FILES[@]}
PERCENT=$(( AVAILABLE * 100 / TOTAL ))

cat > "$MD" <<EOF
# Final Laboratory Report

Generated: $(date)

## Student

|Field|Value|
|---|---|
|Name|$NAME|
|Roll No|$ROLL|
|Class|$CLASS|
|Faculty|$FACULTY|

## Environment Summary

|Component|Status|
|---|---|
|Java|$JAVA|
|Python|$PYTHON|
|Git|$GIT|
|PostgreSQL|$POSTGRES|
|Apache NiFi|$NIFI|
|REST API|$API|
|Database|$DB|
|Products Table|$TABLE|
|Records Loaded|$RECORDS|

## Deliverables

|Artifact|Status|
|---|---|
|Environment Report|$(status_file "$REPORT_DIR/environment_report.md")|
|Student Report|$(status_file "$REPORT_DIR/student_execution_report.md")|
|Assignment Grading|$(status_file "$REPORT_DIR/assignment_grading_report.md")|
|Pipeline Validation|$(status_file "$REPORT_DIR/pipeline_validation_report.md")|
|MiniETL.json|$(status_file "$PROJECT_ROOT/nifi-template/MiniETL.json")|
|create_database.sql|$(status_file "$PROJECT_ROOT/sql/create_database.sql")|
|create_tables.sql|$(status_file "$PROJECT_ROOT/sql/create_tables.sql")|
|sample_queries.sql|$(status_file "$PROJECT_ROOT/sql/sample_queries.sql")|

## Repository Completion

- Available Artifacts: **$AVAILABLE / $TOTAL**
- Completion: **$PERCENT %**

## Faculty Decision

- [ ] Accepted
- [ ] Revision Required
- [ ] Resubmit

Faculty Remarks:

_________________________________________
EOF

cat > "$TXT" <<EOF
FINAL LAB REPORT

Student : $NAME
Roll No : $ROLL
Class   : $CLASS
Faculty : $FACULTY

Java        : $JAVA
Python      : $PYTHON
Git         : $GIT
PostgreSQL  : $POSTGRES
Apache NiFi : $NIFI
REST API    : $API
Database    : $DB
Table       : $TABLE
Records     : $RECORDS

Artifacts Available : $AVAILABLE / $TOTAL
Completion         : $PERCENT %
EOF

cat > "$HTML" <<EOF
<!DOCTYPE html>
<html><head><meta charset="utf-8">
<title>Final Laboratory Report</title>
<style>
body{font-family:Arial;margin:40px}
table{border-collapse:collapse;width:90%}
th,td{border:1px solid #555;padding:8px}
th{background:#1f4e79;color:#fff}
.badge{display:inline-block;padding:8px 14px;border:1px solid #333;background:#eef}
</style>
</head><body>
<h1>Mini ETL Laboratory - Final Report</h1>
<p><strong>Generated:</strong> $(date)</p>

<h2>Student Information</h2>
<table>
<tr><th>Field</th><th>Value</th></tr>
<tr><td>Name</td><td>$NAME</td></tr>
<tr><td>Roll No</td><td>$ROLL</td></tr>
<tr><td>Class</td><td>$CLASS</td></tr>
<tr><td>Faculty</td><td>$FACULTY</td></tr>
</table>

<h2>Environment Summary</h2>
<table>
<tr><th>Component</th><th>Status</th></tr>
<tr><td>Java</td><td>$JAVA</td></tr>
<tr><td>Python</td><td>$PYTHON</td></tr>
<tr><td>Git</td><td>$GIT</td></tr>
<tr><td>PostgreSQL</td><td>$POSTGRES</td></tr>
<tr><td>Apache NiFi</td><td>$NIFI</td></tr>
<tr><td>REST API</td><td>$API</td></tr>
<tr><td>Database</td><td>$DB</td></tr>
<tr><td>Products Table</td><td>$TABLE</td></tr>
<tr><td>Records Loaded</td><td>$RECORDS</td></tr>
</table>

<h2>Repository Completion</h2>
<p class="badge">$AVAILABLE / $TOTAL Artifacts Available ($PERCENT%)</p>

<h2>Faculty Remarks</h2>
<hr>
<p>Signature: ________________________</p>
</body></html>
EOF

echo
echo "=============================================================="
echo "Final Laboratory Report Generated"
echo "Markdown : $MD"
echo "Text     : $TXT"
echo "HTML     : $HTML"
echo "Log      : $LOG"
echo "=============================================================="
