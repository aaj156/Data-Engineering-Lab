# Chapter 01 -- Introduction

## Experiment Title

**Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL**

------------------------------------------------------------------------

# 1. Introduction

Modern organizations generate enormous volumes of data from web
applications, mobile applications, IoT devices, sensors, enterprise
systems, social media platforms, and cloud services. Raw data collected
from these heterogeneous sources is rarely suitable for direct analysis
because it often contains inconsistencies, missing values, duplicate
records, and different formats.

To make data useful for reporting, business intelligence, analytics, and
machine learning, organizations implement **ETL (Extract, Transform,
Load)** pipelines. An ETL pipeline extracts data from one or more
sources, transforms the data into a clean and standardized format, and
finally loads it into a destination such as a relational database, data
warehouse, or data lake.

In this laboratory experiment, students will design and implement a
complete ETL workflow using **Apache NiFi** and **PostgreSQL**. The
source of data is a public REST API, while Apache NiFi performs data
movement and transformation before storing the processed records in
PostgreSQL.

------------------------------------------------------------------------

# 2. Aim

To design, configure, execute, and validate a complete ETL pipeline
using Apache NiFi and PostgreSQL.

------------------------------------------------------------------------

# 3. Objectives

-   Understand the ETL lifecycle.
-   Understand REST API based data ingestion.
-   Learn the architecture and workflow of Apache NiFi.
-   Configure NiFi processors for ETL.
-   Transform JSON data into relational records.
-   Load processed data into PostgreSQL.
-   Verify the loaded records using SQL queries.

------------------------------------------------------------------------

# 4. Learning Outcomes

After completing this experiment, students will be able to:

1.  Explain the Extract, Transform and Load process.
2.  Configure an Apache NiFi dataflow.
3.  Consume data from a REST API.
4.  Parse and transform JSON documents.
5.  Load transformed records into PostgreSQL.
6.  Validate ETL execution using SQL.
7.  Troubleshoot common ETL issues.

------------------------------------------------------------------------

# 5. Prerequisites

Students should be familiar with:

-   Basic SQL
-   JSON data format
-   Relational databases
-   REST APIs
-   Linux command line
-   PostgreSQL fundamentals

------------------------------------------------------------------------

# 6. Software Used

  Software                 Purpose
  ------------------------ -------------------------
  Ubuntu 24.04 LTS         Operating System
  OpenJDK 21               Java Runtime
  Apache NiFi              ETL Platform
  PostgreSQL               Database
  pgAdmin 4                Database Administration
  PostgreSQL JDBC Driver   Database Connectivity

------------------------------------------------------------------------

# 7. ETL Workflow

``` text
REST API
    │
    ▼
InvokeHTTP
    │
    ▼
SplitJson
    │
    ▼
JoltTransformJSON
    │
    ▼
UpdateRecord
    │
    ▼
PutDatabaseRecord
    │
    ▼
PostgreSQL
```

------------------------------------------------------------------------

# 8. Real-World Applications

-   E-commerce analytics
-   Banking transaction processing
-   Healthcare information systems
-   Smart city platforms
-   IoT sensor data ingestion
-   Cloud data integration
-   Business intelligence dashboards

------------------------------------------------------------------------

# 9. Expected Output

By the end of this experiment, students should have:

-   A working Apache NiFi ETL pipeline.
-   Successfully extracted data from a REST API.
-   Transformed JSON records.
-   Loaded data into PostgreSQL.
-   Verified the inserted records using SQL.
-   Exported the completed NiFi workflow.

------------------------------------------------------------------------

# 10. Chapter Summary

This chapter introduced the purpose and importance of ETL pipelines, the
motivation behind using Apache NiFi for data integration, the objectives
of the laboratory experiment, and the expected outcomes. The following
chapters will guide students through ETL architecture, Apache NiFi
fundamentals, processor configuration, transformation, database loading,
testing, and validation.

------------------------------------------------------------------------

**Next Chapter:** Chapter-02-ETL-Architecture.md
