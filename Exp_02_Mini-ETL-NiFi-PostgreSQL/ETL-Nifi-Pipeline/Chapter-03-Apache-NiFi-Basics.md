# Chapter 03 -- Apache NiFi Basics

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

Apache NiFi is an open-source dataflow automation platform designed to
collect, route, transform, and process data between different systems.
It provides a graphical interface that allows developers and data
engineers to build ETL pipelines without writing extensive code.

In this experiment, Apache NiFi acts as the ETL engine that extracts
data from a REST API, transforms the JSON data, and loads it into
PostgreSQL.

------------------------------------------------------------------------

# 2. What is Apache NiFi?

Apache NiFi is a flow-based programming platform developed to automate
the movement and transformation of data between systems.

Key capabilities include:

-   Visual drag-and-drop pipeline design
-   Real-time and batch data processing
-   Data routing and transformation
-   Guaranteed data delivery
-   Data provenance (tracking)
-   Back-pressure management
-   Prioritization and scheduling

------------------------------------------------------------------------

# 3. Apache NiFi Architecture

``` text
                Apache NiFi
                     │
     ┌───────────────┼───────────────┐
     │               │               │
 Processors      Connections     Controller Services
     │               │               │
     └───────────────┼───────────────┘
                     │
                  FlowFiles
                     │
              Destination System
```

------------------------------------------------------------------------

# 4. Important Terminology

  Term                 Description
  -------------------- ---------------------------------------------------
  FlowFile             Basic unit of data processed by NiFi
  Processor            Component that performs an operation on FlowFiles
  Connection           Transfers FlowFiles between processors
  Queue                Temporary storage between processors
  Process Group        Logical grouping of processors
  Controller Service   Shared service such as JDBC connection pool
  Relationship         Success, Failure, Retry, Original, etc.
  Data Provenance      Complete history of every FlowFile

------------------------------------------------------------------------

# 5. Understanding a FlowFile

A FlowFile consists of:

-   **Content** -- Actual data (JSON, CSV, XML, etc.)
-   **Attributes** -- Metadata such as filename, MIME type, UUID,
    timestamps, HTTP status, and custom properties.

------------------------------------------------------------------------

# 6. NiFi User Interface

Major sections of the NiFi canvas:

-   Component Toolbar
-   Canvas
-   Process Group
-   Status Bar
-   Queue Indicators
-   Bulletin Board
-   Search Panel

> **Screenshot Placeholder:** NiFi Home Page

------------------------------------------------------------------------

# 7. Processors Used in this Experiment

  Processor           Purpose
  ------------------- ------------------------------------------
  InvokeHTTP          Extract JSON data from REST API
  SplitJson           Split JSON array into individual records
  JoltTransformJSON   Transform and restructure JSON
  UpdateRecord        Clean and derive fields
  PutDatabaseRecord   Load records into PostgreSQL

------------------------------------------------------------------------

# 8. Connections and Queues

Connections transport FlowFiles from one processor to another.

Queues temporarily store FlowFiles until the downstream processor is
ready.

Benefits include:

-   Decoupling processors
-   Load balancing
-   Back-pressure control
-   Monitoring throughput

------------------------------------------------------------------------

# 9. Scheduling Processors

Each processor can be configured with:

-   Run Schedule
-   Concurrent Tasks
-   Execution Strategy
-   Yield Duration
-   Penalty Duration

Proper scheduling improves throughput and resource utilization.

------------------------------------------------------------------------

# 10. Controller Services

Controller Services provide reusable shared resources.

Examples:

-   DBCPConnectionPool
-   JSONTreeReader
-   JsonRecordSetWriter

In this experiment, the DBCPConnectionPool connects NiFi to PostgreSQL.

------------------------------------------------------------------------

# 11. Data Provenance

Data Provenance records the lifecycle of every FlowFile.

Students can:

-   View content
-   Inspect attributes
-   Replay FlowFiles
-   Download FlowFiles
-   Trace processor execution

This is one of NiFi's most powerful debugging features.

------------------------------------------------------------------------

# 12. Best Practices

-   Use meaningful processor names.
-   Organize processors inside Process Groups.
-   Enable controller services before execution.
-   Handle failure relationships.
-   Monitor queue sizes.
-   Use Data Provenance for debugging.
-   Stop processors before editing critical configurations.

------------------------------------------------------------------------

# 13. Common Mistakes

  Mistake                     Possible Cause
  --------------------------- ---------------------------------------
  Processor remains invalid   Required property not configured
  Queue grows continuously    Downstream processor stopped
  JDBC connection fails       Incorrect database configuration
  No FlowFiles generated      Source processor not running
  HTTP request fails          Invalid REST API URL or network issue

------------------------------------------------------------------------

# 14. Chapter Summary

This chapter introduced Apache NiFi fundamentals, including its
architecture, user interface, FlowFiles, processors, queues, controller
services, and data provenance. These concepts provide the foundation
required to build and debug the ETL pipeline in the following chapters.

------------------------------------------------------------------------

**Next Chapter:** Chapter-04-InvokeHTTP.md
