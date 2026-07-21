#!/usr/bin/env bash
#==============================================================================
# pipeline_validation_report.sh
#
# Generates a comprehensive validation report for the Mini ETL Pipeline.
# Reports: Markdown, TXT and HTML
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="${PROJECT_ROOT:-$HOME/Mini-ETL-NiFi-PostgreSQL}"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

STAMP=$(date +%F_%H-%M-%S)
LOG="$LOG_DIR/pipeline_validation_$STAMP.log"
MD="$REPORT_DIR/pipeline_validation_report.md"
TXT="$REPORT_DIR/pipeline_validation_report.txt"
HTML="$REPORT_DIR/pipeline_validation_report.html"

log(){ echo "[$(date '+%F %T')] $*" >> "$LOG"; }

status(){ "$@" >/dev/null 2>&1 && echo PASS || echo FAIL; }

JAVA=$(status command -v java)
POSTGRES=$(status sudo -u postgres psql -d etl_lab -c "SELECT 1;")
API=$( [ "$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)" = "200" ] && echo PASS || echo FAIL )

if curl -ks https://localhost:8443/nifi >/dev/null 2>&1 || \
   curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
    NIFI="PASS"
else
    NIFI="FAIL"
fi

DB="FAIL"
TABLE="FAIL"
COUNT=0

if sudo -u postgres psql -lqt 2>/dev/null | cut -d'|' -f1 | grep -qw etl_lab; then
    DB="PASS"
    if sudo -u postgres psql -d etl_lab -tAc "SELECT to_regclass('public.products');" | grep -q products; then
        TABLE="PASS"
        COUNT=$(sudo -u postgres psql -d etl_lab -tAc "SELECT COUNT(*) FROM products;" 2>/dev/null || echo 0)
    fi
fi

TEMPLATE=$( [ -f "$PROJECT_ROOT/nifi-template/MiniETL.json" ] && echo PASS || echo FAIL )
DOCS=$( [ -f "$PROJECT_ROOT/docs/03-Building-the-NiFi-Flow.md" ] && echo PASS || echo FAIL )
SQL=$( [ -f "$PROJECT_ROOT/sql/create_tables.sql" ] && echo PASS || echo FAIL )
REPORT=$( [ -f "$PROJECT_ROOT/reports/student_execution_report.md" ] && echo PASS || echo FAIL )

cat >"$MD"<<EOF
# Pipeline Validation Report

Generated: $(date)

| Validation Item | Status |
|---|---|
| Java | $JAVA |
| PostgreSQL | $POSTGRES |
| Apache NiFi | $NIFI |
| REST API | $API |
| Database (etl_lab) | $DB |
| Products Table | $TABLE |
| Records Loaded | $COUNT |
| MiniETL.json | $TEMPLATE |
| Documentation | $DOCS |
| SQL Scripts | $SQL |
| Student Report | $REPORT |

## Manual Faculty Checklist

- [ ] InvokeHTTP configured
- [ ] SplitJson configured
- [ ] JoltTransformJSON configured
- [ ] UpdateRecord configured
- [ ] PutDatabaseRecord configured
- [ ] Controller Services enabled
- [ ] Data Provenance verified
- [ ] Pipeline executed successfully

Overall validation completed on $(date).
EOF

cat >"$TXT"<<EOF
Mini ETL Pipeline Validation Report

Generated: $(date)

Java            : $JAVA
PostgreSQL      : $POSTGRES
Apache NiFi     : $NIFI
REST API        : $API
Database        : $DB
Products Table  : $TABLE
Records Loaded  : $COUNT
MiniETL.json    : $TEMPLATE
Documentation   : $DOCS
SQL Scripts     : $SQL
Student Report  : $REPORT

Manual validation still required for processor configuration.
EOF

cat >"$HTML"<<EOF
<!DOCTYPE html>
<html><head><meta charset="utf-8">
<title>Pipeline Validation Report</title>
<style>
body{font-family:Arial;margin:40px}
table{border-collapse:collapse;width:90%}
th,td{border:1px solid #555;padding:8px}
th{background:#1f4e79;color:#fff}
.pass{color:green}.fail{color:red}
</style></head>
<body>
<h1>Mini ETL Pipeline Validation Report</h1>
<p><b>Generated:</b> $(date)</p>
<table>
<tr><th>Validation Item</th><th>Status</th></tr>
<tr><td>Java</td><td>$JAVA</td></tr>
<tr><td>PostgreSQL</td><td>$POSTGRES</td></tr>
<tr><td>Apache NiFi</td><td>$NIFI</td></tr>
<tr><td>REST API</td><td>$API</td></tr>
<tr><td>Database (etl_lab)</td><td>$DB</td></tr>
<tr><td>Products Table</td><td>$TABLE</td></tr>
<tr><td>Records Loaded</td><td>$COUNT</td></tr>
<tr><td>MiniETL.json</td><td>$TEMPLATE</td></tr>
<tr><td>Documentation</td><td>$DOCS</td></tr>
<tr><td>SQL Scripts</td><td>$SQL</td></tr>
<tr><td>Student Report</td><td>$REPORT</td></tr>
</table>
<h2>Faculty Manual Checklist</h2>
<ul>
<li>InvokeHTTP configured</li>
<li>SplitJson configured</li>
<li>JoltTransformJSON configured</li>
<li>UpdateRecord configured</li>
<li>PutDatabaseRecord configured</li>
<li>Controller Services enabled</li>
<li>Data Provenance verified</li>
<li>Pipeline executed successfully</li>
</ul>
</body></html>
EOF

echo "Pipeline validation reports generated:"
echo "  $MD"
echo "  $TXT"
echo "  $HTML"
echo "Log:"
echo "  $LOG"
