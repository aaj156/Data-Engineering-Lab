# 🛠️ Module 09 – Troubleshooting & Best Practices

> **Experiment No. 2**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

Installing multiple Data Engineering tools on a single system often results in software conflicts, dependency issues, configuration errors, port conflicts, and service startup failures. Identifying and resolving these issues is an essential skill for every Data Engineer.

This module provides common troubleshooting techniques, diagnostic commands, and best practices for resolving issues related to PostgreSQL, pgAdmin 4, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Identify common installation and configuration errors.
- Diagnose service failures.
- Resolve dependency issues.
- Verify software installations.
- Analyze log files.
- Check network connectivity and port usage.
- Apply best practices for maintaining a stable Data Engineering environment.

---

# 🔍 General Troubleshooting Workflow

```text
Problem Detected
       │
       ▼
Read Error Message
       │
       ▼
Check Service Status
       │
       ▼
Check Logs
       │
       ▼
Verify Configuration
       │
       ▼
Restart Service
       │
       ▼
Verify Again
       │
       ▼
Issue Resolved
```

---

# 🧰 General Diagnostic Commands

| Command | Purpose |
|----------|---------|
| `systemctl status <service>` | Check service status |
| `journalctl -u <service>` | View service logs |
| `sudo ss -tulpn` | Check active ports |
| `df -h` | Check disk usage |
| `free -h` | Check memory usage |
| `top` | Monitor running processes |
| `ps aux` | List running processes |
| `ping google.com` | Test network connectivity |

---

# 🐘 PostgreSQL Troubleshooting

## Issue 1 – PostgreSQL Service Not Running

### Check Status

```bash
sudo systemctl status postgresql
```

### Start Service

```bash
sudo systemctl start postgresql
```

### Enable at Boot

```bash
sudo systemctl enable postgresql
```

---

## Issue 2 – Unable to Connect

### Verify Port

```bash
sudo ss -tulpn | grep 5432
```

### Restart PostgreSQL

```bash
sudo systemctl restart postgresql
```

---

## Issue 3 – Authentication Failed

Verify:

- Username
- Password
- Database Name
- Host
- Port Number

---

# 🖥️ pgAdmin Troubleshooting

## pgAdmin Cannot Connect

Verify PostgreSQL is running.

```bash
sudo systemctl status postgresql
```

---

## Incorrect Server Configuration

Check:

| Parameter | Value |
|-----------|-------|
| Host | localhost |
| Port | 5432 |
| Username | postgres |

---

## Password Incorrect

Reset PostgreSQL password if required.

---

# 🌊 Apache NiFi Troubleshooting

## NiFi Not Starting

Check status

```bash
./nifi.sh status
```

View logs

```bash
tail -f /opt/nifi/logs/nifi-app.log
```

---

## JAVA_HOME Not Configured

```bash
echo $JAVA_HOME
```

Configure

```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
```

---

## Web UI Not Accessible

Verify

```bash
sudo ss -tulpn | grep 8443
```

Restart

```bash
./nifi.sh restart
```

---

# 🌬️ Apache Airflow Troubleshooting

## airflow Command Not Found

Activate virtual environment

```bash
source ~/DataEngineeringLab/venv/bin/activate
```

---

## Scheduler Not Running

```bash
airflow scheduler
```

---

## Webserver Not Accessible

```bash
airflow api-server
```

Open

```text
http://localhost:8080
```

---

## Metadata Database Error

```bash
airflow db migrate
```

---

# 🔍 Elasticsearch Troubleshooting

## Elasticsearch Not Starting

View logs

```bash
tail -f /opt/elasticsearch/logs/*.log
```

---

## Check Cluster Health

```bash
curl http://localhost:9200/_cluster/health?pretty
```

---

## Port Already in Use

```bash
sudo ss -tulpn | grep 9200
```

---

## Java Version Problem

```bash
java -version
```

Install latest OpenJDK if required.

---

# 📊 Kibana Troubleshooting

## Kibana Not Opening

Verify port

```bash
sudo ss -tulpn | grep 5601
```

---

## Elasticsearch Connection Failed

Verify

```bash
curl http://localhost:9200
```

---

## Check Configuration

```bash
nano /opt/kibana/config/kibana.yml
```

Verify

```yaml
elasticsearch.hosts:
```

---

## View Logs

```bash
tail -f /opt/kibana/logs/*
```

---

# 🌐 Port Verification

| Service | Default Port |
|----------|-------------|
| PostgreSQL | 5432 |
| Apache Airflow | 8080 |
| Apache NiFi | 8443 |
| Elasticsearch | 9200 |
| Kibana | 5601 |

Check

```bash
sudo ss -tulpn
```

---

# 💾 Resource Monitoring

## Memory

```bash
free -h
```

---

## CPU

```bash
top
```

---

## Disk Usage

```bash
df -h
```

---

# 📂 Useful Log Locations

| Service | Log Location |
|----------|--------------|
| PostgreSQL | `/var/log/postgresql/` |
| Apache NiFi | `/opt/nifi/logs/` |
| Apache Airflow | `~/airflow/logs/` |
| Elasticsearch | `/opt/elasticsearch/logs/` |
| Kibana | `/opt/kibana/logs/` |

---

# 🔧 Service Management Commands

## PostgreSQL

```bash
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
```

---

## Apache NiFi

```bash
./nifi.sh start
./nifi.sh stop
./nifi.sh restart
./nifi.sh status
```

---

## Apache Airflow

```bash
airflow scheduler
airflow api-server
```

---

## Elasticsearch

```bash
./elasticsearch
```

---

## Kibana

```bash
./kibana
```

---

# 💡 Best Practices

- Keep Ubuntu updated.
- Always use the latest stable software versions.
- Install Java before NiFi and Elasticsearch.
- Use Python Virtual Environments for Airflow.
- Backup configuration files before editing.
- Monitor system logs regularly.
- Verify services after every installation.
- Avoid changing default ports unless necessary.
- Restart services after configuration changes.
- Maintain separate project databases.

---

# 📋 Troubleshooting Checklist

| Check | Status |
|--------|--------|
| Internet Connection | ☐ |
| Java Installed | ☐ |
| Python Installed | ☐ |
| PostgreSQL Running | ☐ |
| pgAdmin Connected | ☐ |
| NiFi Running | ☐ |
| Airflow Running | ☐ |
| Elasticsearch Running | ☐ |
| Kibana Running | ☐ |
| Required Ports Available | ☐ |

---

# 📝 Observation Table

| Issue | Cause | Solution | Status |
|-------|-------|----------|--------|
| | | | |
| | | | |
| | | | |

---

# 🎯 Result

Common installation and configuration issues were successfully identified and resolved using system logs, service management commands, configuration verification, and diagnostic tools. The Data Engineering infrastructure is now stable and ready for executing ETL pipelines and subsequent laboratory experiments.

---

# 📖 Summary

Troubleshooting is a critical skill in Data Engineering. This module introduced systematic techniques for diagnosing and resolving issues across PostgreSQL, pgAdmin 4, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana. By understanding logs, service management, network ports, and configuration files, students can efficiently maintain a reliable Data Engineering environment.

---

# 📚 References

1. PostgreSQL Documentation  
   https://www.postgresql.org/docs/

2. Apache NiFi Documentation  
   https://nifi.apache.org/docs/

3. Apache Airflow Documentation  
   https://airflow.apache.org/docs/

4. Elasticsearch Documentation  
   https://www.elastic.co/guide/

5. Kibana Documentation  
   https://www.elastic.co/guide/en/kibana/current/

---

# 📚 Next Module

➡ **10-Viva.md**

Viva Questions, Interview Questions, Assignments, and Practical Exercises on Building Data Engineering Infrastructure.
