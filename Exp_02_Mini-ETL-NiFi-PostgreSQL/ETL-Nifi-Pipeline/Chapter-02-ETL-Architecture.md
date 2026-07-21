# Chapter 02 -- ETL Architecture

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

An ETL architecture defines how data moves from one or more source
systems to a destination after undergoing cleansing, transformation, and
validation. A well-designed ETL architecture ensures that data is
reliable, consistent, and ready for reporting, analytics, and business
intelligence.

In this experiment, the ETL pipeline is implemented using Apache NiFi as
the data integration platform and PostgreSQL as the destination
database.

------------------------------------------------------------------------

# 2. What is ETL?

**ETL** stands for:

-   **Extract** -- Collect data from one or more data sources.
-   **Transform** -- Clean, validate, standardize, and enrich the
    extracted data.
-   **Load** -- Store the processed data into a target database or data
    warehouse.

------------------------------------------------------------------------

# 3. ETL Pipeline Used in this Experiment

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

# 4. Architecture Components

  Component           Role
  ------------------- ---------------------------------------------------
  REST API            Provides product data in JSON format
  InvokeHTTP          Sends an HTTP GET request and retrieves JSON data
  SplitJson           Splits a JSON array into individual JSON objects
  JoltTransformJSON   Restructures and flattens JSON fields
  UpdateRecord        Cleans, standardizes, and derives new fields
  PutDatabaseRecord   Inserts transformed records into PostgreSQL
  PostgreSQL          Stores the processed data

------------------------------------------------------------------------

# 5. Extract Phase

The Extract phase retrieves product data from the Fake Store REST API.

**Source URL**

``` text
https://fakestoreapi.com/products
```

Expected response:

-   HTTP Status: 200 OK
-   Content Type: application/json
-   JSON Array containing product records.

------------------------------------------------------------------------

# 6. Transform Phase

Transformation prepares raw data for storage.

Typical operations include:

-   Renaming attributes
-   Flattening nested JSON
-   Data type conversion
-   Standardization
-   Removing unnecessary fields
-   Creating derived columns
-   Handling missing values

------------------------------------------------------------------------

# 7. Load Phase

After transformation, each processed record is inserted into the
PostgreSQL `products` table using the `PutDatabaseRecord` processor and
a JDBC connection.

------------------------------------------------------------------------

# 8. Why Apache NiFi?

Apache NiFi provides:

-   Visual drag-and-drop pipeline development
-   Built-in processors
-   Reliable data movement
-   FlowFile tracking
-   Data provenance
-   Error routing and retry mechanisms
-   Easy integration with databases and REST APIs

------------------------------------------------------------------------

# 9. Why PostgreSQL?

PostgreSQL is selected because it provides:

-   ACID-compliant transactions
-   Strong SQL support
-   Open-source licensing
-   High performance
-   Extensive indexing capabilities
-   Enterprise-grade reliability

------------------------------------------------------------------------

# 10. Data Flow Explanation

1.  InvokeHTTP requests data from the REST API.
2.  The JSON array is received as a FlowFile.
3.  SplitJson separates the array into individual records.
4.  JoltTransformJSON restructures the JSON document.
5.  UpdateRecord cleans and enriches the data.
6.  PutDatabaseRecord inserts each record into PostgreSQL.

------------------------------------------------------------------------

# 11. Expected Output

After successful execution:

-   NiFi processors display successful execution.
-   PostgreSQL contains populated `products` records.
-   SQL queries return the inserted data.
-   The ETL workflow can be exported as a reusable NiFi template.

------------------------------------------------------------------------

# 12. Validation Checklist

  Check                              Expected Result
  ---------------------------------- -----------------
  REST API reachable                 Yes
  InvokeHTTP executed                Success
  JSON split completed               Success
  Transformation completed           Success
  Database connection established    Success
  Records inserted into PostgreSQL   Success

------------------------------------------------------------------------

# 13. Chapter Summary

This chapter introduced the architecture of the ETL pipeline used
throughout the laboratory. It explained the responsibilities of each
stage in the Extract, Transform, and Load process and showed how Apache
NiFi processors work together to move data from a REST API into a
PostgreSQL database.

------------------------------------------------------------------------

**Next Chapter:** Chapter-03-Apache-NiFi-Basics.md
