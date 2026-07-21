#!/usr/bin/env bash
#==============================================================================
# Mini ETL using Apache NiFi & PostgreSQL
# Script : 04_nifi_setup.sh
# Purpose: Install Apache NiFi, JDBC Driver and verify NiFi
# Ubuntu 24.04 LTS (WSL2 / Native)
#==============================================================================

set -Eeuo pipefail

LAB_HOME="$HOME/Mini-ETL-NiFi-PostgreSQL"
SOFTWARE_DIR="$LAB_HOME/software"
LOG_DIR="$LAB_HOME/logs"

mkdir -p "$SOFTWARE_DIR" "$LOG_DIR"

LOG_FILE="$LOG_DIR/nifi_setup_$(date +%F_%H-%M-%S).log"

NIFI_VERSION="2.6.0"
JDBC_VERSION="42.7.7"

NIFI_ZIP="nifi-${NIFI_VERSION}-bin.zip"
NIFI_URL="https://archive.apache.org/dist/nifi/${NIFI_VERSION}/${NIFI_ZIP}"

JDBC_JAR="postgresql-${JDBC_VERSION}.jar"
JDBC_URL="https://jdbc.postgresql.org/download/${JDBC_JAR}"

NIFI_HOME="$SOFTWARE_DIR/nifi"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }
pass(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; exit 1; }
step(){ echo -e "${BLUE}[STEP]${NC} $*"; log "STEP: $*"; }

trap 'fail "Unexpected error on line $LINENO"' ERR

require_sudo(){ sudo -v; }

check_java(){
 step "Checking Java 21..."
 if java -version 2>&1 | grep -q '"21'; then
   pass "Java 21 detected"
 else
   fail "Java 21 is required. Run 01_environment_setup.sh first."
 fi
}

install_tools(){
 sudo apt-get update
 sudo apt-get install -y wget unzip curl
}

install_nifi(){
 if [ -d "$NIFI_HOME" ]; then
   pass "Apache NiFi already installed"
   return
 fi

 cd "$SOFTWARE_DIR"

 if [ ! -f "$NIFI_ZIP" ]; then
   step "Downloading Apache NiFi ${NIFI_VERSION}"
   wget -O "$NIFI_ZIP" "$NIFI_URL"
 fi

 step "Extracting NiFi..."
 unzip -q "$NIFI_ZIP"

 EXTRACTED=$(find . -maxdepth 1 -type d -name "nifi-*${NIFI_VERSION}*" | head -1)
 mv "$EXTRACTED" "$NIFI_HOME"

 pass "NiFi installed"
}

install_jdbc(){

 cd "$SOFTWARE_DIR"

 if [ ! -f "$JDBC_JAR" ]; then
   step "Downloading PostgreSQL JDBC Driver"
   wget -O "$JDBC_JAR" "$JDBC_URL"
 fi

 cp -f "$JDBC_JAR" "$NIFI_HOME/lib/"

 pass "JDBC Driver copied to NiFi lib"
}

start_nifi(){

 BIN=$(find "$NIFI_HOME" -name nifi.sh | head -1)

 if [ ! -x "$BIN" ]; then
   fail "nifi.sh not found"
 fi

 step "Starting Apache NiFi..."
 "$BIN" start

 sleep 25

 if curl -ks https://localhost:8443/nifi >/dev/null 2>&1; then
   pass "NiFi UI reachable (HTTPS)"
 elif curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
   pass "NiFi UI reachable (HTTP)"
 else
   warn "NiFi started but UI not reachable yet."
 fi
}

verify(){

echo
echo "=================================================="
echo "Apache NiFi Verification"
echo "=================================================="

printf "%-18s : %s\n" "Java" "$(java -version 2>&1 | head -1)"
printf "%-18s : %s\n" "NiFi Home" "$NIFI_HOME"

if [ -f "$NIFI_HOME/lib/$JDBC_JAR" ]; then
 pass "JDBC Driver Present"
else
 warn "JDBC Driver Missing"
fi

echo
echo "NiFi Logs:"
echo "  $NIFI_HOME/logs"

echo
echo "Default URL:"
echo "  https://localhost:8443/nifi"
echo "  (or http://localhost:8080/nifi depending on configuration)"

pass "Verification completed"

}

summary(){
cat <<EOF

============================================================
Apache NiFi Setup Completed

NiFi Home:
$NIFI_HOME

Log File:
$LOG_FILE

Next Step:
./05_workspace_setup.sh

============================================================

EOF
}

main(){

clear
echo "============================================================"
echo " Mini ETL Laboratory - Apache NiFi Setup"
echo "============================================================"

require_sudo
check_java
install_tools
install_nifi
install_jdbc
start_nifi
verify
summary

}

main
