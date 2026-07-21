#!/usr/bin/env bash
#==============================================================================
# etl_repair_and_validate.sh
#
# Intelligent Repair & Validation Script
# Mini ETL using Apache NiFi and PostgreSQL
# Ubuntu 24.04 / WSL2
#
# Repairs common configuration issues and validates the ETL environment.
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="$HOME/Mini-ETL-NiFi-PostgreSQL"
NIFI_HOME="$PROJECT_ROOT/software/nifi"
SQL_DIR="$PROJECT_ROOT/sql"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

REPORT="$REPORT_DIR/etl_repair_report.md"
LOG="$LOG_DIR/etl_repair_$(date +%F_%H-%M-%S).log"

DB_NAME="etl_lab"
DB_USER="etluser"
DB_PASS="etl@123"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PASS=0
REPAIR=0
WARN=0
FAIL=0

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG"; }

pass(){ echo -e "${GREEN}[PASS]${NC} $1"; log "PASS: $1"; PASS=$((PASS+1)); }

repair(){ echo -e "${BLUE}[REPAIR]${NC} $1"; log "REPAIR: $1"; REPAIR=$((REPAIR+1)); }

warn(){ echo -e "${YELLOW}[WARN]${NC} $1"; log "WARN: $1"; WARN=$((WARN+1)); }

fail(){ echo -e "${RED}[FAIL]${NC} $1"; log "FAIL: $1"; FAIL=$((FAIL+1)); }

step(){
echo
echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}$1${NC}"
echo -e "${BLUE}====================================================${NC}"
log "$1"
}

require_root(){
if [ "$EUID" -ne 0 ]; then
echo "Please run:"
echo "sudo bash etl_repair_and_validate.sh"
exit 1
fi
}

check_java(){

step "Checking Java"

if command -v java >/dev/null; then

VER=$(java -version 2>&1 | head -1)

echo "$VER"

if echo "$VER" | grep -q "21"; then
pass "Java 21 detected"
else
repair "Installing Java 21"
apt-get update -y
apt-get install -y openjdk-21-jdk
fi

else

repair "Java missing. Installing..."
apt-get update -y
apt-get install -y openjdk-21-jdk

fi

}

check_postgresql(){

step "Checking PostgreSQL"

if ! command -v psql >/dev/null; then
repair "Installing PostgreSQL..."
apt-get install -y postgresql postgresql-contrib
fi

systemctl enable postgresql >/dev/null 2>&1 || true
systemctl start postgresql || service postgresql start || true

if sudo -u postgres psql -c "SELECT 1;" >/dev/null 2>&1; then
pass "PostgreSQL running"
else
fail "Unable to start PostgreSQL"
fi

}

check_database(){

step "Checking Database"

if ! sudo -u postgres psql -lqt | cut -d \| -f1 | grep -qw "$DB_NAME"; then

repair "Creating database"

if [ -f "$SQL_DIR/create_database.sql" ]; then
sudo -u postgres psql -f "$SQL_DIR/create_database.sql"
else
sudo -u postgres createdb "$DB_NAME"
fi

fi

pass "Database available"

}

check_table(){

step "Checking products table"

TABLE=$(sudo -u postgres psql -d "$DB_NAME" -tAc "SELECT to_regclass('public.products');" 2>/dev/null || true)

if [ "$TABLE" != "products" ]; then

repair "Creating products table"

if [ -f "$SQL_DIR/create_tables.sql" ]; then
sudo -u postgres psql -d "$DB_NAME" -f "$SQL_DIR/create_tables.sql"
else
warn "create_tables.sql not found"
fi

else

pass "products table exists"

fi

}

check_pgadmin(){

step "Checking pgAdmin"

if command -v pgadmin4 >/dev/null; then
pass "pgAdmin installed"
else
warn "pgAdmin not installed"
fi

}

check_nifi(){

step "Checking Apache NiFi"

if [ ! -d "$NIFI_HOME" ]; then
fail "NiFi directory not found"
return
fi

pass "NiFi directory exists"

if [ -x "$NIFI_HOME/bin/nifi.sh" ]; then

"$NIFI_HOME/bin/nifi.sh" status >/dev/null 2>&1 || true

if ! curl -ks https://localhost:8443/nifi >/dev/null 2>&1 && \
   ! curl -s http://localhost:8080/nifi >/dev/null 2>&1
then
repair "Starting NiFi"
"$NIFI_HOME/bin/nifi.sh" start || true
sleep 15
fi

fi

if curl -ks https://localhost:8443/nifi >/dev/null 2>&1 || \
   curl -s http://localhost:8080/nifi >/dev/null 2>&1
then
pass "NiFi UI reachable"
else
warn "NiFi UI not reachable"
fi

}

check_jdbc(){

step "Checking PostgreSQL JDBC Driver"

if ls "$NIFI_HOME"/lib/postgresql-*.jar >/dev/null 2>&1; then
pass "JDBC Driver found"
else
warn "JDBC Driver missing"
fi

}

check_rest(){

step "Checking REST API"

CODE=$(curl -s -o /dev/null -w "%{http_code}" https://fakestoreapi.com/products || true)

if [ "$CODE" = "200" ]; then
pass "REST API reachable"
else
warn "REST API unavailable (HTTP $CODE)"
fi

}

check_workspace(){

step "Checking Workspace"

for d in docs sql dataset screenshots reports output logs nifi-template
do
if [ ! -d "$PROJECT_ROOT/$d" ]; then
repair "Creating directory: $d"
mkdir -p "$PROJECT_ROOT/$d"
fi
done

pass "Workspace verified"

}

check_template(){

step "Checking NiFi Template"

if [ -f "$PROJECT_ROOT/nifi-template/MiniETL.json" ]; then
pass "MiniETL.json found"
else
warn "MiniETL.json not exported yet"
fi

}

generate_report(){

cat > "$REPORT" <<EOF
# ETL Repair and Validation Report

Generated: $(date)

| Item | Result |
|------|--------|
| PASS | $PASS |
| REPAIRED | $REPAIR |
| WARN | $WARN |
| FAIL | $FAIL |

## Environment

- Java
- PostgreSQL
- Database
- Products Table
- pgAdmin
- Apache NiFi
- JDBC Driver
- REST API
- Workspace
- NiFi Template

## Recommendation

If WARN items remain:

- Complete the missing manual configuration.
- Build the NiFi ETL flow.
- Export MiniETL.json.
- Re-run this script.
EOF

}

summary(){

echo
echo "======================================================"
echo " Mini ETL Repair Summary"
echo "======================================================"
echo "PASS     : $PASS"
echo "REPAIRED : $REPAIR"
echo "WARN     : $WARN"
echo "FAIL     : $FAIL"
echo
echo "Report:"
echo "$REPORT"
echo "======================================================"

}

main(){

require_root
check_java
check_postgresql
check_database
check_table
check_pgadmin
check_nifi
check_jdbc
check_rest
check_workspace
check_template
generate_report
summary

}

main
