#!/usr/bin/env bash
set -Eeuo pipefail

LAB_HOME="$HOME/Mini-ETL-NiFi-PostgreSQL"
SOFTWARE_DIR="$LAB_HOME/software"
LOG_DIR="$LAB_HOME/logs"
REPORT_DIR="$LAB_HOME/reports"

mkdir -p "$SOFTWARE_DIR" "$LOG_DIR" "$REPORT_DIR"

LOG="$LOG_DIR/nifi_setup_v2_$(date +%F_%H-%M-%S).log"

NIFI_VERSION="2.6.0"
NIFI_HOME="$SOFTWARE_DIR/nifi"
NIFI_ZIP="nifi-${NIFI_VERSION}-bin.zip"
NIFI_URL="https://archive.apache.org/dist/nifi/${NIFI_VERSION}/${NIFI_ZIP}"

JDBC_VERSION="42.7.7"
JDBC_JAR="postgresql-${JDBC_VERSION}.jar"
JDBC_URL="https://jdbc.postgresql.org/download/${JDBC_JAR}"

step(){ echo "[STEP] $*"; }
ok(){ echo "[PASS] $*"; }
warn(){ echo "[WARN] $*"; }
die(){ echo "[FAIL] $*"; exit 1; }

sudo -v

step "Checking Java 21"

if ! java -version 2>&1 | grep -q '"21'; then
    if [ -x /usr/lib/jvm/java-21-openjdk-amd64/bin/java ]; then
        warn "Switching default Java to OpenJDK 21"
        sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java || true
        [ -x /usr/lib/jvm/java-21-openjdk-amd64/bin/javac ] && \
        sudo update-alternatives --set javac /usr/lib/jvm/java-21-openjdk-amd64/bin/javac || true
    else
        step "Installing OpenJDK 21"
        sudo apt-get update
        sudo apt-get install -y openjdk-21-jdk
    fi

    export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
    export PATH="$JAVA_HOME/bin:$PATH"

    grep -q "Mini ETL Java Configuration" ~/.bashrc 2>/dev/null || cat >> ~/.bashrc <<'EOF'

# Mini ETL Java Configuration
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
EOF
fi

java -version 2>&1 | grep -q '"21' || die "Java 21 is still not active."
ok "$(java -version 2>&1 | head -1)"

sudo apt-get update
sudo apt-get install -y wget unzip curl

cd "$SOFTWARE_DIR"

if [ ! -d "$NIFI_HOME" ]; then
    [ -f "$NIFI_ZIP" ] || wget -O "$NIFI_ZIP" "$NIFI_URL"
    unzip -oq "$NIFI_ZIP"
    DIR=$(find . -maxdepth 1 -type d -name "nifi-*${NIFI_VERSION}*" | head -1)
    mv "$DIR" "$NIFI_HOME"
fi
ok "NiFi installed"

[ -f "$JDBC_JAR" ] || wget -O "$JDBC_JAR" "$JDBC_URL"
cp -f "$JDBC_JAR" "$NIFI_HOME/lib/"
ok "JDBC driver copied"

BIN=$(find "$NIFI_HOME" -name nifi.sh | head -1)
[ -x "$BIN" ] || die "nifi.sh not found"

"$BIN" start || true
sleep 30

URL="Not reachable"
if curl -ks https://localhost:8443/nifi >/dev/null 2>&1; then
 URL="https://localhost:8443/nifi"
elif curl -s http://localhost:8080/nifi >/dev/null 2>&1; then
 URL="http://localhost:8080/nifi"
fi

cat > "$REPORT_DIR/nifi_setup_report.md" <<EOF
# NiFi Setup Report

Generated: $(date)

Java:
$(java -version 2>&1 | head -1)

JAVA_HOME:
${JAVA_HOME:-Not Set}

NiFi:
$NIFI_HOME

URL:
$URL
EOF

cp "$REPORT_DIR/nifi_setup_report.md" "$REPORT_DIR/nifi_setup_report.txt"

cat > "$REPORT_DIR/nifi_setup_report.html" <<EOF
<html><body><h1>NiFi Setup Report</h1>
<p>Generated: $(date)</p>
<p>Java: $(java -version 2>&1 | head -1)</p>
<p>JAVA_HOME: ${JAVA_HOME:-Not Set}</p>
<p>NiFi: $NIFI_HOME</p>
<p>URL: $URL</p>
</body></html>
EOF

ok "Reports generated"

echo
echo "Setup Complete"
echo "NiFi URL: $URL"
echo "Next: bash 05_workspace_setup.sh"
