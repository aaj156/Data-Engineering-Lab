#!/usr/bin/env bash
#==============================================================================
# 03_pgadmin_setup_v4.sh
# Intelligent pgAdmin Installer & Recovery (WSL/Desktop/Server)
# Version 4.0
#==============================================================================

set -Eeuo pipefail

LAB_HOME="${HOME}/Mini-ETL-NiFi-PostgreSQL"
LOG_DIR="$LAB_HOME/logs"
REPORT_DIR="$LAB_HOME/reports"
mkdir -p "$LOG_DIR" "$REPORT_DIR"

STAMP=$(date +%F_%H-%M-%S)
LOG="$LOG_DIR/pgadmin_setup_v4_$STAMP.log"
MD="$REPORT_DIR/pgadmin_setup_report.md"
TXT="$REPORT_DIR/pgadmin_setup_report.txt"
HTML="$REPORT_DIR/pgadmin_setup_report.html"

EMAIL="admin@etl.local"
PASSWORD="ETL@123"

G='\033[0;32m';Y='\033[1;33m';R='\033[0;31m';B='\033[0;34m';N='\033[0m'
step(){ echo -e "${B}[STEP]${N} $*"; echo "[$(date '+%F %T')] $*"|tee -a "$LOG"; }
ok(){ echo -e "${G}[PASS]${N} $*"; echo "PASS: $*" >>"$LOG"; }
warn(){ echo -e "${Y}[WARN]${N} $*"; echo "WARN: $*" >>"$LOG"; }
die(){ echo -e "${R}[FAIL]${N} $*"; echo "FAIL: $*" >>"$LOG"; exit 1; }

trap 'die "Unexpected error at line $LINENO"' ERR

sudo -v

detect_env(){
 if grep -qi microsoft /proc/version; then ENV=WSL;
 elif [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then ENV=DESKTOP;
 else ENV=SERVER; fi
 ok "Environment: $ENV"
}

repair_system(){
 step "Repairing package manager"

 sudo dpkg --configure -a || true

 if dpkg -l | grep -Eq '^(ii|iF|iU|rc)\s+pgadmin4-desktop'; then
   warn "Removing pgadmin4-desktop"
   sudo dpkg --remove --force-remove-reinstreq pgadmin4-desktop || true
   sudo apt purge -y pgadmin4-desktop || true
 fi

 for p in pgadmin4-server pgadmin4 pgadmin4-web; do
   if dpkg -l | grep -Eq "^(ii|iF|iU|rc)\s+$p"; then
      warn "Purging $p"
      sudo apt purge -y "$p" || true
   fi
 done

 sudo apt --fix-broken install -y || true
 sudo apt autoremove -y || true
 sudo apt autoclean -y || true

 ok "Package manager repaired"
}

configure_repo(){
 step "Configuring repository"
 sudo apt-get update
 sudo apt-get install -y curl ca-certificates gnupg

 if [ ! -f /etc/apt/sources.list.d/pgadmin4.list ]; then
   sudo install -d /usr/share/keyrings
   curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | \
    sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
   echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/noble pgadmin4 main" | \
   sudo tee /etc/apt/sources.list.d/pgadmin4.list >/dev/null
   sudo apt-get update
 fi
 ok "Repository configured"
}

install_pgadmin(){
 if [ "$ENV" = "DESKTOP" ]; then
   step "Installing Desktop edition"
   sudo apt-get install -y pgadmin4-desktop
   command -v pgadmin4 >/dev/null
   URL="Desktop Application"
 else
   step "Installing Web edition"
   sudo DEBIAN_FRONTEND=noninteractive apt-get install -y pgadmin4-web
   if [ -x /usr/pgadmin4/bin/setup-web.sh ]; then
      sudo /usr/pgadmin4/bin/setup-web.sh --yes \
      --email "$EMAIL" --password "$PASSWORD" || true
   fi
   sudo systemctl restart apache2 2>/dev/null || sudo service apache2 restart || true
   URL="http://localhost/pgadmin4"
 fi
 ok "pgAdmin installation completed"
}

verify(){
 step "Verifying installation"
 if [ "$ENV" != "DESKTOP" ]; then
   if curl -Is "$URL" >/dev/null 2>&1; then
      ok "Web interface reachable"
   else
      warn "Could not verify web interface automatically"
   fi
 fi
}

reports(){
cat >"$MD"<<EOF
# pgAdmin Setup Report

Generated: $(date)

Environment: $ENV

Edition: $( [ "$ENV" = DESKTOP ] && echo Desktop || echo Web )

URL: $URL

Credentials:
- Email: $EMAIL
- Password: $PASSWORD

Log: $LOG
EOF

cat >"$TXT"<<EOF
pgAdmin Setup Report

Environment: $ENV
Edition: $( [ "$ENV" = DESKTOP ] && echo Desktop || echo Web )
URL: $URL
Email: $EMAIL
Password: $PASSWORD

Log: $LOG
EOF

cat >"$HTML"<<EOF
<!DOCTYPE html><html><head><meta charset="utf-8"><title>pgAdmin Report</title>
<style>body{font-family:Arial;margin:40px}table{border-collapse:collapse}td,th{border:1px solid #555;padding:8px}th{background:#1f4e79;color:#fff}</style>
</head><body>
<h1>pgAdmin Setup Report</h1>
<table>
<tr><th>Item</th><th>Value</th></tr>
<tr><td>Environment</td><td>$ENV</td></tr>
<tr><td>Edition</td><td>$( [ "$ENV" = DESKTOP ] && echo Desktop || echo Web )</td></tr>
<tr><td>URL</td><td>$URL</td></tr>
<tr><td>Email</td><td>$EMAIL</td></tr>
<tr><td>Generated</td><td>$(date)</td></tr>
</table>
</body></html>
EOF
ok "Reports generated"
}

clear
echo "=============================================================="
echo " Mini ETL Laboratory - pgAdmin Setup v4.0"
echo "=============================================================="

detect_env
repair_system
configure_repo
install_pgadmin
verify
reports

echo
echo "=============================================================="
echo "Setup completed."
echo "URL      : $URL"
echo "Reports  : $REPORT_DIR"
echo "Next     : bash 04_nifi_setup.sh"
echo "=============================================================="
