# Chapter 10 -- Validation

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

Validation is the final stage of the ETL process. Its purpose is to
verify that data has been extracted correctly, transformed according to
the required business rules, and loaded successfully into the PostgreSQL
database without loss, duplication, or corruption.

This chapter provides a systematic approach for validating every stage
of the ETL pipeline.

------------------------------------------------------------------------

# 2. Validation Objectives

The validation process ensures that:

-   REST API is reachable.
-   Data is successfully extracted.
-   JSON records are correctly transformed.
-   Records are inserted into PostgreSQL.
-   Database schema is correct.
-   No processor failures occur.
-   Expected number of records is loaded.

------------------------------------------------------------------------

# 3. End-to-End Validation Workflow

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
    │
    ▼
SQL Verification
```

------------------------------------------------------------------------

# 4. Validate the REST API

Verify that the API is accessible.

**URL**

``` text
https://fakestoreapi.com/products
```

Using a browser or terminal:

``` bash
curl https://fakestoreapi.com/products
```

Expected Result:

-   HTTP Status: **200 OK**
-   Response format: JSON
-   Product records returned successfully

------------------------------------------------------------------------

# 5. Validate Apache NiFi

Verify that:

-   All processors are running.
-   No processor is marked invalid.
-   No error bulletins are displayed.
-   Queues are processing FlowFiles normally.

  Processor           Status
  ------------------- ---------
  InvokeHTTP          Running
  SplitJson           Running
  JoltTransformJSON   Running
  UpdateRecord        Running
  PutDatabaseRecord   Running

------------------------------------------------------------------------

# 6. Validate Data Provenance

Open **Data Provenance** and verify:

-   FlowFiles are generated.
-   FlowFiles pass through every processor.
-   No FlowFiles terminate unexpectedly.
-   Content is correctly transformed.

> **Screenshot Placeholder:** Data Provenance Validation

------------------------------------------------------------------------

# 7. Validate Database Connection

Ensure that:

-   PostgreSQL service is running.
-   DBCPConnectionPool is enabled.
-   JDBC driver is correctly loaded.
-   Database connection succeeds without errors.

------------------------------------------------------------------------

# 8. Validate Database Schema

Execute:

``` sql
\d products
```

Verify that the following columns exist:

  Column
  --------------
  product_id
  title
  price
  description
  category
  image_url
  rating
  rating_count
  created_at

------------------------------------------------------------------------

# 9. Validate Inserted Records

Check the total number of records.

``` sql
SELECT COUNT(*) FROM products;
```

Expected Result:

``` text
20
```

Display sample records:

``` sql
SELECT * FROM products LIMIT 10;
```

Verify that:

-   Product IDs are unique.
-   Categories are correctly stored.
-   Ratings are flattened.
-   Data types are correct.

------------------------------------------------------------------------

# 10. Validate Indexes

Execute:

``` sql
SELECT indexname
FROM pg_indexes
WHERE tablename='products';
```

Expected indexes:

-   idx_products_category
-   idx_products_price

------------------------------------------------------------------------

# 11. Validate Data Quality

Check for NULL values.

``` sql
SELECT *
FROM products
WHERE title IS NULL;
```

Check for duplicate IDs.

``` sql
SELECT product_id,
COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*)>1;
```

Expected Result:

No duplicate records.

------------------------------------------------------------------------

# 12. Common Validation Errors

  ------------------------------------------------------------------------
  Problem            Possible Cause                   Solution
  ------------------ -------------------------------- --------------------
  Zero records       Pipeline not executed            Start the flow
  loaded                                              

  Missing records    Processor failure                Check queues

  Duplicate rows     Pipeline executed multiple times Truncate table and
                                                      rerun

  JDBC error         Connection issue                 Verify
                                                      DBCPConnectionPool

  Invalid JSON       REST API issue                   Inspect InvokeHTTP
                                                      output
  ------------------------------------------------------------------------

------------------------------------------------------------------------

# 13. Faculty Validation Checklist

  Check                         Status
  ----------------------------- --------
  REST API reachable            ☐
  NiFi pipeline executed        ☐
  Controller services enabled   ☐
  No processor failures         ☐
  Records inserted              ☐
  SQL queries executed          ☐
  NiFi template exported        ☐
  Student report submitted      ☐

------------------------------------------------------------------------

# 14. Student Self-Validation Checklist

-   [ ] Environment setup completed.
-   [ ] PostgreSQL configured.
-   [ ] Apache NiFi configured.
-   [ ] ETL pipeline executed.
-   [ ] Data loaded successfully.
-   [ ] SQL verification completed.
-   [ ] Screenshots captured.
-   [ ] NiFi template exported.

------------------------------------------------------------------------

# 15. Expected Output

After successful validation:

-   All processors execute successfully.
-   PostgreSQL contains the expected records.
-   SQL queries produce correct results.
-   No processor errors remain.
-   ETL workflow is ready for submission.

------------------------------------------------------------------------

# 16. Chapter Summary

This chapter explained how to validate every stage of the ETL pipeline.
Students verified the REST API, monitored Apache NiFi execution,
confirmed database connectivity, checked the PostgreSQL schema,
validated inserted records, and ensured that the ETL workflow met all
functional requirements before submission.

------------------------------------------------------------------------

**Next Chapter:** Chapter-11-Industry-Best-Practices.md
