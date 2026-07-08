# 🔍 Module 06 – Elasticsearch Installation & Configuration

> **Experiment No. _**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

Elasticsearch is a distributed, open-source search and analytics engine developed on top of the Apache Lucene library. It is designed for storing, searching, and analyzing large volumes of structured and unstructured data in near real-time.

Unlike traditional relational databases, Elasticsearch stores data as **JSON documents** and provides powerful full-text search, indexing, filtering, aggregation, and analytics capabilities.

In modern Data Engineering architectures, Elasticsearch is widely used for:

- Log Analytics
- Full-Text Search
- Real-Time Monitoring
- Business Intelligence
- Security Analytics
- Observability Platforms

In this module, students will install Elasticsearch, configure the server, start the service, create an index, insert sample documents, perform search operations, and verify successful installation.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Understand the purpose of Elasticsearch.
- Install Elasticsearch on Ubuntu.
- Configure Elasticsearch.
- Start and manage Elasticsearch services.
- Verify server health.
- Create indices.
- Insert JSON documents.
- Perform search queries.
- Understand Elasticsearch architecture.

---

# 🧠 Why Elasticsearch?

Traditional relational databases are optimized for transactional workloads but are not designed for extremely fast full-text searching.

Elasticsearch provides:

- Full-Text Search
- Distributed Architecture
- Near Real-Time Search
- Horizontal Scalability
- JSON Document Storage
- REST API
- High Availability
- Fast Aggregations

---

# 🏗 Elasticsearch Architecture

```text
                Client Applications
         (Browser / REST API / Kibana)
                     │
                     ▼
             Elasticsearch Cluster
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
    Node 1         Node 2         Node 3
      │              │              │
      ▼              ▼              ▼
     Shards       Replicas       Indices
                     │
                     ▼
                JSON Documents
```

---

# 🔑 Core Components

| Component | Description |
|-----------|-------------|
| Cluster | Collection of Nodes |
| Node | Single Elasticsearch Server |
| Index | Collection of Documents |
| Document | JSON Record |
| Field | Attribute of a Document |
| Shard | Partition of an Index |
| Replica | Copy of a Shard |

---

# ⚙️ Software Requirements

- Ubuntu 24.04 LTS
- OpenJDK 21
- Internet Connection
- Minimum 4 GB RAM

---

# 📦 Step 1 – Verify Java

```bash
java -version
```

Expected Output

```text
openjdk version "21"
```

---

# 📦 Step 2 – Download Elasticsearch

Visit

https://www.elastic.co/downloads/elasticsearch

Or use wget

```bash
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-9.x-linux-x86_64.tar.gz
```

---

# 📦 Step 3 – Extract Package

```bash
tar -xzf elasticsearch-9.x-linux-x86_64.tar.gz
```

Move

```bash
sudo mv elasticsearch-9.x /opt/elasticsearch
```

---

# 📦 Step 4 – Configure Elasticsearch

Navigate

```bash
cd /opt/elasticsearch/config
```

Edit configuration

```bash
nano elasticsearch.yml
```

Basic Configuration

```yaml
cluster.name: data-engineering-cluster

node.name: node-1

network.host: localhost

http.port: 9200

discovery.type: single-node
```

Save the file.

---

# 📦 Step 5 – Start Elasticsearch

```bash
cd /opt/elasticsearch/bin

./elasticsearch
```

Wait until startup completes.

---

# 📦 Step 6 – Verify Elasticsearch

Open another terminal.

```bash
curl http://localhost:9200
```

Expected Output

```json
{
  "name": "node-1",
  "cluster_name": "data-engineering-cluster",
  "version": {
      "number": "9.x"
  }
}
```

---

# 📦 Step 7 – Check Cluster Health

```bash
curl http://localhost:9200/_cluster/health?pretty
```

Expected

```json
status : green
```

---

# 📦 Step 8 – Create Index

```bash
curl -X PUT http://localhost:9200/students
```

Expected Output

```json
{
  "acknowledged": true
}
```

---

# 📦 Step 9 – Insert Document

```bash
curl -X POST http://localhost:9200/students/_doc/1 \
-H "Content-Type: application/json" \
-d '{
"name":"Akshay",
"department":"AIDS",
"marks":95
}'
```

---

# 📦 Step 10 – Retrieve Document

```bash
curl http://localhost:9200/students/_doc/1?pretty
```

---

# 📦 Step 11 – Search Documents

```bash
curl http://localhost:9200/students/_search?pretty
```

---

# 📦 Step 12 – Delete Index (Optional)

```bash
curl -X DELETE http://localhost:9200/students
```

---

# 📁 Elasticsearch Directory Structure

```text
/opt/elasticsearch/

├── bin/
├── config/
├── data/
├── logs/
├── modules/
├── plugins/
└── lib/
```

---

# ⚡ Important Commands

| Command | Purpose |
|----------|---------|
| ./elasticsearch | Start Server |
| curl localhost:9200 | Verify Server |
| _cluster/health | Cluster Status |
| PUT | Create Index |
| POST | Insert Document |
| GET | Search Document |
| DELETE | Delete Index |

---

# ⚠️ Common Errors

## Java Not Installed

```bash
java -version
```

Install

```bash
sudo apt install openjdk-21-jdk
```

---

## Port 9200 Already Used

```bash
sudo ss -tulpn | grep 9200
```

---

## Elasticsearch Not Starting

Check logs

```bash
tail -f /opt/elasticsearch/logs/*.log
```

---

## Cluster Status Yellow

For a single-node setup, set

```yaml
discovery.type: single-node
```

Restart Elasticsearch.

---

# 💡 Best Practices

- Use meaningful index names.
- Keep JSON documents consistent.
- Monitor cluster health regularly.
- Backup important indices.
- Use replicas in production.
- Restrict public access to Elasticsearch.

---

# 📝 Observation Table

| Activity | Status | Remarks |
|-----------|--------|---------|
| Java Verified | | |
| Elasticsearch Installed | | |
| Server Started | | |
| Cluster Healthy | | |
| Index Created | | |
| Document Inserted | | |
| Search Executed | | |

---

# 🎯 Result

Elasticsearch was successfully installed and configured. The server started successfully, the cluster health was verified, a sample index was created, JSON documents were inserted, and search queries were executed successfully. Elasticsearch is now ready for integration with Kibana and future data engineering experiments.

---

# 📖 Summary

Elasticsearch is a high-performance distributed search engine designed for storing and searching large volumes of data. In this module, students installed Elasticsearch, configured the server, verified cluster health, created an index, inserted sample JSON documents, and executed search operations using the REST API. This environment will be used in the next module to visualize and analyze data using Kibana.

---

# 📚 References

1. Elasticsearch Documentation  
   https://www.elastic.co/guide/

2. Elasticsearch Downloads  
   https://www.elastic.co/downloads/elasticsearch

3. Data Engineering with Python – Paul Crickard

---

# 📚 Next Module

➡ **07-Kibana.md**

Installing and Configuring Kibana for Data Visualization and Analytics.

```
