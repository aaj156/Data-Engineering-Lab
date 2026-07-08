# 🌊 Module 04 – Apache NiFi Installation & Configuration

> **Experiment No. 2**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

Apache NiFi is an open-source data integration and workflow automation platform that enables Data Engineers to build reliable, scalable and real-time data pipelines using a graphical drag-and-drop interface.

---

# 🎯 Objectives

- Install and configure Apache NiFi
- Configure Java environment
- Launch NiFi Web UI
- Understand Processors, FlowFiles and Connections
- Build a simple data flow
- Verify generated output

---

# 🧠 Why Apache NiFi?

- Data Ingestion
- ETL/ELT Pipelines
- Workflow Automation
- Data Routing
- Real-Time Streaming
- System Integration

---

# 🏗️ Architecture

```text
Data Source
    │
    ▼
Processor → Connection → Processor
    │
    ▼
 FlowFile Queue
    │
    ▼
Destination
```

---

# 🔑 Core Components

| Component | Description |
|-----------|-------------|
| FlowFile | Data moving through NiFi |
| Processor | Executes tasks |
| Connection | Transfers FlowFiles |
| Process Group | Organizes workflows |
| Controller Service | Shared services |
| Provenance | FlowFile history |

---

# ⚙️ Prerequisites

- Ubuntu 24.04
- OpenJDK 21
- 4 GB RAM
- Internet Connection

---

# Step 1 – Verify Java

```bash
java -version
```

---

# Step 2 – Download NiFi

Official Website

https://nifi.apache.org/download.html

Example

```bash
wget https://downloads.apache.org/nifi/latest/apache-nifi-2.0.0-bin.zip
```

---

# Step 3 – Extract

```bash
unzip apache-nifi-2.0.0-bin.zip
sudo mv apache-nifi-2.0.0 /opt/nifi
```

---

# Step 4 – Configure JAVA_HOME

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

---

# Step 5 – Start NiFi

```bash
cd /opt/nifi/bin
./nifi.sh start
./nifi.sh status
```

Stop

```bash
./nifi.sh stop
```

---

# Step 6 – Access Web UI

Open

```text
https://localhost:8443/nifi
```

Retrieve initial credentials

```bash
grep -i "Generated Username\|Generated Password" /opt/nifi/logs/nifi-app.log
```

---

# Step 7 – Create First Data Flow

Add Processor

```
GenerateFlowFile
```

Set Custom Text

```
Hello from Apache NiFi
```

Add Processor

```
PutFile
```

Destination Directory

```
/home/<username>/nifi-output
```

Connect

```
GenerateFlowFile
      │
      ▼
    PutFile
```

Relationship

```
success
```

Start both processors.

---

# Step 8 – Verify Output

```bash
ls ~/nifi-output
cat ~/nifi-output/*
```

Expected

```text
Hello from Apache NiFi
```

---

# 📁 Directory Structure

```text
/opt/nifi/
├── bin
├── conf
├── lib
├── logs
└── work
```

---

# ⚡ Important Commands

| Command | Purpose |
|---------|---------|
| ./nifi.sh start | Start NiFi |
| ./nifi.sh stop | Stop NiFi |
| ./nifi.sh restart | Restart NiFi |
| ./nifi.sh status | Check Status |

---

# ⚠️ Troubleshooting

## JAVA_HOME Not Set

```bash
echo $JAVA_HOME
```

## Port Busy

```bash
sudo ss -tulpn | grep 8443
```

## View Logs

```bash
tail -f /opt/nifi/logs/nifi-app.log
```

---

# 📝 Observation Table

| Activity | Status | Remarks |
|----------|--------|---------|
| Java Verified | | |
| NiFi Installed | | |
| NiFi Started | | |
| Web UI Accessible | | |
| Flow Created | | |
| Output Generated | | |

---

# 🎯 Result

Apache NiFi was successfully installed and configured. A simple GenerateFlowFile → PutFile workflow was executed successfully and the output file was generated.

---

# 📖 Summary

Students installed Apache NiFi, configured Java, accessed the secure web interface, created their first workflow, and verified successful data movement.

---

# 📚 References

1. https://nifi.apache.org
2. Apache NiFi Documentation
3. Data Engineering with Python – Paul Crickard

---

# 📚 Next Module

➡ **05-Apache-Airflow.md**
