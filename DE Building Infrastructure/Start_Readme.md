# 🚀 Data Engineering Laboratory

<div align="center">

# Experiment No. __

# 🏗️ Building Infrastructure for Data Engineering

### *Designing, Installing, Configuring, and Verifying a Modern Data Engineering Environment*

---

**Course:** Data Engineering Laboratory  
**Program:** B.Tech. Artificial Intelligence & Data Science  
**Semester:** VI  
**Experiment Duration:** 1 Practical Sessions (2 Hours)

---

![Platform](https://img.shields.io/badge/Platform-Ubuntu%2024.04-orange)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-blue)
![Apache NiFi](https://img.shields.io/badge/Apache-NiFi-green)
![Apache Airflow](https://img.shields.io/badge/Apache-Airflow-red)
![ElasticSearch](https://img.shields.io/badge/ElasticSearch-9.x-yellow)
![Kibana](https://img.shields.io/badge/Kibana-9.x-lightblue)

</div>

---

# 📖 Introduction

Modern organizations generate massive volumes of structured and unstructured data from websites, mobile applications, IoT devices, enterprise systems, cloud platforms, and social media. Before this data can be analyzed or transformed into business intelligence, a reliable **Data Engineering Infrastructure** must be established.

A Data Engineering Infrastructure provides the software ecosystem required to ingest, store, process, orchestrate, monitor, and visualize data pipelines. Instead of working with individual tools independently, modern data engineers integrate multiple open-source technologies to build scalable, fault-tolerant, and automated data platforms.

In this experiment, students will install, configure, and verify the core infrastructure components used in modern data engineering environments. These tools will serve as the foundation for all subsequent laboratory experiments involving data ingestion, orchestration, transformation, storage, and visualization.

---

# 🎯 Aim

To build a complete Data Engineering Infrastructure by installing, configuring, and verifying the operation of modern open-source data engineering tools including PostgreSQL, pgAdmin 4, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana on Ubuntu Linux.

---

# 🎓 Course Outcome Mapping

| CO | Description | Bloom's Level |
|----|-------------|---------------|
| **CO2** | Evaluate modern data storage architectures and infrastructure components used in Data Engineering. | Analyze (L4) |
| **CO3** | Configure data engineering platforms for building scalable data pipelines. | Apply (L3) |

---

# 🎯 Learning Outcomes

After successful completion of this experiment, students will be able to:

- Install and configure a complete Data Engineering software environment.
- Understand the role of each infrastructure component within a modern data platform.
- Configure relational and NoSQL databases.
- Deploy workflow orchestration tools.
- Configure data ingestion tools.
- Verify successful installation of every software component.
- Understand interactions among infrastructure services.
- Prepare the environment required for subsequent Data Engineering experiments.

---

# 🏗️ Data Engineering Infrastructure

A modern Data Engineering platform consists of multiple interconnected software systems that work together to collect, process, store, schedule, and visualize data.

The infrastructure developed in this experiment forms the backbone of all future laboratory exercises.

---

# 🌐 Infrastructure Architecture

```text
                    Data Sources
      ┌───────────────────────────────────────┐
      │ CSV │ APIs │ Databases │ IoT │ Logs │
      └───────────────────────────────────────┘
                     │
                     ▼
             Apache NiFi
       (Data Ingestion Pipeline)
                     │
                     ▼
            Apache Airflow
      (Workflow Orchestration)
                     │
       ┌─────────────┴─────────────┐
       ▼                           ▼
 PostgreSQL                 Elasticsearch
(Relational DB)            (Search Engine)

       │                           │
       ▼                           ▼
    pgAdmin                     Kibana
(Database GUI)            (Visualization & Analytics)
```

---

# 🔄 Experiment Workflow

```text
Start

↓

Prepare Ubuntu System

↓

Install Java

↓

Install PostgreSQL

↓

Install pgAdmin 4

↓

Install Apache NiFi

↓

Install Apache Airflow

↓

Install Elasticsearch

↓

Install Kibana

↓

Verify Installation

↓

Test Individual Components

↓

Infrastructure Ready

↓

Proceed to Data Pipeline Development

↓

End
```

---

# 🧩 Infrastructure Components

| Component | Purpose |
|------------|----------|
| PostgreSQL | Relational Database Management System |
| pgAdmin 4 | PostgreSQL Administration Tool |
| Apache NiFi | Data Ingestion and Flow Automation |
| Apache Airflow | Workflow Scheduling and Orchestration |
| Elasticsearch | Distributed Search & Analytics Engine |
| Kibana | Visualization Dashboard for Elasticsearch |

---

# ⚙️ Software & Hardware Requirements

## Hardware

- Intel Core i3 / i5 / i7 / Ryzen Processor
- Minimum 8 GB RAM (16 GB Recommended)
- 40 GB Free Storage
- Internet Connection

---

## Operating System

- Ubuntu 24.04 LTS (Recommended)

---

## Software

| Software | Recommended Version |
|----------|----------------------|
| Java | OpenJDK 21 LTS |
| Python | Python 3.12 |
| PostgreSQL | 17 |
| pgAdmin 4 | Latest Stable |
| Apache NiFi | Latest Stable |
| Apache Airflow | Latest Stable |
| Elasticsearch | Latest Stable |
| Kibana | Latest Stable |

---

# 📂 Repository Structure

```text
Experiment-01-Building-Data-Engineering-Infrastructure/
│
├── README.md
│
├── docs/
│   ├── 01-Prerequisites.md
│   ├── 02-PostgreSQL.md
│   ├── 03-pgAdmin4.md
│   ├── 04-Apache-NiFi.md
│   ├── 05-Apache-Airflow.md
│   ├── 06-Elasticsearch.md
│   ├── 07-Kibana.md
│   ├── 08-Testing.md
│   ├── 09-Troubleshooting.md
│   ├── 10-Viva.md
│   └── 11-References.md
│
├── commands/
│   ├── install.sh
│   └── verify.sh
│
└── images/
```

---

# 📚 Experiment Modules

| Module | Description |
|---------|-------------|
| Module 1 | System Preparation |
| Module 2 | PostgreSQL Installation |
| Module 3 | pgAdmin Configuration |
| Module 4 | Apache NiFi Installation |
| Module 5 | Apache Airflow Installation |
| Module 6 | Elasticsearch Installation |
| Module 7 | Kibana Installation |
| Module 8 | Infrastructure Testing |
| Module 9 | Troubleshooting |
| Module 10 | Viva Questions |

---

# 📌 Expected Outputs

After completing this experiment, students should be able to successfully access:

| Tool | URL |
|------|-----|
| Apache NiFi | http://localhost:8443/nifi |
| Apache Airflow | http://localhost:8080 |
| pgAdmin 4 | http://localhost:5050 *(or Desktop Application)* |
| Elasticsearch | http://localhost:9200 |
| Kibana | http://localhost:5601 |

---

# 📊 Skills Developed

- Linux Administration
- Java Runtime Configuration
- Python Environment Management
- Database Administration
- Workflow Orchestration
- Data Pipeline Infrastructure
- Service Management
- Data Platform Deployment

---

# 🎯 Experiment Outcome

Upon successful completion of this experiment, students will have a fully operational Data Engineering Infrastructure capable of supporting subsequent laboratory exercises related to data ingestion, orchestration, transformation, storage, analytics, and visualization.

---

# 📖 Next Section

➡ **Section No. 2 — Building Your First Data Pipeline using Apache NiFi**

---

# 📚 References

1. Apache NiFi Documentation
2. Apache Airflow Documentation
3. PostgreSQL Documentation
4. pgAdmin 4 Documentation
5. Elasticsearch Documentation
6. Kibana Documentation
7. *Data Engineering with Python* — Paul Crickard
8. *Designing Data-Intensive Applications* — Martin Kleppmann

---

# 👨‍💻 Author

**Prof. Akshay A Jadhav**
**Department of Artificial Intelligence & Data Science**  
**Data Engineering Laboratory**

---

<div align="center">

### ⭐ This repository is part of the Data Engineering Laboratory course.

**Happy Learning! 🚀**

</div>
