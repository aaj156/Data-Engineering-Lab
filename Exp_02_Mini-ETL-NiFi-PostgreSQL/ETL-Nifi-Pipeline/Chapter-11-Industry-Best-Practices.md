# Chapter 11 -- Industry Best Practices

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

Building an ETL pipeline that works is only the first step. In
production environments, ETL systems must also be reliable, secure,
scalable, maintainable, and observable. This chapter introduces best
practices followed by data engineering teams when designing and
operating ETL pipelines with Apache NiFi and relational databases.

------------------------------------------------------------------------

# 2. Design Principles

-   Keep each processor focused on a single responsibility.
-   Use Process Groups to organize complex workflows.
-   Name processors and connections clearly.
-   Separate development, testing, and production environments.
-   Document every pipeline.

------------------------------------------------------------------------

# 3. Data Quality

Before loading data:

-   Validate mandatory fields.
-   Remove duplicates.
-   Handle missing values.
-   Verify data types.
-   Apply business rules consistently.

------------------------------------------------------------------------

# 4. Error Handling

Always configure failure paths.

Recommended approach:

``` text
success  ─────────► Next Processor

failure ─────────► Failure Queue

retry   ─────────► Retry Logic
```

Never ignore failed FlowFiles.

------------------------------------------------------------------------

# 5. Database Best Practices

-   Use connection pools.
-   Create indexes on frequently queried columns.
-   Use transactions for batch inserts.
-   Avoid inserting duplicate records.
-   Validate schema before execution.

------------------------------------------------------------------------

# 6. Performance Optimization

-   Tune concurrent tasks carefully.
-   Monitor queue sizes.
-   Process records in batches when appropriate.
-   Enable back pressure.
-   Archive or purge old provenance data.

------------------------------------------------------------------------

# 7. Security Best Practices

-   Use HTTPS for REST APIs.
-   Protect database credentials.
-   Restrict database permissions.
-   Enable authentication and authorization in NiFi.
-   Store secrets securely rather than hardcoding them.

------------------------------------------------------------------------

# 8. Monitoring

Regularly monitor:

-   Processor bulletins
-   Queue sizes
-   JVM memory usage
-   Disk utilization
-   PostgreSQL performance
-   NiFi logs

------------------------------------------------------------------------

# 9. Logging

Maintain logs for:

-   ETL execution
-   Database loading
-   REST API failures
-   Validation results
-   Assignment execution

Logs simplify debugging and auditing.

------------------------------------------------------------------------

# 10. Version Control

Maintain the following under Git:

-   SQL scripts
-   Markdown documentation
-   Shell scripts
-   NiFi flow definitions
-   Configuration files

Commit changes with meaningful messages.

------------------------------------------------------------------------

# 11. Testing Strategy

Perform:

-   Unit testing of processors
-   Integration testing of the ETL flow
-   Database validation
-   Regression testing after modifications
-   Performance testing with larger datasets

------------------------------------------------------------------------

# 12. Deployment Workflow

``` text
Development
      │
      ▼
Testing
      │
      ▼
Validation
      │
      ▼
Production
      │
      ▼
Monitoring
```

Avoid deploying untested pipelines directly to production.

------------------------------------------------------------------------

# 13. Real-World Extensions

The same workflow can later be extended to:

-   Apache Kafka
-   Apache Airflow
-   Apache Spark
-   AWS Glue
-   Azure Data Factory
-   Google Cloud Dataflow
-   Snowflake
-   Databricks

------------------------------------------------------------------------

# 14. Industry Checklist

  Item                      Status
  ------------------------- --------
  Environment documented    □
  Flow validated            □
  Failure path configured   □
  Database indexed          □
  Security reviewed         □
  Monitoring enabled        □
  Report generated          □

------------------------------------------------------------------------

# 15. Chapter Summary

This chapter presented professional practices for building reliable ETL
pipelines. Applying these principles improves maintainability,
performance, security, and operational reliability, preparing students
for real-world data engineering projects.

------------------------------------------------------------------------

# Next Steps

Congratulations! You have completed the conceptual and implementation
chapters for **Building a Mini ETL Pipeline using Apache NiFi and
PostgreSQL**.

Proceed with the remaining repository artifacts in the following order:

1.  Generate and verify the NiFi template (`MiniETL.json`).
2.  Prepare the supporting SQL files:
    -   `create_database.sql`
    -   `create_tables.sql`
    -   `sample_queries.sql`
3.  Add a sample API response to `dataset/sample_response.json`.
4.  Capture screenshots of:
    -   NiFi canvas
    -   Controller Services
    -   Data Provenance
    -   PostgreSQL tables
    -   SQL query results
5.  Generate:
    -   `README.md`
    -   `references.md`
    -   Student report template
    -   Assignment evaluation scripts
6.  Run the validation scripts and export the completed project.

The project will then be ready for laboratory use, student submission,
and faculty assessment.
