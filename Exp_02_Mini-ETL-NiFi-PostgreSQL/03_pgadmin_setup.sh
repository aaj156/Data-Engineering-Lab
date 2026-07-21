#!/usr/bin/env bash
#==============================================================================
# Mini ETL using Apache NiFi & PostgreSQL
# Script : 03_pgadmin_setup.sh
# Purpose: Install and verify pgAdmin 4 Desktop
# Ubuntu 24.04 LTS (WSL2 / Native)
#==============================================================================

set -Eeuo pipefail

LAB_HOME="$HOME/Mini-ETL-NiFi-PostgreSQL"
LOG_DIR="$LAB_HOME/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/pgadmin_setup_$(date +%F_%H-%M-%S).log"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }
pass(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; exit 1; }
step(){ echo -e "${BLUE}[STEP]${NC} $*"; log "STEP: $*"; }

trap 'fail "Unexpected error on line $LINENO"' ERR

require_sudo(){ sudo -v; }

already_installed(){
    command -v pgadmin4 >/dev/null 2>&1
}

install_dependencies(){
    step "Installing prerequisite packages..."
    sudo apt-get update
    sudo apt-get install -y curl ca-certificates gnupg
    pass "Prerequisites installed"
}

add_repository(){
    if [ -f /etc/apt/sources.list.d/pgadmin4.list ]; then
        pass "pgAdmin repository already configured"
        return
    fi

    step "Adding official pgAdmin repository..."

    sudo install -d /usr/share/keyrings

    curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub \
    | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

    echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/noble pgadmin4 main" \
    | sudo tee /etc/apt/sources.list.d/pgadmin4.list >/dev/null

    sudo apt-get update

    pass "Repository configured"
}

install_pgadmin(){
    if already_installed; then
        pass "pgAdmin already installed"
        return
    fi

    step "Installing pgAdmin 4 Desktop..."
    sudo apt-get install -y pgadmin4-desktop

    if already_installed; then
        pass "pgAdmin installed successfully"
    else
        fail "pgAdmin installation failed"
    fi
}

verify(){
    step "Verifying installation..."

    if already_installed; then
        pass "Executable: $(command -v pgadmin4)"
    else
        fail "pgAdmin executable not found"
    fi

    echo
    echo "Installed package:"
    dpkg -l | grep pgadmin4 || true

    echo
    echo "=================================================="
    echo "To launch pgAdmin:"
    echo
    echo "  pgadmin4"
    echo
    echo "Then create a new PostgreSQL server:"
    echo "  Host     : localhost"
    echo "  Port     : 5432"
    echo "  Database : etl_lab"
    echo "  Username : etluser"
    echo "  Password : etl@123"
    echo "=================================================="

    pass "Verification completed"
}

summary(){
cat <<EOF

============================================================
pgAdmin Setup Completed

Log File:
$LOG_FILE

Next Step:
./04_nifi_setup.sh

============================================================

EOF
}

main(){
clear
echo "============================================================"
echo " Mini ETL Laboratory - pgAdmin Setup"
echo "============================================================"

require_sudo
install_dependencies
add_repository
install_pgadmin
verify
summary
}

main
