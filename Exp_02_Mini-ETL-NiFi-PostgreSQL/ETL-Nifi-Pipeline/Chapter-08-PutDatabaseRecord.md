# Chapter 08 -- PutDatabaseRecord Processor

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

The **PutDatabaseRecord** processor loads processed records into a
relational database using JDBC. It represents the **Load** phase of the
ETL pipeline. In this experiment, the destination database is PostgreSQL
and the target table is `products`.

------------------------------------------------------------------------

# 2. Role in the ETL Pipeline

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

This processor completes the ETL workflow by inserting the transformed
records into the database.

------------------------------------------------------------------------

# 3. Why PutDatabaseRecord?

The processor provides a simple way to write structured records into
relational databases without writing SQL INSERT statements manually.

Benefits include:

-   Automatic SQL generation
-   JDBC connectivity
-   Batch insertion
-   Transaction support
-   Error handling
-   Database independence

------------------------------------------------------------------------

# 4. Prerequisites

Before configuring this processor, ensure:

-   PostgreSQL is running.
-   Database `etl_lab` exists.
-   Table `products` exists.
-   PostgreSQL JDBC driver is available in the NiFi `lib` directory.
-   DBCPConnectionPool controller service is configured.

------------------------------------------------------------------------

# 5. Add the Processor

1.  Drag a **Processor** onto the NiFi canvas.
2.  Search for **PutDatabaseRecord**.
3.  Connect **UpdateRecord → PutDatabaseRecord**.

> **Screenshot Placeholder:** Adding the PutDatabaseRecord processor

------------------------------------------------------------------------

# 6. Required Controller Services

## DBCPConnectionPool

  Property                Value
  ----------------------- --------------------------------------------
  Database URL            `jdbc:postgresql://localhost:5432/etl_lab`
  Database Driver Class   `org.postgresql.Driver`
  Driver Location         `postgresql-42.7.7.jar`
  Database User           `etluser`
  Database Password       `etl@123`

Enable the controller service before starting the processor.

------------------------------------------------------------------------

## Record Reader

  Property             Value
  -------------------- ----------------
  Controller Service   JsonTreeReader

------------------------------------------------------------------------

# 7. Processor Configuration

  Property                              Value
  ------------------------------------- --------------------
  Database Connection Pooling Service   DBCPConnectionPool
  Record Reader                         JsonTreeReader
  Table Name                            `products`
  Statement Type                        INSERT
  Translate Field Names                 true
  Unmatched Column Behaviour            Ignore

------------------------------------------------------------------------

# 8. Database Mapping

  JSON Field     PostgreSQL Column
  -------------- -------------------
  product_id     product_id
  title          title
  price          price
  description    description
  category       category
  image_url      image_url
  rating         rating
  rating_count   rating_count

------------------------------------------------------------------------

# 9. Relationships

  Relationship   Description
  -------------- -------------------------------
  success        Records inserted successfully
  failure        Database insertion failed
  retry          Temporary database error

For this experiment, auto-terminate **retry** only if instructed by the
faculty. Connect **failure** to a queue for debugging.

------------------------------------------------------------------------

# 10. Validation

After running the processor:

-   Processor status should be **Running**.
-   Success queue should receive FlowFiles.
-   Failure queue should remain empty.
-   No bulletin errors should be displayed.

Verify the inserted records using PostgreSQL:

``` sql
SELECT COUNT(*) FROM products;
```

``` sql
SELECT * FROM products LIMIT 10;
```

------------------------------------------------------------------------

# 11. Common Errors

  ---------------------------------------------------------------------------
  Error            Possible Cause                      Solution
  ---------------- ----------------------------------- ----------------------
  Connection       PostgreSQL not running              Start PostgreSQL
  refused                                              

  Driver not found JDBC JAR missing                    Copy driver to NiFi
                                                       `lib`

  Authentication   Incorrect username/password         Verify DBCP settings
  failed                                               

  Table does not   Missing schema                      Run
  exist                                                `create_tables.sql`

  Column mismatch  JSON fields differ from table       Check transformation
                                                       mapping
  ---------------------------------------------------------------------------

------------------------------------------------------------------------

# 12. Best Practices

-   Verify the JDBC connection before running the pipeline.
-   Keep table names consistent with the JSON schema.
-   Use transactions for reliable inserts.
-   Monitor failure relationships during testing.
-   Validate inserted data using SQL queries.

------------------------------------------------------------------------

# 13. Expected Output

After successful execution:

-   The `products` table contains records from the REST API.
-   No failed FlowFiles remain.
-   SQL queries return the inserted data.

Example:

  product_id   title                 category            price
  ------------ --------------------- ---------------- --------
  1            Fjallraven Backpack   MEN'S CLOTHING     109.95
  2            Casual T-Shirt        MEN'S CLOTHING      22.30

------------------------------------------------------------------------

# 14. Self-Assessment

1.  Which ETL phase does PutDatabaseRecord implement?
2.  Why is the DBCPConnectionPool required?
3.  Which controller service reads JSON records?
4.  How do you verify successful insertion?
5.  What happens if the table schema does not match the incoming
    records?

------------------------------------------------------------------------

# 15. Chapter Summary

This chapter explained how the PutDatabaseRecord processor loads
transformed records into PostgreSQL using JDBC. Students configured
database connectivity, mapped JSON fields to relational columns,
verified successful insertion using SQL queries, and completed the ETL
pipeline.

------------------------------------------------------------------------

**Next Chapter:** Chapter-09-Running-the-Pipeline.md
