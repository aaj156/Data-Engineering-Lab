#!/usr/bin/env bash
#==============================================================================
# Mini ETL using Apache NiFi & PostgreSQL
# Script : 02_postgresql_setup.sh
# Purpose: Install and configure PostgreSQL for the ETL Lab
# Compatible: Ubuntu 24.04 (WSL2 / Native)
# Safe to re-run (Idempotent)
#==============================================================================

set -Eeuo pipefail

LAB_HOME="$HOME/Mini-ETL-NiFi-PostgreSQL"
SQL_DIR="$LAB_HOME/sql"
LOG_DIR="$LAB_HOME/logs"
mkdir -p "$SQL_DIR" "$LOG_DIR"

LOG_FILE="$LOG_DIR/postgresql_setup_$(date +%F_%H-%M-%S).log"

DB_NAME="etl_lab"
DB_USER="etluser"
DB_PASS="etl@123"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }
pass(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; exit 1; }
step(){ echo -e "${BLUE}[STEP]${NC} $*"; log "STEP: $*"; }

trap 'fail "Unexpected error on line $LINENO"' ERR

require_sudo(){ sudo -v; }

install_postgresql(){
    if command -v psql >/dev/null 2>&1; then
        pass "$(psql --version)"
    else
        step "Installing PostgreSQL..."
        sudo apt-get update
        sudo apt-get install -y postgresql postgresql-contrib
        pass "PostgreSQL installed"
    fi
}

start_service(){
    step "Starting PostgreSQL service..."
    sudo systemctl enable postgresql >/dev/null 2>&1 || true
    sudo systemctl start postgresql >/dev/null 2>&1 || true

    if sudo -u postgres psql -c "SELECT version();" >/dev/null 2>&1; then
        pass "PostgreSQL service is running"
    else
        fail "Unable to connect to PostgreSQL"
    fi
}

generate_sql(){
step "Generating SQL scripts..."

cat > "$SQL_DIR/create_database.sql" <<EOF
DO \$\$
BEGIN
 IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='$DB_USER') THEN
   CREATE ROLE $DB_USER LOGIN PASSWORD '$DB_PASS';
 END IF;
END
\$\$;

SELECT 'CREATE DATABASE $DB_NAME OWNER $DB_USER'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname='$DB_NAME')\gexec
EOF

cat > "$SQL_DIR/create_tables.sql" <<'EOF'
CREATE TABLE IF NOT EXISTS products(
 product_id INTEGER PRIMARY KEY,
 title VARCHAR(255),
 price NUMERIC(10,2),
 description TEXT,
 category VARCHAR(100),
 image_url TEXT,
 rating NUMERIC(3,2),
 rating_count INTEGER,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_products_category
ON products(category);

CREATE INDEX IF NOT EXISTS idx_products_price
ON products(price);
EOF

cat > "$SQL_DIR/sample_queries.sql" <<'EOF'
SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 10;
SELECT category,COUNT(*) FROM products GROUP BY category;
EOF

pass "SQL scripts ready"
}

configure_database(){
step "Creating database and user..."
sudo -u postgres psql -f "$SQL_DIR/create_database.sql"

step "Creating products table..."
sudo -u postgres psql -d "$DB_NAME" -f "$SQL_DIR/create_tables.sql"

pass "Database configured"
}

verify(){
step "Verifying configuration..."

echo "-------------------------------------------"
printf "%-18s : %s\n" "PostgreSQL" "$(psql --version)"
printf "%-18s : %s\n" "Database" "$DB_NAME"
printf "%-18s : %s\n" "User" "$DB_USER"
echo "-------------------------------------------"

TABLE=$(sudo -u postgres psql -d "$DB_NAME" -tAc "SELECT to_regclass('public.products');")

if [[ "$TABLE" == "products" ]]; then
    pass "products table exists"
else
    fail "products table missing"
fi

echo
echo "Current Tables:"
sudo -u postgres psql -d "$DB_NAME" -c "\dt"

echo
echo "Indexes:"
sudo -u postgres psql -d "$DB_NAME" -c "SELECT indexname FROM pg_indexes WHERE tablename='products';"

pass "Verification completed"
}

summary(){
cat <<EOF

============================================================
PostgreSQL Setup Completed

Database : $DB_NAME
User     : $DB_USER

SQL Files Generated:
  $SQL_DIR/create_database.sql
  $SQL_DIR/create_tables.sql
  $SQL_DIR/sample_queries.sql

Log File:
  $LOG_FILE

Next Step:
  ./03_pgadmin_setup.sh

============================================================

EOF
}

main(){
clear
echo "============================================================"
echo " Mini ETL Laboratory - PostgreSQL Setup"
echo "============================================================"

require_sudo
install_postgresql
start_service
generate_sql
configure_database
verify
summary
}

main
