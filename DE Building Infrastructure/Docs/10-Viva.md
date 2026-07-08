# 🎓 Module 10 – Viva Questions, Interview Questions & Assignments

> **Experiment No. __**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

This module contains viva questions, interview-oriented questions, practical assignments, and self-assessment exercises based on the complete Data Engineering Infrastructure experiment. These questions are designed to evaluate students' understanding of installing, configuring, testing, and integrating various Data Engineering tools.

---

# 🎯 Learning Objectives

After completing this module, students will be able to:

- Recall fundamental concepts of Data Engineering Infrastructure.
- Explain the purpose of each installed software component.
- Demonstrate practical knowledge of infrastructure deployment.
- Answer technical interview questions confidently.
- Apply troubleshooting techniques to real-world scenarios.

---

# Part A – Basic Viva Questions

### 1. What is Data Engineering Infrastructure?

**Answer:**  
Data Engineering Infrastructure is a collection of software, hardware, databases, workflow engines, and supporting tools used to collect, store, process, manage, and analyze data efficiently.

---

### 2. Why is infrastructure important in Data Engineering?

**Answer:**

- Supports scalable data processing
- Enables workflow automation
- Provides reliable storage
- Facilitates analytics and visualization
- Improves system reliability

---

### 3. What operating system is recommended for this experiment?

**Answer:**

Ubuntu 24.04 LTS

---

### 4. Why is Java installed before Apache NiFi and Elasticsearch?

**Answer:**

Both Apache NiFi and Elasticsearch are Java-based applications and require the Java Runtime Environment (JRE/JDK) to execute.

---

### 5. Why is Python required?

**Answer:**

Python is required for Apache Airflow, automation scripts, ETL pipelines, and data processing.

---

### 6. Why is PostgreSQL used?

**Answer:**

PostgreSQL is an open-source relational database used for storing structured data, metadata, and application data.

---

### 7. What is pgAdmin?

**Answer:**

pgAdmin is the official graphical administration tool for PostgreSQL.

---

### 8. What is Apache NiFi?

**Answer:**

Apache NiFi is a visual data ingestion and workflow automation platform used to move, transform, and route data between systems.

---

### 9. What is Apache Airflow?

**Answer:**

Apache Airflow is a workflow orchestration platform used to schedule and monitor ETL pipelines using Python-based DAGs.

---

### 10. What is Elasticsearch?

**Answer:**

Elasticsearch is a distributed search and analytics engine used for storing, indexing, and searching large volumes of data.

---

### 11. What is Kibana?

**Answer:**

Kibana is the visualization and analytics platform for Elasticsearch used to create dashboards and analyze indexed data.

---

### 12. What is ETL?

**Answer:**

ETL stands for:

- Extract
- Transform
- Load

---

### 13. What is a Data Pipeline?

**Answer:**

A data pipeline is an automated process that transfers data from one system to another while performing necessary transformations.

---

### 14. What is a Workflow?

**Answer:**

A workflow is a sequence of connected tasks executed in a predefined order.

---

### 15. What is Workflow Orchestration?

**Answer:**

Workflow orchestration is the automated scheduling, execution, monitoring, and management of workflows.

---

# Part B – Tool-Specific Viva Questions

## PostgreSQL

### 16. What type of database is PostgreSQL?

Relational Database Management System (RDBMS).

---

### 17. Which default port does PostgreSQL use?

**5432**

---

### 18. What command opens PostgreSQL Shell?

```bash
psql
```

---

### 19. How do you list databases?

```sql
\l
```

---

### 20. How do you exit PostgreSQL?

```sql
\q
```

---

## pgAdmin

### 21. What is the purpose of pgAdmin?

To visually manage PostgreSQL databases.

---

### 22. Which parameters are required while registering a server?

- Host
- Port
- Username
- Password

---

## Apache NiFi

### 23. What is a FlowFile?

A FlowFile is the basic data object that moves through a NiFi pipeline.

---

### 24. What is a Processor?

A Processor performs a specific operation on FlowFiles.

---

### 25. Name two NiFi processors.

- GenerateFlowFile
- PutFile

---

### 26. What is Provenance?

It records the complete history of a FlowFile.

---

### 27. What is a Process Group?

A Process Group organizes multiple processors into a logical workflow.

---

### 28. Which command starts NiFi?

```bash
./nifi.sh start
```

---

## Apache Airflow

### 29. What does DAG stand for?

Directed Acyclic Graph

---

### 30. What is a Task?

A single unit of work inside a DAG.

---

### 31. What is the Scheduler?

It schedules and triggers DAG execution.

---

### 32. Which command initializes Airflow?

```bash
airflow db migrate
```

---

### 33. Which port is used by Airflow?

**8080**

---

## Elasticsearch

### 34. What is an Index?

A logical collection of documents.

---

### 35. What is a Document?

A JSON object stored in Elasticsearch.

---

### 36. What is a Cluster?

A collection of one or more Elasticsearch nodes.

---

### 37. Which port does Elasticsearch use?

**9200**

---

## Kibana

### 38. What is Discover?

A Kibana application used to explore indexed documents.

---

### 39. What is a Dashboard?

A collection of multiple visualizations.

---

### 40. Which port does Kibana use?

**5601**

---

# Part C – Interview Questions

1. Explain the complete Data Engineering Infrastructure.
2. Differentiate Apache NiFi and Apache Airflow.
3. Why is PostgreSQL preferred over MySQL in many Data Engineering projects?
4. Explain the relationship between Elasticsearch and Kibana.
5. How does Apache Airflow interact with PostgreSQL?
6. What happens if PostgreSQL is stopped?
7. Explain the role of Java in this infrastructure.
8. How would you troubleshoot a service startup failure?
9. What is the purpose of a Python Virtual Environment?
10. Explain the complete data flow from data ingestion to visualization.

---

# Part D – Practical Questions

1. Install PostgreSQL and verify the installation.
2. Create a new PostgreSQL database.
3. Register PostgreSQL in pgAdmin.
4. Create a table and insert sample records.
5. Install Apache NiFi and start the service.
6. Create a simple GenerateFlowFile → PutFile workflow.
7. Install Apache Airflow and execute a sample DAG.
8. Install Elasticsearch and create an index.
9. Insert a JSON document into Elasticsearch.
10. Visualize the indexed data using Kibana.

---

# Part E – Assignment

### Assignment 1

Prepare a comparison table between:

- PostgreSQL
- Elasticsearch

---

### Assignment 2

Compare:

- Apache NiFi
- Apache Airflow

Include:

- Architecture
- Advantages
- Limitations
- Applications

---

### Assignment 3

Draw the architecture of the complete Data Engineering Infrastructure.

---

### Assignment 4

Write installation commands for all software used in this experiment.

---

### Assignment 5

Explain the purpose of each software component in one paragraph.

---

# Self-Assessment Checklist

| Question | Yes | No |
|----------|:---:|:--:|
| Can I install PostgreSQL? | ☐ | ☐ |
| Can I configure pgAdmin? | ☐ | ☐ |
| Can I install Apache NiFi? | ☐ | ☐ |
| Can I create a NiFi workflow? | ☐ | ☐ |
| Can I install Apache Airflow? | ☐ | ☐ |
| Can I execute a DAG? | ☐ | ☐ |
| Can I install Elasticsearch? | ☐ | ☐ |
| Can I create an Index? | ☐ | ☐ |
| Can I install Kibana? | ☐ | ☐ |
| Can I build a Dashboard? | ☐ | ☐ |

---

# 🎯 Result

Students successfully reviewed the theoretical concepts, installation procedures, practical implementations, troubleshooting techniques, and applications of the complete Data Engineering Infrastructure. The viva questions and assignments reinforced their understanding of PostgreSQL, pgAdmin, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana.

---

# 📖 Summary

This module serves as a comprehensive revision guide for laboratory assessments, viva examinations, technical interviews, and practical demonstrations. It consolidates the knowledge gained throughout Experiment No. 2 and prepares students for implementing end-to-end Data Engineering workflows in subsequent experiments.

---

# 📚 References

1. PostgreSQL Documentation – https://www.postgresql.org/docs/
2. Apache NiFi Documentation – https://nifi.apache.org/docs/
3. Apache Airflow Documentation – https://airflow.apache.org/docs/
4. Elasticsearch Documentation – https://www.elastic.co/guide/
5. Kibana Documentation – https://www.elastic.co/guide/en/kibana/current/
6. *Designing Data-Intensive Applications* – Martin Kleppmann
7. *Data Engineering with Python* – Paul Crickard

---

# 🎉 Congratulations!

You have successfully completed **Experiment No. 2 – Building Infrastructure for Data Engineering**.

You are now ready to perform the next laboratory experiments involving:

- Data Ingestion using Apache NiFi
- Workflow Orchestration using Apache Airflow
- ETL Pipeline Development
- PostgreSQL Data Management
- Search & Analytics using Elasticsearch
- Data Visualization using Kibana

**Happy Learning and Happy Data Engineering! 🚀**
