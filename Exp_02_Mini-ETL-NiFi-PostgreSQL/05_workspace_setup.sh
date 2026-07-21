#!/usr/bin/env bash
#==============================================================================
# Mini ETL using Apache NiFi & PostgreSQL
# Script : 05_workspace_setup.sh
# Purpose: Create and validate the Mini ETL laboratory workspace
# Compatible: Ubuntu 24.04 (WSL2 / Native)
# Safe to re-run (Idempotent)
#==============================================================================

set -Eeuo pipefail

PROJECT_ROOT="$HOME/Mini-ETL-NiFi-PostgreSQL"
LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/workspace_setup_$(date +%F_%H-%M-%S).log"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }
pass(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; exit 1; }
step(){ echo -e "${BLUE}[STEP]${NC} $*"; log "STEP: $*"; }

trap 'fail "Unexpected error on line $LINENO"' ERR

create_dir() {
    local d="$1"
    mkdir -p "$PROJECT_ROOT/$d"
    touch "$PROJECT_ROOT/$d/.gitkeep"
    pass "Directory ready: $d"
}

banner() {
clear
cat <<EOF
============================================================
 Mini ETL Laboratory - Workspace Setup
============================================================
EOF
}

check_prerequisites() {
    step "Checking previous setup..."

    command -v java >/dev/null || fail "Java not found. Run 01_environment_setup.sh"

    command -v psql >/dev/null || fail "PostgreSQL not found. Run 02_postgresql_setup.sh"

    [ -d "$PROJECT_ROOT/software/nifi" ] || \
        warn "NiFi directory not found. Run 04_nifi_setup.sh"

    pass "Prerequisite check completed"
}

create_structure() {
    step "Creating project structure..."

    create_dir docs
    create_dir sql
    create_dir dataset
    create_dir images
    create_dir screenshots
    create_dir reports
    create_dir output
    create_dir logs
    create_dir software
    create_dir nifi-template

    pass "Workspace structure created"
}

generate_readme() {

if [ ! -f "$PROJECT_ROOT/README.md" ]; then

cat > "$PROJECT_ROOT/README.md" <<'EOF'
# Mini ETL using Apache NiFi and PostgreSQL

This workspace is generated automatically.

Experiment Flow

REST API
    ↓
InvokeHTTP
    ↓
SplitJson
    ↓
JoltTransformJSON
    ↓
UpdateRecord
    ↓
PutDatabaseRecord
    ↓
PostgreSQL
EOF

pass "README.md created"

fi

}

permissions() {
step "Setting permissions..."
chmod -R u+rwX "$PROJECT_ROOT"
pass "Permissions updated"
}

show_tree() {

echo
echo "Workspace Structure"
echo "------------------------------------------------------------"

if command -v tree >/dev/null 2>&1; then
    tree -L 2 "$PROJECT_ROOT"
else
    find "$PROJECT_ROOT" -maxdepth 2
fi

echo "------------------------------------------------------------"

}

summary(){

cat <<EOF

============================================================
Workspace Setup Completed

Project Root
$PROJECT_ROOT

Folders Created

✔ docs

✔ sql

✔ dataset

✔ images

✔ screenshots

✔ reports

✔ output

✔ logs

✔ software

✔ nifi-template

Log File

$LOG_FILE

Next Step

./06_verify_environment.sh

============================================================

EOF

}

main(){

banner
check_prerequisites
create_structure
generate_readme
permissions
show_tree
summary

}

main
