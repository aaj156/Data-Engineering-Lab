
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

# Step A4 : Verify PostgreSQL Service

## Command

```bash
systemctl status postgresql
```

### Expected Output

```text
Active: active (running)
```

### Decision

- ✅ If the PostgreSQL service is **active (running)**, continue to the next step.

- ⚠️ If the following message is displayed:

```text
System has not been booted with systemd as init system.
Can't operate.
Failed to connect to bus.
```

it indicates that **systemd is not managing services in the current WSL instance**.

In this case, verify PostgreSQL using:

```bash
sudo pg_ctlcluster 16 main status
```

If the cluster is not running, start it using:

```bash
sudo pg_ctlcluster 16 main start
```

Verify again:

```bash
sudo pg_ctlcluster 16 main status
```

### Expected Output

```text
pg_ctl: server is running
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
```sql
\l
```
No Database is presently available
---

## Step A7 : Set Password for the PostgreSQL Administrator Role

### Objective

Assign a password to the default **PostgreSQL administrator role (`postgres`)**. This password will be used later when connecting to PostgreSQL from applications such as **pgAdmin 4, Python, Apache NiFi, Apache Airflow, JDBC, and other database clients**.

> **Important**
>
> This command **does not change the Ubuntu (Linux) user's password**. It changes only the password of the **PostgreSQL database administrator role**.

### Command

```sql
ALTER ROLE postgres WITH PASSWORD 'siesgst';
```

### Expected Output

```text
ALTER ROLE
```
# 📦 Create New Database

```sql
CREATE DATABASE dataengineering;
```

---

# 📦 Create New User

```sql
CREATE USER deuser WITH PASSWORD '123';
CREATE ROLE student LOGIN PASSWORD '123';
```

---

# 📦 Grant Privileges

```sql
GRANT ALL PRIVILEGES ON DATABASE dataengineering TO deuser;
```
### List Existing PostgreSQL Roles

Execute the following PostgreSQL meta-command to display all existing roles (database users):

```bash
\du
```
---

# 📦 Connect to Database

```sql
\c dataengineering
```
---
This simply changes the current database while staying connected as the postgres role. It avoids the peer authentication issue during the installation exercise.

Note: Switching to another PostgreSQL role using \c database role may fail on Ubuntu/WSL because local connections typically use peer authentication, which requires the Linux username to match the PostgreSQL role. Client applications such as pgAdmin, Python, Apache NiFi, and Apache Airflow connect using TCP/IP (localhost:5432) and authenticate using the role's password instead.
---
Note

On Ubuntu/WSL, the command:
```sql
\c dataengineering deuser
```
may fail with:
FATAL: Peer authentication failed for user "deuser"
because local Unix socket connections use peer authentication, which requires the Linux username to match the PostgreSQL role name.

To authenticate using the password assigned to the PostgreSQL role, connect through TCP/IP (localhost).
Exit the PostgreSQL Interactive Terminal
If you are currently inside the PostgreSQL prompt (postgres=#), exit using:

\q
Command
Execute the following command from the Ubuntu Terminal:
```sql
psql -h localhost -U deuser -d dataengineering
```
Expected Output
The terminal prompts for the PostgreSQL password:
Password:
Enter the password assigned while creating the role (for example, 123).
After successful authentication, the PostgreSQL prompt appears:

dataengineering=>

### Verification

```sql
\conninfo
```

Expected Output

```text
You are connected to database "dataengineering"
```
---

# 📦 Create Sample Table

```sql
CREATE TABLE students(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    marks INT
);
```

---

# 📦 Insert Sample Records

```sql
INSERT INTO students(name, department, marks)
VALUES
('Amol','AIDS',95),
('Rahul','CE',85),
('Sneha','IT',90);
```

---

# 📦 Retrieve Records

```sql
SELECT * FROM students;
```

Expected Output

| id | name | department | marks |
|----|------|------------|-------|
| 1 | Akshay | AIDS | 90 |
| 2 | Rahul | AIDS | 85 |
| 3 | Sneha | AIDS | 95 |

---

# 📦 Exit the PostgreSQL prompt:

```sql
\q
```

Then reconnect using the `postgres` role or any other with appropriate password for that to verify the new password when prompted by a client application such as pgAdmin.
```sql
psql -h localhost -U postgres -d postgres
```
---

## Step A8 : Check Lab Database

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
```bash
cd /etc/postgresql/16/main/
```

# Edit only if remote access is required.
## For More information on these file read bellow but DONT OPEN or EDIT any CONFIGURSTION FILE
## PostgreSQL Configuration Files

PostgreSQL stores its server configuration in two important files:

```text
/etc/postgresql/16/main/postgresql.conf
/etc/postgresql/16/main/pg_hba.conf
```

### 1. `postgresql.conf`

This is the **main PostgreSQL server configuration file**.

It is used to configure server-level settings such as:

- Server listening address
- Port number
- Memory allocation
- Logging configuration
- Connection limits
- Performance tuning parameters

Open the file using:(DONT OPEN)

```bash
sudo nano /etc/postgresql/16/main/postgresql.conf
```

### Common Configuration Parameters

```text
listen_addresses = 'localhost'
port = 5432
max_connections = 100
```

> **Note:** For this experiment, the default configuration is sufficient. No changes are required.

---

### 2. `pg_hba.conf`

This file controls **client authentication** and determines **who can connect to PostgreSQL, from where, and using which authentication method**.

Open the file using:(DONT OPEN)

```bash
sudo nano /etc/postgresql/16/main/pg_hba.conf
```

Typical default entries:

```text
local   all             postgres                                peer
local   all             all                                     peer
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             ::1/128                 scram-sha-256
```

---

## When Should These Files Be Modified?

For this laboratory setup, PostgreSQL will be accessed locally from the same Ubuntu WSL environment.

Therefore, **no modifications are required**.

These configuration files should only be modified when:

- Allowing remote connections from another computer.
- Changing the default PostgreSQL port.
- Configuring a different authentication method.
- Optimizing PostgreSQL performance.
- Restricting or expanding client access.

---

## Decision

- ✅ **For this experiment:** Keep both configuration files unchanged.
- ⚠️ Modify these files only when remote access or advanced PostgreSQL configuration is required in later experiments.

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
