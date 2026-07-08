# 🧪 Module 08 – Testing & Verification of Data Engineering Infrastructure

> **Experiment No. __**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

After installing all Data Engineering tools, it is essential to verify that each software component is functioning correctly and can communicate with other services. Infrastructure testing ensures that the environment is stable and ready for developing ETL pipelines, workflow orchestration, database management, search, and visualization.

This module provides a systematic approach to testing the complete Data Engineering infrastructure by verifying PostgreSQL, pgAdmin 4, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Verify successful installation of all software components.
- Test service availability.
- Check communication between applications.
- Validate database connectivity.
- Verify web interfaces.
- Test a simple data pipeline.
- Identify and troubleshoot configuration issues.

---

# 🏗️ Infrastructure Testing Workflow

```text
                 Ubuntu System
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
 PostgreSQL       Apache NiFi     Apache Airflow
        │               │                │
        └───────────────┼────────────────┘
                        ▼
                Elasticsearch
                        │
                        ▼
                    Kibana
                        │
                        ▼
             Complete Infrastructure
                        │
                        ▼
              Ready for Data Pipeline
```

---

# 📝 Testing Checklist

| Component | Status |
|-----------|--------|
| Ubuntu | ☐ |
| Java | ☐ |
| Python | ☐ |
| PostgreSQL | ☐ |
| pgAdmin 4 | ☐ |
| Apache NiFi | ☐ |
| Apache Airflow | ☐ |
| Elasticsearch | ☐ |
| Kibana | ☐ |

---

# ✅ Test 1 – Verify Java

```bash
java -version
```

Expected Output

```text
openjdk version "21"
```

---

# ✅ Test 2 – Verify Python

```bash
python3 --version
```

Expected Output

```text
Python 3.12.x
```

---

# ✅ Test 3 – Verify PostgreSQL

Check Version

```bash
psql --version
```

Check Service

```bash
sudo systemctl status postgresql
```

Connect

```bash
sudo -u postgres psql
```

List Databases

```sql
\l
```

Exit

```sql
\q
```

---

# ✅ Test 4 – Verify pgAdmin 4

Launch pgAdmin.

Verify:

- Login successful
- PostgreSQL server connected
- Database visible
- Query Tool opens successfully

Run

```sql
SELECT version();
```

Expected

```
PostgreSQL 17.x
```

---

# ✅ Test 5 – Verify Apache NiFi

Navigate

```bash
cd /opt/nifi/bin
```

Check Status

```bash
./nifi.sh status
```

Open Browser

```text
https://localhost:8443/nifi
```

Verify

- Login successful
- Canvas loads
- Processors available

---

# ✅ Test 6 – Verify NiFi Data Flow

Create Flow

```text
GenerateFlowFile

↓

PutFile
```

Destination

```text
~/nifi-output
```

Run Flow

Verify

```bash
ls ~/nifi-output
```

Expected

```
Generated File
```

---

# ✅ Test 7 – Verify Apache Airflow

Activate Environment

```bash
source ~/DataEngineeringLab/venv/bin/activate
```

Check Version

```bash
airflow version
```

Start Scheduler

```bash
airflow scheduler
```

Start Webserver/API Server

```bash
airflow api-server
```

Open Browser

```text
http://localhost:8080
```

Verify

- Login successful
- DAG List available
- Example DAGs displayed

---

# ✅ Test 8 – Verify Elasticsearch

Check Version

```bash
curl http://localhost:9200
```

Check Cluster Health

```bash
curl http://localhost:9200/_cluster/health?pretty
```

Expected

```json
status : green
```

---

# ✅ Test 9 – Verify Kibana

Open Browser

```text
http://localhost:5601
```

Verify

- Home Page loads
- Elasticsearch connected
- Data View available
- Discover page accessible

---

# ✅ Test 10 – Verify Network Ports

```bash
sudo ss -tulpn
```

Expected Ports

| Service | Port |
|----------|------|
| PostgreSQL | 5432 |
| Airflow | 8080 |
| NiFi | 8443 |
| Elasticsearch | 9200 |
| Kibana | 5601 |

---

# ✅ Test 11 – Verify Running Services

```bash
systemctl status postgresql
```

```bash
systemctl status elasticsearch
```

NiFi

```bash
./nifi.sh status
```

---

# 🔄 End-to-End Infrastructure Test

```text
CSV File

↓

Apache NiFi

↓

PostgreSQL

↓

Apache Airflow

↓

Elasticsearch

↓

Kibana Dashboard
```

Expected Outcome

- All services start successfully.
- Data flows without errors.
- Dashboards display indexed data.

---

# ⚡ Useful Verification Commands

| Command | Purpose |
|----------|----------|
| java -version | Verify Java |
| python3 --version | Verify Python |
| psql --version | PostgreSQL Version |
| airflow version | Airflow Version |
| ./nifi.sh status | NiFi Status |
| curl localhost:9200 | Elasticsearch |
| curl localhost:9200/_cluster/health | Cluster Health |
| ss -tulpn | Active Ports |

---

# ⚠️ Common Issues

## PostgreSQL Not Running

```bash
sudo systemctl start postgresql
```

---

## NiFi Not Accessible

```bash
./nifi.sh restart
```

Check

```bash
tail -f /opt/nifi/logs/nifi-app.log
```

---

## Airflow Login Issue

Create user again

```bash
airflow users create
```

---

## Elasticsearch Not Starting

Check logs

```bash
tail -f /opt/elasticsearch/logs/*.log
```

---

## Kibana Cannot Connect

Verify

```bash
curl http://localhost:9200
```

Restart Kibana

---

# 💡 Best Practices

- Start PostgreSQL before Airflow.
- Ensure Elasticsearch starts before Kibana.
- Verify Java before starting NiFi.
- Use Python Virtual Environment for Airflow.
- Keep all services updated.
- Regularly check service logs.

---

# 📋 Final Verification Checklist

| Test | Status |
|------|--------|
| Java Installed | ☐ |
| Python Installed | ☐ |
| PostgreSQL Running | ☐ |
| pgAdmin Connected | ☐ |
| NiFi Running | ☐ |
| Airflow Running | ☐ |
| Elasticsearch Running | ☐ |
| Kibana Running | ☐ |
| All Ports Open | ☐ |
| Infrastructure Ready | ☐ |

---

# 📝 Observation Table

| Activity | Status | Remarks |
|-----------|--------|---------|
| Java Verified | | |
| PostgreSQL Verified | | |
| pgAdmin Verified | | |
| NiFi Verified | | |
| Airflow Verified | | |
| Elasticsearch Verified | | |
| Kibana Verified | | |
| End-to-End Test Successful | | |

---

# 🎯 Result

All infrastructure components were successfully installed, configured, and tested. PostgreSQL, pgAdmin 4, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana were verified to be operational and accessible. The complete Data Engineering environment is now ready for developing, orchestrating, storing, searching, and visualizing data pipelines.

---

# 📖 Summary

In this module, students performed comprehensive testing of the complete Data Engineering infrastructure. Each software component was verified individually and as part of an integrated ecosystem. Successful completion of these tests confirms that the environment is ready for subsequent laboratory experiments involving data ingestion, ETL pipelines, orchestration, database operations, search, and analytics.

---

# 📚 References

1. Apache NiFi Documentation  
   https://nifi.apache.org/docs/

2. Apache Airflow Documentation  
   https://airflow.apache.org/docs/

3. PostgreSQL Documentation  
   https://www.postgresql.org/docs/

4. Elasticsearch Documentation  
   https://www.elastic.co/guide/

5. Kibana Documentation  
   https://www.elastic.co/guide/en/kibana/current/

---

# 📚 Next Module

➡ **09-Troubleshooting.md**

Common Installation Issues, Error Messages, Solutions, and Best Practices for Data Engineering Infrastructure.
