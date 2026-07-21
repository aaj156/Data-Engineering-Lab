#!/usr/bin/env bash
#==============================================================================
# environment_report.sh
#
# Mini ETL Laboratory - Environment Report Generator v2.0
# Generates Markdown, TXT and HTML reports describing the current environment.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$HOME/Mini-ETL-NiFi-PostgreSQL}"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

STAMP=$(date +%F_%H-%M-%S)
LOG="$LOG_DIR/environment_report_$STAMP.log"

REPORT_MD="$REPORT_DIR/environment_report.md"
REPORT_TXT="$REPORT_DIR/environment_report.txt"
REPORT_HTML="$REPORT_DIR/environment_report.html"

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }

check_cmd(){
    if command -v "$1" >/dev/null 2>&1; then
        echo "PASS"
    else
        echo "FAIL"
    fi
}

JAVA_STATUS=$(check_cmd java)
PYTHON_STATUS=$(check_cmd python3)
GIT_STATUS=$(check_cmd git)
TREE_STATUS=$(check_cmd tree)
PSQL_STATUS=$(check_cmd psql)

UBUNTU=$(lsb_release -ds 2>/dev/null || echo "Unknown")
KERNEL=$(uname -r)
HOST=$(hostname)

JAVA_VER=$(java -version 2>&1 | head -1 || echo "Not Installed")
PYTHON_VER=$(python3 --version 2>/dev/null || echo "Not Installed")
GIT_VER=$(git --version 2>/dev/null || echo "Not Installed")
PSQL_VER=$(psql --version 2>/dev/null || echo "Not Installed")

POSTGRES_SERVICE="STOPPED"
if sudo -u postgres psql -c "SELECT 1;" >/dev/null 2>&1; then
    POSTGRES_SERVICE="RUNNING"
fi

NIFI_STATUS="STOPPED"
NIFI_URL="Unavailable"
if curl -ks https://localhost:8443/nifi >/dev/null 2>&1; then
    NIFI_STATUS="RUNNING"
    NIFI_URL="https://localhost:8443/nifi"
elif curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
    NIFI_STATUS="RUNNING"
    NIFI_URL="http://localhost:8080/nifi"
fi

REST_STATUS=$( [ "$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)" = "200" ] && echo "PASS" || echo "FAIL")

DB_STATUS="NOT FOUND"
TABLE_STATUS="NOT FOUND"
RECORDS="0"

if sudo -u postgres psql -lqt 2>/dev/null | cut -d'|' -f1 | grep -qw etl_lab; then
    DB_STATUS="AVAILABLE"
    if sudo -u postgres psql -d etl_lab -tAc "SELECT to_regclass('public.products');" | grep -q products; then
        TABLE_STATUS="AVAILABLE"
        RECORDS=$(sudo -u postgres psql -d etl_lab -tAc "SELECT COUNT(*) FROM products;" 2>/dev/null || echo 0)
    fi
fi

cat > "$REPORT_MD" <<EOF
# Environment Report

Generated: $(date)

## System

|Item|Value|
|---|---|
|Host|$HOST|
|OS|$UBUNTU|
|Kernel|$KERNEL|

## Software

|Component|Status|Version|
|---|---|---|
|Java|$JAVA_STATUS|$JAVA_VER|
|Python|$PYTHON_STATUS|$PYTHON_VER|
|Git|$GIT_STATUS|$GIT_VER|
|PostgreSQL|$PSQL_STATUS|$PSQL_VER|

## Services

|Service|Status|
|---|---|
|PostgreSQL|$POSTGRES_SERVICE|
|Apache NiFi|$NIFI_STATUS|
|REST API|$REST_STATUS|

## ETL Environment

|Item|Status|
|---|---|
|Database etl_lab|$DB_STATUS|
|Products Table|$TABLE_STATUS|
|Loaded Records|$RECORDS|
|NiFi URL|$NIFI_URL|
EOF

cat > "$REPORT_TXT" <<EOF
Mini ETL Environment Report

Generated : $(date)

Host : $HOST
OS   : $UBUNTU
Kernel : $KERNEL

Java        : $JAVA_VER
Python      : $PYTHON_VER
Git         : $GIT_VER
PostgreSQL  : $PSQL_VER

PostgreSQL Service : $POSTGRES_SERVICE
Apache NiFi        : $NIFI_STATUS
REST API           : $REST_STATUS

Database : $DB_STATUS
Table    : $TABLE_STATUS
Records  : $RECORDS
NiFi URL : $NIFI_URL
EOF

cat > "$REPORT_HTML" <<EOF
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>Environment Report</title>
<style>
body{font-family:Arial;margin:40px}
table{border-collapse:collapse;width:90%}
th,td{border:1px solid #666;padding:8px}
th{background:#1f4e79;color:#fff}
</style>
</head><body>
<h1>Mini ETL Environment Report</h1>
<p><b>Generated:</b> $(date)</p>
<h2>System Information</h2>
<table>
<tr><th>Item</th><th>Value</th></tr>
<tr><td>Host</td><td>$HOST</td></tr>
<tr><td>OS</td><td>$UBUNTU</td></tr>
<tr><td>Kernel</td><td>$KERNEL</td></tr>
</table>
<h2>Environment Status</h2>
<table>
<tr><th>Component</th><th>Status</th><th>Details</th></tr>
<tr><td>Java</td><td>$JAVA_STATUS</td><td>$JAVA_VER</td></tr>
<tr><td>Python</td><td>$PYTHON_STATUS</td><td>$PYTHON_VER</td></tr>
<tr><td>Git</td><td>$GIT_STATUS</td><td>$GIT_VER</td></tr>
<tr><td>PostgreSQL</td><td>$POSTGRES_SERVICE</td><td>$PSQL_VER</td></tr>
<tr><td>Apache NiFi</td><td>$NIFI_STATUS</td><td>$NIFI_URL</td></tr>
<tr><td>REST API</td><td>$REST_STATUS</td><td>Fake Store API</td></tr>
<tr><td>Database</td><td>$DB_STATUS</td><td>etl_lab</td></tr>
<tr><td>Products Table</td><td>$TABLE_STATUS</td><td>products</td></tr>
<tr><td>Loaded Records</td><td colspan="2">$RECORDS</td></tr>
</table>
</body></html>
EOF

echo "Environment report generated successfully."
echo "Markdown : $REPORT_MD"
echo "Text     : $REPORT_TXT"
echo "HTML     : $REPORT_HTML"
echo "Log      : $LOG"
