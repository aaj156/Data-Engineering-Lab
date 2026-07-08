# 📊 Module 07 – Kibana Installation & Configuration

> **Experiment No. __**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

Kibana is an open-source data visualization and analytics platform developed by Elastic. It serves as the graphical user interface (GUI) for Elasticsearch, enabling users to explore, analyze, monitor, and visualize data stored in Elasticsearch indices.

Using Kibana, Data Engineers can create dashboards, interactive charts, maps, tables, and reports without writing complex queries. It is widely used for monitoring system logs, business analytics, security analysis, application performance monitoring, and real-time data visualization.

In this module, students will install Kibana, connect it to Elasticsearch, launch the Kibana Web Interface, create a Data View (formerly Index Pattern), explore indexed data, and build basic visualizations.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Understand the purpose of Kibana.
- Install Kibana on Ubuntu Linux.
- Configure Kibana to communicate with Elasticsearch.
- Launch the Kibana Web Interface.
- Create a Data View.
- Explore indexed data.
- Create dashboards and visualizations.
- Verify successful Kibana installation.

---

# 🧠 Why Kibana?

Kibana transforms raw data into meaningful visual insights.

It provides:

- Interactive Dashboards
- Real-Time Monitoring
- Data Exploration
- Log Analysis
- Data Visualization
- Search & Filtering
- Alerting
- Reporting

---

# 🏗️ Kibana Architecture

```text
             Data Sources
                   │
                   ▼
          Apache NiFi / Airflow
                   │
                   ▼
            Elasticsearch
                   │
                   ▼
               Kibana
                   │
        ┌──────────┼──────────┐
        ▼          ▼          ▼
   Dashboards   Discover   Visualizations
```

---

# 🔑 Core Components

| Component | Description |
|-----------|-------------|
| Discover | Explore indexed data |
| Dashboard | Collection of visualizations |
| Visualization | Charts, Graphs, Maps |
| Data View | Connects Kibana to Elasticsearch Index |
| Lens | Drag-and-drop visualization builder |
| Dev Tools | Execute Elasticsearch REST APIs |
| Stack Management | Configure Kibana and Elasticsearch |

---

# ⚙️ Software Requirements

- Ubuntu 24.04 LTS
- Elasticsearch (Running)
- Internet Connection
- Modern Web Browser

---

# 📦 Step 1 – Verify Elasticsearch

Before installing Kibana, ensure Elasticsearch is running.

```bash
curl http://localhost:9200
```

Expected Output

```json
{
"name":"node-1",
"cluster_name":"data-engineering-cluster"
}
```

---

# 📦 Step 2 – Download Kibana

Visit

https://www.elastic.co/downloads/kibana

Or use

```bash
wget https://artifacts.elastic.co/downloads/kibana/kibana-9.x-linux-x86_64.tar.gz
```

---

# 📦 Step 3 – Extract Package

```bash
tar -xzf kibana-9.x-linux-x86_64.tar.gz
```

Move

```bash
sudo mv kibana-9.x /opt/kibana
```

---

# 📦 Step 4 – Configure Kibana

Navigate

```bash
cd /opt/kibana/config
```

Open configuration file

```bash
nano kibana.yml
```

Configure

```yaml
server.port: 5601

server.host: "localhost"

elasticsearch.hosts: ["http://localhost:9200"]
```

Save the file.

---

# 📦 Step 5 – Start Kibana

```bash
cd /opt/kibana/bin

./kibana
```

Wait until Kibana finishes loading.

---

# 📦 Step 6 – Open Kibana

Open Browser

```text
http://localhost:5601
```

The Kibana Home Page should appear.

---

# 📦 Step 7 – Create a Data View

Navigate

```text
Stack Management

↓

Data Views

↓

Create Data View
```

Enter

| Field | Value |
|-------|-------|
| Name | students |
| Index Pattern | students* |

Click

```
Save
```

---

# 📦 Step 8 – Explore Data

Navigate

```text
Discover
```

Select

```
students
```

You should see the documents inserted into Elasticsearch.

---

# 📦 Step 9 – Create Visualization

Navigate

```text
Visualize Library

↓

Create Visualization

↓

Lens
```

Choose

- Bar Chart
- Pie Chart
- Line Chart

Select

```
students
```

Drag fields onto the visualization canvas.

---

# 📦 Step 10 – Create Dashboard

Navigate

```text
Dashboard

↓

Create Dashboard

↓

Add Visualization
```

Save Dashboard

Example Name

```
Student Dashboard
```

---

# 📦 Step 11 – Use Dev Tools

Navigate

```text
Dev Tools
```

Execute

```json
GET students/_search
```

Expected Output

JSON documents from the Elasticsearch index.

---

# 📦 Step 12 – Verify Installation

Verify Kibana is accessible

```text
http://localhost:5601
```

Verify Elasticsearch connectivity

```bash
curl http://localhost:9200
```

---

# 📁 Kibana Directory Structure

```text
/opt/kibana/

├── bin/
├── config/
├── data/
├── node/
├── plugins/
└── src/
```

---

# ⚡ Important Commands

| Command | Purpose |
|----------|---------|
| ./kibana | Start Kibana |
| Ctrl + C | Stop Kibana |
| curl localhost:9200 | Verify Elasticsearch |
| http://localhost:5601 | Open Kibana |

---

# 🎨 Major Features

| Feature | Purpose |
|----------|----------|
| Discover | Explore indexed documents |
| Dashboard | Display multiple visualizations |
| Lens | Interactive visualization builder |
| Maps | Geographic visualization |
| Dev Tools | Execute Elasticsearch APIs |
| Alerts | Configure notifications |
| Stack Management | Manage Elastic Stack |

---

# ⚠️ Common Errors

## Kibana Not Opening

Check

```bash
sudo ss -tulpn | grep 5601
```

---

## Elasticsearch Not Running

```bash
curl http://localhost:9200
```

Restart Elasticsearch if necessary.

---

## Connection Refused

Verify

```yaml
elasticsearch.hosts:
```

in

```
kibana.yml
```

---

## Configuration Error

Check logs

```bash
tail -f /opt/kibana/logs/*
```

---

# 💡 Best Practices

- Always verify Elasticsearch before starting Kibana.
- Create meaningful Data View names.
- Organize dashboards by project.
- Keep dashboards simple and readable.
- Use Lens for rapid visualization development.
- Restrict public access to Kibana in production.

---

# 📝 Observation Table

| Activity | Status | Remarks |
|-----------|--------|---------|
| Elasticsearch Running | | |
| Kibana Installed | | |
| Kibana Started | | |
| Web UI Accessible | | |
| Data View Created | | |
| Visualization Created | | |
| Dashboard Created | | |

---

# 🎯 Result

Kibana was successfully installed and configured. It was connected to Elasticsearch, a Data View was created, indexed documents were explored using Discover, and dashboards and visualizations were generated successfully. The visualization platform is now ready for real-time analytics and monitoring applications.

---

# 📖 Summary

Kibana is the visualization component of the Elastic Stack, enabling users to analyze and present data stored in Elasticsearch through interactive dashboards and charts. In this module, students installed Kibana, configured its connection to Elasticsearch, created a Data View, explored indexed documents, and built basic visualizations. Together, Elasticsearch and Kibana provide a powerful platform for search, analytics, and data visualization in modern Data Engineering workflows.

---

# 📚 References

1. Kibana Documentation  
   https://www.elastic.co/guide/en/kibana/current/

2. Kibana Downloads  
   https://www.elastic.co/downloads/kibana

3. Elastic Stack Documentation  
   https://www.elastic.co/docs

4. Data Engineering with Python – Paul Crickard

---

# 📚 Next Module

➡ **08-Testing.md**

Testing and Verifying the Complete Data Engineering Infrastructure
