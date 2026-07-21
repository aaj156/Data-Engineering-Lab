# 04 -- Data Transformation

## Experiment: Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Objective

To understand how raw JSON data obtained from a REST API is cleaned,
standardized, enriched, and prepared for storage in a relational
database using Apache NiFi.

------------------------------------------------------------------------

# 2. Learning Outcomes

After completing this experiment, students will be able to:

-   Understand the purpose of data transformation in ETL.
-   Transform nested JSON into a relational structure.
-   Rename and map JSON fields.
-   Create derived fields.
-   Configure **JoltTransformJSON** and **UpdateRecord** processors.
-   Validate transformed records before database loading.

------------------------------------------------------------------------

# 3. Why Data Transformation?

Raw data collected from external systems is rarely ready for direct
storage.

Typical issues include:

-   Nested JSON structures
-   Inconsistent field names
-   Missing values
-   Unnecessary attributes
-   Incorrect data types
-   Lack of derived business information

Data transformation converts raw data into a standardized format
suitable for analytics and database storage.

------------------------------------------------------------------------

# 4. ETL Workflow

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

The transformation stage consists of **JoltTransformJSON** and
**UpdateRecord**.

------------------------------------------------------------------------

# 5. Input Record

``` json
{
  "id": 1,
  "title": "Fjallraven Backpack",
  "price": 109.95,
  "description": "Laptop Backpack",
  "category": "men's clothing",
  "image": "https://...",
  "rating": {
    "rate": 3.9,
    "count": 120
  }
}
```

------------------------------------------------------------------------

# 6. Transformation 1 -- JoltTransformJSON

Purpose:

-   Rename fields
-   Flatten nested objects
-   Remove unwanted hierarchy
-   Match PostgreSQL schema

### Sample JOLT Specification

``` json
[
  {
    "operation":"shift",
    "spec":{
      "id":"product_id",
      "title":"title",
      "price":"price",
      "description":"description",
      "category":"category",
      "image":"image_url",
      "rating":{
        "rate":"rating",
        "count":"rating_count"
      }
    }
  }
]
```

------------------------------------------------------------------------

# 7. Output After JOLT

``` json
{
  "product_id":1,
  "title":"Fjallraven Backpack",
  "price":109.95,
  "description":"Laptop Backpack",
  "category":"men's clothing",
  "image_url":"https://...",
  "rating":3.9,
  "rating_count":120
}
```

------------------------------------------------------------------------

# 8. Transformation 2 -- UpdateRecord

Purpose:

-   Standardize values
-   Create derived fields
-   Add metadata
-   Apply business rules

Typical updates:

  Field           Action
  --------------- -----------------------
  category        Convert to uppercase
  processed_by    Add "Apache NiFi"
  source_system   Add "REST API"
  created_at      Add current timestamp

------------------------------------------------------------------------

# 9. Example Output

``` json
{
  "product_id":1,
  "title":"Fjallraven Backpack",
  "price":109.95,
  "description":"Laptop Backpack",
  "category":"MEN'S CLOTHING",
  "image_url":"https://...",
  "rating":3.9,
  "rating_count":120,
  "processed_by":"Apache NiFi",
  "source_system":"REST API"
}
```

------------------------------------------------------------------------

# 10. Processor Configuration

## JoltTransformJSON

  Property             Value
  -------------------- ---------
  Jolt Transform       Shift
  Jolt Specification   Custom
  Relationship         success

## UpdateRecord

  Property               Value
  ---------------------- ---------------------
  Record Reader          JsonTreeReader
  Record Writer          JsonRecordSetWriter
  Success Relationship   PutDatabaseRecord

------------------------------------------------------------------------

# 11. Validation

Verify the following:

-   JSON structure is flattened.
-   Nested rating object removed.
-   New fields are present.
-   Category formatting is correct.
-   FlowFile reaches PutDatabaseRecord successfully.

Use **Data Provenance → View Content** to inspect the transformed
FlowFile.

------------------------------------------------------------------------

# 12. Common Errors

  ------------------------------------------------------------------------
  Problem                  Cause               Solution
  ------------------------ ------------------- ---------------------------
  Invalid JOLT             Incorrect JSON      Validate JOLT JSON
  specification            syntax              

  Missing mapped fields    Incorrect mapping   Verify source field names

  UpdateRecord invalid     Controller service  Enable Record Reader/Writer
                           disabled            

  Type mismatch            Wrong schema        Check field data types
  ------------------------------------------------------------------------

------------------------------------------------------------------------

# 13. Best Practices

-   Keep JOLT specifications readable.
-   Flatten nested JSON before database loading.
-   Apply business rules only once.
-   Validate transformed output before loading.
-   Document all transformation rules.

------------------------------------------------------------------------

# 14. Self Assessment

1.  Why is JoltTransformJSON used before UpdateRecord?
2.  Why should nested JSON be flattened?
3.  Which processor creates derived fields?
4.  What is the purpose of RecordPath?
5.  How do you verify transformed data?

------------------------------------------------------------------------

# 15. Expected Result

Students should successfully:

-   Transform REST API JSON into relational format.
-   Standardize and enrich records.
-   Prepare records for PostgreSQL insertion.
-   Validate transformed FlowFiles using Data Provenance.

------------------------------------------------------------------------

# 16. Conclusion

Data transformation is the most critical stage of the ETL process. In
this experiment, Apache NiFi processors reshape, clean, and enrich REST
API data, ensuring that only standardized and high-quality records are
loaded into PostgreSQL.
