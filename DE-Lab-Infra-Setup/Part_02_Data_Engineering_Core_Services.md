
# Part 02 – Data Engineering Core Services

> **Prerequisite:** Complete **Part 01 – WSL, Ubuntu 24.04, Initial Configuration, Java 21 & Python Setup** successfully before starting.

---

# Sections

1. Section A – PostgreSQL Installation
2. Section B – pgAdmin 4 Installation
3. Section C – Apache NiFi Installation
4. Final Verification & Report Generation

---

# Section A – PostgreSQL Installation

## Objective

Install and configure PostgreSQL on Ubuntu 24.04 running under WSL.

---

## Step A1 : Update Package Repository

### Command

```bash
sudo apt update
```

### Expected Output

Package list updated successfully.

### Verification

```bash
apt policy postgresql
```

### Decision

Continue only if package information is displayed.

---

## Step A2 : Install PostgreSQL

```bash
sudo apt install -y postgresql postgresql-contrib
```

### Expected Output

Installation completed without errors.

### Verification

```bash
psql --version
```

Expected:

```text
psql (PostgreSQL) 16.x
```

---

## Step A3 : Verify Cluster

```bash
pg_lsclusters
```

### Expected Output

```text
Ver Cluster Port Status Owner
16  main    5432 online postgres
```

### Decision

- ✅ If **Status = online**, continue to the next step.
- ⚠️ If **Status = down**, start the cluster:

```bash
sudo pg_ctlcluster 16 main start
```

Verify again:

```bash
pg_lsclusters
```

- ❌ If no cluster is listed, create the default cluster:

```bash
sudo pg_createcluster 16 main
sudo pg_ctlcluster 16 main start
```

Then verify again using:

```bash
pg_lsclusters
```

---

## Step A4 : Verify Service

```bash
systemctl status postgresql
```

If systemd is unavailable in WSL:

```bash
sudo pg_ctlcluster 16 main status
```

---

## Step A5 : Switch to postgres User

```bash
sudo -i -u postgres
```

Expected prompt:

```text
postgres@hostname:~$
```

---

## Step A6 : Open PostgreSQL

```bash
psql
```

Expected

```text
postgres=#
```

---

## Step A7 : Change postgres Password

```sql
ALTER USER postgres PASSWORD 'your_password';
```

---

## Step A8 : Create Lab Database

```sql
CREATE DATABASE dataeng_lab;
```

Verify

```sql
\l
```

---

## Step A9 : Exit

```sql
\q
exit
```

---

## Configuration Files

```text
/etc/postgresql/16/main/postgresql.conf
/etc/postgresql/16/main/pg_hba.conf
```

Edit only if remote access is required.

---

# Section B – pgAdmin 4 Installation

## Step B1 : Install Repository Tools

```bash
sudo apt install -y curl ca-certificates gnupg
```

---

## Step B2 : Add pgAdmin Repository

(Use the latest official repository instructions before installation if package versions change.)

```bash
curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | \
sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
```

```bash
echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/ubuntu noble pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin4.list
```

---

## Step B3

```bash
sudo apt update
sudo apt install -y pgadmin4-web
```

---

## Step B4

```bash
sudo /usr/pgadmin4/bin/setup-web.sh
```

Provide email and password.

---

## Verification

Open

```text
http://localhost/pgadmin4
```

Login successfully.

Add server:

Host

```text
localhost
```

Port

```text
5432
```

Database

```text
postgres
```

Username

```text
postgres
```

---

# Section C – Apache NiFi Installation

## Step C1

Download Apache NiFi Binary.

---

## Step C2

```bash
cd ~/software
```

Extract

```bash
tar -xzf nifi-*.tar.gz
```

Move

```bash
sudo mv nifi-* /opt/nifi
```

---

## Step C3

```bash
sudo chown -R $USER:$USER /opt/nifi
```

---

## Step C4

Open

```bash
nano ~/.bashrc
```

Append

```bash
export NIFI_HOME=/opt/nifi
export PATH=$NIFI_HOME/bin:$PATH
```

Reload

```bash
source ~/.bashrc
```

Verify

```bash
echo $NIFI_HOME
```

Expected

```text
/opt/nifi
```

---

## Step C5

Start NiFi

```bash
$NIFI_HOME/bin/nifi.sh start
```

Status

```bash
$NIFI_HOME/bin/nifi.sh status
```

Stop

```bash
$NIFI_HOME/bin/nifi.sh stop
```

Logs

```bash
tail -f $NIFI_HOME/logs/nifi-app.log
```

---

## Browser Verification

Open

```text
https://localhost:8443/nifi
```

Login if configured.

---

## Troubleshooting

### Port Already in Use

```bash
sudo lsof -i :8443
```

---

### Java Not Found

```bash
echo $JAVA_HOME
java -version
```

---

### PostgreSQL Not Running

```bash
sudo pg_ctlcluster 16 main start
```

---

# Final Verification

Run

```bash
psql --version
java -version
python3 --version
echo $NIFI_HOME
```

Confirm all commands execute successfully.

---

# Generate Configuration Report

Run

```bash
~/reports/generate_report.sh
```

Enter:

- Student Name
- Roll Number
- Batch
- Experiment Number
- Experiment Title
- Remarks

Verify that the generated report is saved under:

```text
~/reports
```

---

# Part 02 Status

Installation Status : ☐ Completed

Verified By : ______________________

Date : _____________________________

Remarks : __________________________
