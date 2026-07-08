# 🐘 Module 02 – PostgreSQL Installation & Configuration

> **Experiment No. 2**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

PostgreSQL is one of the world's most popular **open-source Relational Database Management Systems (RDBMS)**. It is widely used in modern Data Engineering, Data Science, and Enterprise applications due to its reliability, extensibility, SQL compliance, and advanced support for structured and semi-structured data.

In a Data Engineering environment, PostgreSQL is commonly used as:

- Operational Database (OLTP)
- Metadata Database (Apache Airflow)
- Data Warehouse (Small to Medium Scale)
- Staging Database
- Reporting Database
- Analytical SQL Engine

In this module, you will install PostgreSQL on Ubuntu Linux, configure the database server, create users and databases, and verify that the installation is functioning correctly.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Understand PostgreSQL architecture.
- Install PostgreSQL on Ubuntu.
- Start and manage PostgreSQL services.
- Create database users and roles.
- Create databases.
- Connect using the PostgreSQL command-line interface.
- Perform basic SQL operations.
- Verify PostgreSQL installation.
- Understand how PostgreSQL integrates into a Data Engineering pipeline.

---

# 🧠 Why PostgreSQL?

Data Engineers need a reliable relational database for storing structured data and metadata.

PostgreSQL is preferred because it offers:

- Open Source
- ACID Compliance
- Advanced SQL Support
- High Performance
- Extensibility
- JSON & JSONB Support
- Spatial Data Support (PostGIS)
- Strong Community Support
- Excellent Integration with Data Engineering Tools

---

# 🏗 PostgreSQL Architecture

```text
                 Client Applications
        ┌─────────────────────────────┐
        │ psql │ pgAdmin │ Python │ BI │
        └─────────────────────────────┘
                     │
                     ▼
            PostgreSQL Server
        ┌─────────────────────────────┐
        │ Roles │ Databases │ Schemas │
        │ Tables │ Indexes │ Views    │
        └─────────────────────────────┘
                     │
                     ▼
              Linux File System
```

---

# 💡 PostgreSQL in Data Engineering

```text
CSV Files
     │
     ▼
Apache NiFi
     │
     ▼
PostgreSQL Database
     │
     ▼
Apache Airflow
     │
     ▼
Analytics / Dashboards
```

---

# 📦 Step 1 – Update Package Repository

## Objective

Ensure the package repository contains the latest software information.

### Command

```bash
sudo apt update
```

### Explanation

Refreshes the Ubuntu package index before installing PostgreSQL.

---

# 📦 Step 2 – Install PostgreSQL

> **Recommended Version:** PostgreSQL 17 (Latest Stable)

### Command

```bash
sudo apt install postgresql postgresql-contrib -y
```

### Explanation

- `postgresql` installs the PostgreSQL server.
- `postgresql-contrib` installs additional extensions and utilities.

---

# 📦 Step 3 – Verify Installation

```bash
psql --version
```

Expected Output

```text
psql (PostgreSQL) 17.x
```

---

# 📦 Step 4 – Check PostgreSQL Service

```bash
sudo systemctl status postgresql
```

Expected Output

```text
Active: active (running)
```

---

# 📦 Step 5 – Start PostgreSQL Service

```bash
sudo systemctl start postgresql
```

---

# 📦 Step 6 – Enable PostgreSQL at Boot

```bash
sudo systemctl enable postgresql
```

---

# 📦 Step 7 – Switch to PostgreSQL User

```bash
sudo -i -u postgres
```

---

# 📦 Step 8 – Open PostgreSQL Shell

```bash
psql
```

Expected Prompt

```text
postgres=#
```

---

# 📦 Step 9 – List Existing Databases

```sql
\l
```

---

# 📦 Step 10 – Create New Database

```sql
CREATE DATABASE dataengineering;
```

---

# 📦 Step 11 – Create New User

```sql
CREATE USER deuser WITH PASSWORD 'password123';
```

---

# 📦 Step 12 – Grant Privileges

```sql
GRANT ALL PRIVILEGES ON DATABASE dataengineering TO deuser;
```

---

# 📦 Step 13 – Connect to Database

```sql
\c dataengineering
```

---

# 📦 Step 14 – Create Sample Table

```sql
CREATE TABLE students(
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    marks INT
);
```

---

# 📦 Step 15 – Insert Sample Records

```sql
INSERT INTO students(name, department, marks)
VALUES
('Akshay','AIDS',90),
('Rahul','AIDS',85),
('Sneha','AIDS',95);
```

---

# 📦 Step 16 – Retrieve Records

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

# 📦 Step 17 – Exit PostgreSQL

```sql
\q
```

---

# 🔍 Verification Commands

```bash
psql --version

sudo systemctl status postgresql

sudo systemctl is-enabled postgresql
```

---

# 📋 Important PostgreSQL Commands

| Command | Description |
|----------|-------------|
| `\l` | List Databases |
| `\dt` | List Tables |
| `\du` | List Roles |
| `\c dbname` | Connect to Database |
| `\q` | Exit PostgreSQL |
| `\d table` | Describe Table |
| `SELECT version();` | PostgreSQL Version |

---

# ⚠ Common Errors

## PostgreSQL Service Not Running

```bash
sudo systemctl start postgresql
```

---

## Permission Denied

```bash
sudo -i -u postgres
```

---

## Port Already in Use

Check Port

```bash
sudo ss -tulpn | grep 5432
```

---

## Cannot Connect

Restart Service

```bash
sudo systemctl restart postgresql
```

---

# 📝 Observation Table

| Activity | Status | Remarks |
|-----------|--------|---------|
| PostgreSQL Installed | | |
| Service Started | | |
| Service Enabled | | |
| Database Created | | |
| User Created | | |
| Table Created | | |
| Records Inserted | | |
| Data Retrieved | | |

---

# 🎯 Result

PostgreSQL was successfully installed and configured on Ubuntu Linux. A new database, user, and sample table were created, sample data was inserted, and SQL queries were executed successfully. PostgreSQL is now ready for integration with Apache NiFi, Apache Airflow, and pgAdmin in subsequent modules.

---

# 💡 Best Practices

- Use strong passwords for database users.
- Create separate databases for different projects.
- Regularly back up databases.
- Restrict remote access unless required.
- Grant only the required privileges to users.

---

# 📚 Summary

In this module, PostgreSQL was installed, configured, and verified as the relational database component of the Data Engineering infrastructure. Students learned how to manage PostgreSQL services, create databases and users, execute SQL commands, and validate the installation. This database will serve as the central relational storage system for upcoming experiments involving Apache NiFi, Apache Airflow, and data ingestion workflows.

---

# 📚 Next Module

➡ **03-pgAdmin4.md**  
Installing and Configuring pgAdmin 4
