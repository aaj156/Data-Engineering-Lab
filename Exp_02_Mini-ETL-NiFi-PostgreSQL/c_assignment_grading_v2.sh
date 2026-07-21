#!/usr/bin/env bash
#==============================================================================
# assignment_grading_v2.sh
#
# Professional Assignment Grader v2.0
# Generates grading reports in Markdown, TXT and HTML.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$HOME/Mini-ETL-NiFi-PostgreSQL}"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

STAMP=$(date +%F_%H-%M-%S)
REPORT_MD="$REPORT_DIR/assignment_grading_report.md"
REPORT_TXT="$REPORT_DIR/assignment_grading_report.txt"
REPORT_HTML="$REPORT_DIR/assignment_grading_report.html"
LOG_FILE="$LOG_DIR/assignment_grading_$STAMP.log"

TOTAL=100
SCORE=0

green="\033[0;32m"; red="\033[0;31m"; blue="\033[0;34m"; nc="\033[0m"

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }

check(){
    local title="$1"; local marks="$2"; shift 2
    if "$@" >/dev/null 2>&1; then
        SCORE=$((SCORE+marks))
        STATUS="PASS"
        printf "%-40s PASS (+%d)\n" "$title" "$marks"
    else
        STATUS="FAIL"
        printf "%-40s FAIL (+0)\n" "$title"
    fi
    MD_ROWS+="|$title|$STATUS|$marks|\n"
    TXT_ROWS+="$title : $STATUS ($marks)\n"
    HTML_ROWS+="<tr><td>$title</td><td>$STATUS</td><td>$marks</td></tr>"
}

clear
echo "========================================================"
echo " Mini ETL Assignment Grader v2.0"
echo "========================================================"

read -rp "Student Name : " NAME
read -rp "Roll Number  : " ROLL
read -rp "Class         : " CLASS

MD_ROWS=""
TXT_ROWS=""
HTML_ROWS=""

check "Java Installed" 5 command -v java
check "Python Installed" 5 command -v python3
check "Git Installed" 5 command -v git
check "PostgreSQL Installed" 10 command -v psql
check "Database Exists" 10 bash -c "sudo -u postgres psql -lqt | grep -qw etl_lab"
check "Products Table Exists" 10 bash -c "sudo -u postgres psql -d etl_lab -tAc \"SELECT to_regclass('public.products');\"|grep -q products"
check "Records Loaded (>0)" 15 bash -c "[[ \$(sudo -u postgres psql -d etl_lab -tAc 'SELECT COUNT(*) FROM products;' 2>/dev/null||echo 0) -gt 0 ]]"
check "NiFi Template Exported" 10 test -f "$PROJECT_ROOT/nifi-template/MiniETL.json"
check "Student Report Available" 5 test -f "$PROJECT_ROOT/reports/student_execution_report.md"
check "Pipeline Validator Script" 5 test -f "$PROJECT_ROOT/scripts/validate_nifi_pipeline.sh"
check "Repair Script" 5 test -f "$PROJECT_ROOT/scripts/etl_repair_and_validate.sh"
check "SQL Scripts Present" 5 test -f "$PROJECT_ROOT/sql/create_database.sql"
check "Documentation Present" 5 test -f "$PROJECT_ROOT/docs/03-Building-the-NiFi-Flow.md"

GRADE="F"
if [ $SCORE -ge 90 ]; then GRADE="Outstanding (O)"
elif [ $SCORE -ge 80 ]; then GRADE="A+"
elif [ $SCORE -ge 70 ]; then GRADE="A"
elif [ $SCORE -ge 60 ]; then GRADE="B"
elif [ $SCORE -ge 50 ]; then GRADE="C"
fi

cat > "$REPORT_MD" <<EOF
# Assignment Grading Report

**Student:** $NAME  
**Roll No:** $ROLL  
**Class:** $CLASS  
**Generated:** $(date)

|Criterion|Status|Marks|
|---|---|---:|
$(printf "%b" "$MD_ROWS")

## Result

- Score: **$SCORE / $TOTAL**
- Grade: **$GRADE**

## Faculty Remarks

_________________________________________

Faculty Signature: ______________________
EOF

cat > "$REPORT_TXT" <<EOF
Mini ETL Assignment Grading Report

Student : $NAME
Roll No : $ROLL
Class   : $CLASS
Date    : $(date)

$(printf "%b" "$TXT_ROWS")

Score : $SCORE / $TOTAL
Grade : $GRADE

Faculty Remarks:
_________________________________________
EOF

cat > "$REPORT_HTML" <<EOF
<!DOCTYPE html>
<html><head><meta charset="utf-8">
<title>Assignment Grading Report</title>
<style>
body{font-family:Arial;margin:40px}
table{border-collapse:collapse;width:90%}
th,td{border:1px solid #555;padding:8px}
th{background:#1f4e79;color:#fff}
.summary{margin-top:20px;padding:10px;border:1px solid #999;background:#f5f5f5}
</style>
</head><body>
<h1>Mini ETL Assignment Grading Report</h1>
<p><b>Student:</b> $NAME<br>
<b>Roll No:</b> $ROLL<br>
<b>Class:</b> $CLASS<br>
<b>Date:</b> $(date)</p>
<table>
<tr><th>Criterion</th><th>Status</th><th>Marks</th></tr>
$HTML_ROWS
</table>
<div class="summary">
<h2>Score: $SCORE / $TOTAL</h2>
<h2>Grade: $GRADE</h2>
</div>
<p><b>Faculty Remarks:</b></p>
<hr><br>
<p>Signature: ________________________</p>
</body></html>
EOF

log "Assignment grading completed."

echo
echo -e "${green}Completed Successfully${nc}"
echo "Score : $SCORE / $TOTAL"
echo "Grade : $GRADE"
echo
echo "Reports:"
echo "  $REPORT_MD"
echo "  $REPORT_TXT"
echo "  $REPORT_HTML"
echo "Log:"
echo "  $LOG_FILE"
