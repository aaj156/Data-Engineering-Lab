# Chapter 09 -- Running the ETL Pipeline

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

After configuring all processors and controller services, the ETL
pipeline is ready for execution. This chapter explains how to start,
monitor, debug, stop, and verify the complete ETL workflow using Apache
NiFi.

------------------------------------------------------------------------

# 2. Completed ETL Workflow

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

Before execution, ensure that every processor is valid (no red warning
icon).

------------------------------------------------------------------------

# 3. Pre-Execution Checklist

Verify the following before starting the flow:

  Item                              Status
  --------------------------------- --------
  Java Installed                    ✔
  PostgreSQL Running                ✔
  pgAdmin Installed                 ✔
  Apache NiFi Running               ✔
  JDBC Driver Available             ✔
  Database Created                  ✔
  Products Table Created            ✔
  Controller Services Enabled       ✔
  Processor Connections Completed   ✔

------------------------------------------------------------------------

# 4. Enable Controller Services

Before starting the processors:

1.  Open the **Controller Services** panel.
2.  Enable **DBCPConnectionPool**.
3.  Enable **JsonTreeReader**.
4.  Enable **JsonRecordSetWriter**.
5.  Wait until all services display **Enabled**.

> **Screenshot Placeholder:** Enabled Controller Services

------------------------------------------------------------------------

# 5. Start the ETL Pipeline

Start processors in the following order:

1.  PutDatabaseRecord
2.  UpdateRecord
3.  JoltTransformJSON
4.  SplitJson
5.  InvokeHTTP

Alternatively, start the entire Process Group if all components are
configured correctly.

> **Screenshot Placeholder:** Starting the ETL Flow

------------------------------------------------------------------------

# 6. Monitor Processor Status

During execution:

-   Green icon → Running
-   Red icon → Invalid configuration
-   Yellow bulletin → Warning or error
-   Stopped icon → Processor not running

Verify that FlowFiles move smoothly through each processor.

------------------------------------------------------------------------

# 7. Monitor Queues

Observe the queues between processors.

Expected behavior:

-   FlowFiles enter a queue.
-   Downstream processor consumes the FlowFiles.
-   Queue size returns to zero after processing.

Large queues may indicate that a downstream processor is stopped or
misconfigured.

------------------------------------------------------------------------

# 8. Use Data Provenance

Open **Data Provenance** to inspect FlowFiles.

You can:

-   View content
-   View attributes
-   Replay FlowFiles
-   Download FlowFiles
-   Trace processing history

This is useful for debugging transformation and loading issues.

> **Screenshot Placeholder:** Data Provenance View

------------------------------------------------------------------------

# 9. Verify Database Records

Open PostgreSQL or pgAdmin and execute:

``` sql
SELECT COUNT(*) FROM products;
```

Expected result:

``` text
20
```

Display sample records:

``` sql
SELECT * FROM products LIMIT 10;
```

Verify that:

-   Product IDs are present.
-   Categories are transformed.
-   Rating fields are flattened.
-   Derived fields (if any) are populated.

------------------------------------------------------------------------

# 10. Expected NiFi Output

The completed dataflow should resemble:

``` text
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
```

All processors should display **Running** with no error bulletins.

------------------------------------------------------------------------

# 11. Troubleshooting During Execution

  ------------------------------------------------------------------------
  Problem            Possible Cause                   Solution
  ------------------ -------------------------------- --------------------
  FlowFiles not      InvokeHTTP not running           Start InvokeHTTP
  generated                                           

  Queue increasing   Downstream processor stopped     Start next processor

  Database insertion JDBC configuration issue         Verify
  failed                                              DBCPConnectionPool

  Validation error   Controller service disabled      Enable required
                                                      services

  Empty table        PutDatabaseRecord failure        Inspect failure
                                                      relationship
  ------------------------------------------------------------------------

------------------------------------------------------------------------

# 12. Stop the Pipeline

To stop the ETL flow:

1.  Stop **InvokeHTTP**.
2.  Wait until all queues become empty.
3.  Stop remaining processors.
4.  Verify that no FlowFiles remain in any queue.

Stopping in this order prevents partial processing.

------------------------------------------------------------------------

# 13. Export the NiFi Flow

After successful execution:

1.  Right-click the Process Group.
2.  Select **Download Flow Definition** (or export using the supported
    method for your NiFi version).
3.  Save the exported file as:

``` text
MiniETL.json
```

Store the file in:

``` text
Mini-ETL-NiFi-PostgreSQL/nifi-template/
```

------------------------------------------------------------------------

# 14. Validation Checklist

  Check                         Expected Result
  ----------------------------- -----------------
  All processors running        ✔
  No failure queues             ✔
  Database populated            ✔
  SQL verification successful   ✔
  NiFi template exported        ✔

------------------------------------------------------------------------

# 15. Self-Assessment

1.  Why should controller services be enabled before starting the
    processors?
2.  What indicates that a processor is invalid?
3.  Why should InvokeHTTP be stopped before other processors?
4.  Which tool is used to inspect FlowFile history?
5.  How do you verify successful loading into PostgreSQL?

------------------------------------------------------------------------

# 16. Chapter Summary

This chapter demonstrated how to execute, monitor, validate, and stop
the complete ETL pipeline. Students learned how to monitor processor
execution, inspect FlowFiles using Data Provenance, verify database
records using SQL, and export the completed NiFi flow for submission.

------------------------------------------------------------------------

**Next Chapter:** Chapter-10-Validation.md
