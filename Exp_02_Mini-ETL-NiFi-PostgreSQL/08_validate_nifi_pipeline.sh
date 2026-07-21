#!/usr/bin/env bash
#==============================================================================
# validate_nifi_pipeline.sh
# Mini ETL Laboratory - Apache NiFi Pipeline Validator
# Validates the student's ETL pipeline and environment.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="$HOME/Mini-ETL-NiFi-PostgreSQL"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"
NIFI_HOME="$PROJECT_ROOT/software/nifi"
REPORT="$REPORT_DIR/pipeline_validation_report.md"
LOG="$LOG_DIR/pipeline_validation.log"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

PASS=0; WARN=0; FAIL=0

pass(){ echo -e "${GREEN}[PASS]${NC} $1"; echo "[PASS] $1" >> "$LOG"; PASS=$((PASS+1)); }
warn(){ echo -e "${YELLOW}[WARN]${NC} $1"; echo "[WARN] $1" >> "$LOG"; WARN=$((WARN+1)); }
fail(){ echo -e "${RED}[FAIL]${NC} $1"; echo "[FAIL] $1" >> "$LOG"; FAIL=$((FAIL+1)); }

echo "Mini ETL Pipeline Validation - $(date)" > "$LOG"

echo "======================================================="
echo " Mini ETL Laboratory - Pipeline Validator"
echo "======================================================="

echo "Checking Java..."
java -version >/dev/null 2>&1 && pass "Java available" || fail "Java missing"

echo "Checking PostgreSQL..."
if sudo -u postgres psql -d etl_lab -c "SELECT 1;" >/dev/null 2>&1; then
    pass "PostgreSQL reachable"
else
    fail "Cannot connect to PostgreSQL"
fi

echo "Checking products table..."
if sudo -u postgres psql -d etl_lab -tAc "SELECT to_regclass('public.products');" | grep -q products; then
    pass "products table exists"
else
    fail "products table missing"
fi

echo "Checking JDBC Driver..."
if ls "$NIFI_HOME"/lib/postgresql-*.jar >/dev/null 2>&1; then
    pass "PostgreSQL JDBC driver present"
else
    fail "JDBC driver missing"
fi

echo "Checking NiFi installation..."
[ -d "$NIFI_HOME" ] && pass "NiFi installed" || fail "NiFi not installed"

echo "Checking NiFi Web UI..."
if curl -ks https://localhost:8443/nifi >/dev/null 2>&1; then
    pass "NiFi HTTPS UI reachable"
elif curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
    pass "NiFi HTTP UI reachable"
else
    warn "NiFi UI not reachable"
fi

echo "Checking REST API..."
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)
[[ "$STATUS" == "200" ]] && pass "REST API reachable" || fail "REST API unavailable"

echo "Checking SQL scripts..."
for f in create_database.sql create_tables.sql sample_queries.sql; do
    [ -f "$PROJECT_ROOT/sql/$f" ] && pass "$f found" || warn "$f missing"
done

echo "Checking exported NiFi template..."
if [ -f "$PROJECT_ROOT/nifi-template/MiniETL.json" ]; then
    if python3 -m json.tool "$PROJECT_ROOT/nifi-template/MiniETL.json" >/dev/null 2>&1; then
        pass "MiniETL.json present and valid JSON"
    else
        warn "MiniETL.json exists but is not valid JSON"
    fi
else
    warn "MiniETL.json not found (export after completing the flow)"
fi

echo "Checking screenshots..."
for d in screenshots reports output; do
    [ -d "$PROJECT_ROOT/$d" ] && pass "$d directory exists" || warn "$d directory missing"
done

echo "Checking database records..."
COUNT=$(sudo -u postgres psql -d etl_lab -tAc "SELECT COUNT(*) FROM products;" 2>/dev/null || echo 0)
if [[ "$COUNT" =~ ^[0-9]+$ ]] && [ "$COUNT" -gt 0 ]; then
    pass "$COUNT records found in products table"
else
    warn "No records found. Execute the NiFi pipeline."
fi

cat > "$REPORT" <<EOF
# Mini ETL Pipeline Validation Report

Generated: $(date)

| Check | Status |
|------|--------|
| Java | $( [ $PASS -ge 0 ] && echo Checked ) |
| PostgreSQL | Checked |
| NiFi Installation | Checked |
| JDBC Driver | Checked |
| REST API | Checked |
| SQL Scripts | Checked |
| Database Records | Checked |
| NiFi Template | Checked |

## Summary

- PASS : $PASS
- WARN : $WARN
- FAIL : $FAIL

## Manual Validation (Faculty)

- [ ] InvokeHTTP configured correctly
- [ ] SplitJson configured correctly
- [ ] JoltTransformJSON specification verified
- [ ] UpdateRecord transformations verified
- [ ] PutDatabaseRecord configuration verified
- [ ] Controller Services enabled
- [ ] Data Provenance inspected
- [ ] MiniETL.json reviewed

## Recommendation

If WARN/FAIL entries exist:
1. Review the corresponding chapter in the lab manual.
2. Run etl_repair_and_validate.sh if environment issues are detected.
3. Re-run this validator after corrections.
EOF

echo
echo "======================================================="
echo "Validation Summary"
echo "PASS : $PASS"
echo "WARN : $WARN"
echo "FAIL : $FAIL"
echo
echo "Report: $REPORT"
echo "======================================================="
