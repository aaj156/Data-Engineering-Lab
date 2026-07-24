#!/usr/bin/env bash
#==============================================================================
# 04_nifi_setup_final.sh
# Mini ETL Laboratory - Apache NiFi Final Installer
# Ubuntu 24.04 / WSL2
#==============================================================================

set -Eeuo pipefail

LAB_HOME="$HOME/Mini-ETL-NiFi-PostgreSQL"
SOFTWARE_DIR="$LAB_HOME/software"
LOG_DIR="$LAB_HOME/logs"

NIFI_VERSION="2.6.0"
NIFI_ZIP="nifi-${NIFI_VERSION}-bin.zip"
NIFI_URL="https://archive.apache.org/dist/nifi/${NIFI_VERSION}/${NIFI_ZIP}"
NIFI_HOME="$SOFTWARE_DIR/nifi"

JDBC_VERSION="42.7.7"
JDBC_JAR="postgresql-${JDBC_VERSION}.jar"
JDBC_URL="https://jdbc.postgresql.org/download/${JDBC_JAR}"

mkdir -p "$SOFTWARE_DIR" "$LOG_DIR"

LOGFILE="$LOG_DIR/nifi_setup_$(date +%F_%H-%M-%S).log"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOGFILE"; }
step(){ echo -e "${BLUE}[STEP]${NC} $*"; log "STEP: $*"; }
pass(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; exit 1; }

trap 'echo; warn "Installer stopped unexpectedly."; echo "See: $LOGFILE"' ERR

echo "============================================================"
echo " Mini ETL Laboratory - Apache NiFi Setup (FINAL)"
echo "============================================================"

step "Checking Java 21"

if command -v java >/dev/null; then
    JAVA_VER=$(java -version 2>&1 | head -1)
    if echo "$JAVA_VER" | grep -q '"21'; then
        pass "$JAVA_VER"
    else
        if [ -d /usr/lib/jvm/java-21-openjdk-amd64 ]; then
            export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
            export PATH=$JAVA_HOME/bin:$PATH
            pass "Activated Java 21"
        else
            fail "Java 21 not installed. Run 01_environment_setup.sh"
        fi
    fi
else
    fail "Java not installed."
fi

step "Checking internet"
curl -Is https://archive.apache.org >/dev/null
pass "Internet available"

mkdir -p "$SOFTWARE_DIR"
cd "$SOFTWARE_DIR"

if [ -d "$NIFI_HOME" ]; then
    pass "NiFi already installed"
else
    step "Downloading Apache NiFi $NIFI_VERSION"
    if [ ! -f "$NIFI_ZIP" ]; then
        wget -c "$NIFI_URL"
    else
        pass "Existing archive found"
    fi

    step "Extracting"
    unzip -oq "$NIFI_ZIP"

    DIR=$(find . -maxdepth 1 -type d -name "nifi-*bin" | head -1)
    mv "$DIR" nifi

    pass "NiFi extracted"
fi

cd "$SOFTWARE_DIR"

if [ ! -f "$JDBC_JAR" ]; then
    step "Downloading PostgreSQL JDBC Driver"
    wget -c "$JDBC_URL"
fi

cp -f "$JDBC_JAR" "$NIFI_HOME/lib/"
pass "JDBC driver copied"

step "Starting NiFi"

cd "$NIFI_HOME/bin"

./nifi.sh stop >/dev/null 2>&1 || true
sleep 3
./nifi.sh start

echo
echo "Waiting for NiFi..."
sleep 45

STATUS=$(./nifi.sh status 2>&1 || true)

echo "$STATUS"

if echo "$STATUS" | grep -q "Status: UP"; then
    pass "NiFi started successfully"
else
    warn "NiFi not yet fully ready"
fi

echo
step "Verification"

echo
echo "Listening ports:"
ss -lnt | grep 8443 || warn "8443 not listening yet"

echo
echo "Testing local endpoint"

if curl -ks https://localhost:8443/nifi/ >/dev/null; then
    pass "HTTPS endpoint reachable"
else
    warn "HTTPS endpoint not reachable yet"
fi

echo
echo "============================================================"
echo "NiFi Home"
echo "$NIFI_HOME"
echo
echo "Logs"
echo "$NIFI_HOME/logs"
echo
echo "Access URL"
echo "https://localhost:8443/nifi/"
echo
echo "If browser does not open:"
echo " 1. Wait 30-60 seconds."
echo " 2. Accept self-signed certificate."
echo " 3. Try another browser."
echo " 4. Verify using:"
echo "      ./nifi.sh status"
echo "      curl -k https://localhost:8443/nifi/"
echo
echo "Log File:"
echo "$LOGFILE"
echo "============================================================"
