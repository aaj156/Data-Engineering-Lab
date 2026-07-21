# Chapter 07 -- UpdateRecord Processor

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

The **UpdateRecord** processor modifies records without changing the
overall structure of the data. It is used to clean, standardize, enrich,
and derive new fields before loading data into a destination system.

In this experiment, UpdateRecord performs the final transformation stage
before the records are inserted into PostgreSQL.

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
```

UpdateRecord prepares records for database insertion.

------------------------------------------------------------------------

# 3. Why UpdateRecord?

Although the JSON structure has already been transformed, additional
processing is often required before loading data into a relational
database.

Typical tasks include:

-   Standardizing text
-   Replacing null values
-   Deriving new fields
-   Updating existing values
-   Type conversion
-   Preparing data for business rules

------------------------------------------------------------------------

# 4. Record-Oriented Processing

Unlike processors that manipulate raw JSON text, UpdateRecord works on
structured records.

It requires:

-   **Record Reader**
-   **Record Writer**

In this experiment, the processor typically uses:

-   **JsonTreeReader**
-   **JsonRecordSetWriter**

------------------------------------------------------------------------

# 5. Add the Processor

1.  Drag a **Processor** onto the NiFi canvas.
2.  Search for **UpdateRecord**.
3.  Connect **JoltTransformJSON → UpdateRecord**.

> **Screenshot Placeholder:** Adding the UpdateRecord processor

------------------------------------------------------------------------

# 6. Configuration

## Scheduling

  Property           Value
  ------------------ --------------
  Run Schedule       0 sec
  Concurrent Tasks   1
  Execution          Timer Driven

## Controller Services

  Service               Purpose
  --------------------- -----------------------------
  JsonTreeReader        Reads JSON records
  JsonRecordSetWriter   Writes updated JSON records

------------------------------------------------------------------------

# 7. RecordPath Expressions

UpdateRecord uses **RecordPath** expressions to identify fields.

Examples:

  RecordPath      Description
  --------------- ------------------
  /title          Product title
  /price          Product price
  /category       Product category
  /rating         Product rating
  /rating_count   Rating count

------------------------------------------------------------------------

# 8. Sample Updates

Example transformations:

  Field         Action
  ------------- -----------------------------
  category      Convert to uppercase
  price         Round to two decimal places
  description   Trim whitespace
  created_at    Add current timestamp

------------------------------------------------------------------------

# 9. Derived Fields

New fields can be generated during transformation.

Examples:

  New Field         Description
  ----------------- --------------------------
  processing_time   Time of ETL execution
  category_upper    Uppercase category
  price_with_tax    Calculated selling price
  source_system     REST API
  processed_by      Apache NiFi

Derived fields enrich the dataset before storage.

------------------------------------------------------------------------

# 10. Relationships

  Relationship   Description
  -------------- -----------------------------
  success        Record updated successfully
  failure        Record update failed

Connect the **success** relationship to **PutDatabaseRecord**.

------------------------------------------------------------------------

# 11. Validation

Verify that:

-   UpdateRecord is running.
-   Record Reader is enabled.
-   Record Writer is enabled.
-   Updated fields are visible.
-   Derived fields appear in the output.

Inspect the FlowFile using **Data Provenance → View Content**.

------------------------------------------------------------------------

# 12. Common Errors

  ------------------------------------------------------------------------
  Error         Possible Cause                      Solution
  ------------- ----------------------------------- ----------------------
  Invalid       Incorrect path                      Verify RecordPath
  RecordPath                                        syntax

  Reader not    Missing JsonTreeReader              Enable Controller
  configured                                        Service

  Writer not    Missing JsonRecordSetWriter         Enable Controller
  configured                                        Service

  Type mismatch Invalid data type                   Convert values before
                                                    update

  Missing       Incorrect RecordPath                Check field names
  output fields                                     
  ------------------------------------------------------------------------

------------------------------------------------------------------------

# 13. Best Practices

-   Keep RecordPath expressions simple.
-   Validate data types before updating.
-   Use derived fields only when necessary.
-   Test updates on a few records before processing the complete
    dataset.
-   Document every business rule applied.

------------------------------------------------------------------------

# 14. Example Output

Before UpdateRecord

``` json
{
  "product_id":1,
  "category":"men's clothing",
  "price":109.95
}
```

After UpdateRecord

``` json
{
  "product_id":1,
  "category":"MEN'S CLOTHING",
  "price":109.95,
  "source_system":"REST API",
  "processed_by":"Apache NiFi"
}
```

------------------------------------------------------------------------

# 15. Expected Output

After successful execution:

-   Records are standardized.
-   Derived fields are added.
-   Data is ready for insertion into PostgreSQL.
-   FlowFiles move to **PutDatabaseRecord**.

------------------------------------------------------------------------

# 16. Self-Assessment

1.  Why is UpdateRecord used after JoltTransformJSON?
2.  What is the purpose of RecordPath?
3.  Why are Record Readers and Record Writers required?
4.  Name two derived fields created in this experiment.
5.  Which processor receives the updated records?

------------------------------------------------------------------------

# 17. Chapter Summary

This chapter introduced the UpdateRecord processor and demonstrated how
structured records can be cleaned, standardized, and enriched using
RecordPath expressions. Students prepared the transformed JSON records
for database insertion, completing the final transformation stage of the
ETL pipeline.

------------------------------------------------------------------------

**Next Chapter:** Chapter-08-PutDatabaseRecord.md
