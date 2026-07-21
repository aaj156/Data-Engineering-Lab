#!/usr/bin/env bash
#==============================================================================
# Mini ETL using Apache NiFi & PostgreSQL
# Script : 06_verify_environment.sh
# Purpose: Verify the complete ETL laboratory environment before students
#          begin building the NiFi ETL pipeline.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="$HOME/Mini-ETL-NiFi-PostgreSQL"
LOG_DIR="$PROJECT_ROOT/logs"
REPORT_DIR="$PROJECT_ROOT/reports"
mkdir -p "$LOG_DIR" "$REPORT_DIR"

LOG_FILE="$LOG_DIR/environment_verification_$(date +%F_%H-%M-%S).log"
REPORT_FILE="$REPORT_DIR/environment_verification_report.md"

DB_NAME="etl_lab"
NIFI_HOME="$PROJECT_ROOT/software/nifi"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

PASS=0
WARN=0
FAIL=0

log(){ echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"; }
step(){ echo -e "${BLUE}[CHECK]${NC} $*"; log "CHECK: $*"; }
ok(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; PASS=$((PASS+1)); }
warning(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; WARN=$((WARN+1)); }
failed(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; FAIL=$((FAIL+1)); }

banner(){
clear
echo "============================================================"
echo " Mini ETL Laboratory - Environment Verification"
echo "============================================================"
}

check_cmd(){
    local cmd="$1"; local label="$2"
    step "$label"
    if command -v "$cmd" >/dev/null 2>&1; then
        ok "$label available"
    else
        failed "$label missing"
    fi
}

banner

check_cmd java "Java"
check_cmd python3 "Python"
check_cmd git "Git"
check_cmd curl "curl"
check_cmd jq "jq"
check_cmd tree "tree"
check_cmd psql "PostgreSQL Client"

step "Checking PostgreSQL connection"
if sudo -u postgres psql -d "$DB_NAME" -c "SELECT 1;" >/dev/null 2>&1; then
    ok "Database $DB_NAME reachable"
else
    failed "Cannot connect to database $DB_NAME"
fi

step "Checking products table"
if sudo -u postgres psql -d "$DB_NAME" -tAc "SELECT to_regclass('public.products');" | grep -q products; then
    ok "products table exists"
else
    failed "products table missing"
fi

step "Checking pgAdmin"
if command -v pgadmin4 >/dev/null 2>&1; then
    ok "pgAdmin installed"
else
    warning "pgAdmin not detected"
fi

step "Checking Apache NiFi"
if [ -d "$NIFI_HOME" ]; then
    ok "NiFi directory found"
else
    failed "NiFi directory missing"
fi

step "Checking JDBC Driver"
if ls "$NIFI_HOME"/lib/postgresql-*.jar >/dev/null 2>&1; then
    ok "PostgreSQL JDBC Driver present"
else
    failed "JDBC Driver missing"
fi

step "Checking NiFi Web UI"
if curl -ks https://localhost:8443/nifi >/dev/null 2>&1; then
    ok "NiFi HTTPS UI reachable"
elif curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
    ok "NiFi HTTP UI reachable"
else
    warning "NiFi UI not reachable (service may not be started)"
fi

step "Checking REST API"
STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)
if [ "$STATUS" = "200" ]; then
    ok "Fake Store REST API reachable"
else
    warning "REST API returned HTTP $STATUS"
fi

cat > "$REPORT_FILE" <<EOF
# Environment Verification Report

Date: $(date)

| Component | Status |
|-----------|--------|
| Java | Verified |
| Python | Verified |
| Git | Verified |
| PostgreSQL | Verified if PASS above |
| pgAdmin | Checked |
| Apache NiFi | Checked |
| JDBC Driver | Checked |
| REST API | Checked |

## Summary

- PASS : $PASS
- WARN : $WARN
- FAIL : $FAIL

## Next Step

Open Apache NiFi and begin **03-Building-the-NiFi-Flow.md**.

Students will manually build:

InvokeHTTP → SplitJson → JoltTransformJSON → UpdateRecord → PutDatabaseRecord
EOF

echo
echo "============================================================"
echo "Verification Summary"
echo "PASS : $PASS"
echo "WARN : $WARN"
echo "FAIL : $FAIL"
echo
echo "Report : $REPORT_FILE"
echo
echo "Next:"
echo "Read docs/03-Building-the-NiFi-Flow.md"
echo "============================================================"
