# 05 -- Loading into PostgreSQL

## Experiment: Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Objective

To load transformed JSON records from Apache NiFi into a PostgreSQL
database using the **PutDatabaseRecord** processor and verify successful
insertion.

------------------------------------------------------------------------

# 2. Learning Outcomes

Students will be able to:

-   Configure a JDBC connection in Apache NiFi.
-   Create and enable a DBCPConnectionPool controller service.
-   Configure the PutDatabaseRecord processor.
-   Load transformed records into PostgreSQL.
-   Validate inserted records using SQL queries.

------------------------------------------------------------------------

# 3. Load Phase in ETL

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

The **Load** phase stores transformed records permanently in the
database.

------------------------------------------------------------------------

# 4. Prerequisites

Ensure the following are completed:

-   PostgreSQL service is running.
-   Database `etl_lab` exists.
-   Table `products` exists.
-   PostgreSQL JDBC driver is copied into NiFi's `lib` directory.
-   Apache NiFi is running.
-   JoltTransformJSON and UpdateRecord processors are working correctly.

------------------------------------------------------------------------

# 5. Configure DBCPConnectionPool

Create a **DBCPConnectionPool** controller service.

  Property                     Value
  ---------------------------- --------------------------------------------
  Database Connection URL      `jdbc:postgresql://localhost:5432/etl_lab`
  Database Driver Class Name   `org.postgresql.Driver`
  Database Driver Location     `postgresql-42.7.7.jar`
  Database User                `etluser`
  Database Password            `etl@123`

Enable the controller service after configuration.

------------------------------------------------------------------------

# 6. Configure PutDatabaseRecord

  Property                              Value
  ------------------------------------- --------------------
  Database Connection Pooling Service   DBCPConnectionPool
  Record Reader                         JsonTreeReader
  Table Name                            `products`
  Statement Type                        INSERT
  Translate Field Names                 true
  Unmatched Column Behavior             Ignore

Connect the **success** relationship to an auto-terminated connection or
the next processor if extending the flow.

------------------------------------------------------------------------

# 7. Database Mapping

  JSON Field      PostgreSQL Column
  --------------- -------------------
  product_id      product_id
  title           title
  price           price
  description     description
  category        category
  image_url       image_url
  rating          rating
  rating_count    rating_count
  processed_by    processed_by
  source_system   source_system

------------------------------------------------------------------------

# 8. Execute the Pipeline

1.  Enable all controller services.
2.  Start PutDatabaseRecord.
3.  Start UpdateRecord.
4.  Start JoltTransformJSON.
5.  Start SplitJson.
6.  Start InvokeHTTP.
7.  Wait until all queues are empty.

------------------------------------------------------------------------

# 9. Verify in PostgreSQL

``` sql
SELECT COUNT(*) FROM products;
```

``` sql
SELECT * FROM products LIMIT 10;
```

``` sql
SELECT category, COUNT(*)
FROM products
GROUP BY category;
```

Expected Result:

-   Records inserted successfully.
-   No duplicate primary keys.
-   Correct values stored in each column.

------------------------------------------------------------------------

# 10. Validation Checklist

-   DBCPConnectionPool enabled.
-   JDBC driver loaded.
-   PutDatabaseRecord running.
-   No FlowFiles in failure queue.
-   SQL queries return expected records.
-   Data matches transformed JSON.

------------------------------------------------------------------------

# 11. Common Errors

  -----------------------------------------------------------------------
  Error              Cause                 Solution
  ------------------ --------------------- ------------------------------
  Connection refused PostgreSQL stopped    Start PostgreSQL

  Authentication     Wrong credentials     Verify DBCP settings
  failed                                   

  Table not found    Schema missing        Execute create_tables.sql

  Driver not found   JDBC JAR missing      Copy JAR to NiFi lib

  Column mismatch    Incorrect field       Review JSON transformation
                     mapping               
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 12. Best Practices

-   Validate transformations before loading.
-   Use transactions for reliable inserts.
-   Monitor failure relationships.
-   Verify data using SQL after every run.
-   Export the NiFi flow after successful execution.

------------------------------------------------------------------------

# 13. Self Assessment

1.  Which processor performs the Load phase?
2.  Why is DBCPConnectionPool required?
3.  Which SQL query verifies record count?
4.  What happens if the table schema does not match the JSON?
5.  Why should the JDBC driver be placed in the NiFi lib directory?

------------------------------------------------------------------------

# 14. Expected Result

Students successfully load transformed REST API data into PostgreSQL,
verify the inserted records using SQL, and complete the end-to-end ETL
pipeline.
