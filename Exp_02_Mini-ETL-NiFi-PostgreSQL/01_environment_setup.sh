#!/usr/bin/env bash
#==============================================================================
# Mini ETL using Apache NiFi & PostgreSQL
# Script : 01_environment_setup.sh
# Purpose: Prepare Ubuntu 24.04 for the ETL laboratory
# Safe to re-run (idempotent)
#==============================================================================

set -Eeuo pipefail

LAB_HOME="$HOME/Mini-ETL-NiFi-PostgreSQL"
LOG_DIR="$LAB_HOME/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/environment_setup_$(date +%F_%H-%M-%S).log"

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; NC='\033[0m'

log(){ echo "[$(date '+%F %T')] $*" | tee -a "$LOG_FILE"; }
pass(){ echo -e "${GREEN}[PASS]${NC} $*"; log "PASS: $*"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $*"; log "WARN: $*"; }
fail(){ echo -e "${RED}[FAIL]${NC} $*"; log "FAIL: $*"; exit 1; }
step(){ echo -e "${BLUE}[STEP]${NC} $*"; log "STEP: $*"; }

trap 'fail "Unexpected error on line $LINENO"' ERR

require_sudo() {
  sudo -v
}

check_os() {
  step "Checking Ubuntu version..."
  if grep -q "24.04" /etc/os-release; then
    pass "Ubuntu 24.04 detected"
  else
    warn "Designed for Ubuntu 24.04 (continuing)"
  fi
}

check_wsl() {
  step "Checking execution environment..."
  if grep -qi microsoft /proc/version; then
    pass "Running under WSL2"
  else
    pass "Running on native Linux"
  fi
}

check_internet() {
  step "Checking Internet connectivity..."
  ping -c1 8.8.8.8 >/dev/null 2>&1 && pass "Internet available" || fail "No Internet connection"
}

check_resources() {
  step "Checking system resources..."
  echo "Disk:"
  df -h "$HOME"
  echo
  echo "Memory:"
  free -h
  pass "Resource information displayed"
}

install_pkg() {
  local pkg="$1"
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    pass "$pkg already installed"
  else
    step "Installing $pkg"
    sudo apt-get install -y "$pkg"
    pass "$pkg installed"
  fi
}

install_packages() {
  step "Updating package index..."
  sudo apt-get update

  local pkgs=(
    openjdk-21-jdk
    python3 python3-pip python3-venv
    git curl wget jq tree zip unzip
    nano vim
    build-essential
    software-properties-common
  )

  for p in "${pkgs[@]}"; do
    install_pkg "$p"
  done
}

configure_java() {
  step "Configuring JAVA_HOME..."
  JAVA_HOME_PATH="/usr/lib/jvm/java-21-openjdk-amd64"

  if ! grep -q "JAVA_HOME" "$HOME/.bashrc"; then
    {
      echo ""
      echo "# Mini ETL Laboratory"
      echo "export JAVA_HOME=$JAVA_HOME_PATH"
      echo 'export PATH=$JAVA_HOME/bin:$PATH'
    } >> "$HOME/.bashrc"
  fi

  export JAVA_HOME="$JAVA_HOME_PATH"
  export PATH="$JAVA_HOME/bin:$PATH"

  pass "JAVA_HOME configured"
}

verify_versions() {
  step "Verifying installed software..."
  echo "--------------------------------------------------"
  printf "%-18s : %s\n" "Java"    "$(java -version 2>&1 | head -1)"
  printf "%-18s : %s\n" "Python"  "$(python3 --version)"
  printf "%-18s : %s\n" "Git"     "$(git --version)"
  printf "%-18s : %s\n" "curl"    "$(curl --version | head -1)"
  printf "%-18s : %s\n" "jq"      "$(jq --version)"
  printf "%-18s : %s\n" "tree"    "$(tree --version | head -1)"
  echo "--------------------------------------------------"
  pass "Environment verification completed"
}

summary() {
cat <<EOF

============================================================
Environment Setup Completed

Project Home : $LAB_HOME
Log File     : $LOG_FILE

Next Step:
    ./02_postgresql_setup.sh

============================================================

EOF
}

main() {
  clear
  echo "============================================================"
  echo " Mini ETL Laboratory - Environment Setup"
  echo "============================================================"

  require_sudo
  check_os
  check_wsl
  check_internet
  check_resources
  install_packages
  configure_java
  verify_versions
  summary
}

main
