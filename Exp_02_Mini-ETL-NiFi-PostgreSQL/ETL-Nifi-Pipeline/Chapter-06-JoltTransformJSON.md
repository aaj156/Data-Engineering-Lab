# Chapter 06 -- JoltTransformJSON Processor

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

The **JoltTransformJSON** processor restructures JSON documents using
the **JOLT (JSON-to-JSON Transformation)** specification. It is one of
the most important transformation processors in Apache NiFi because it
allows incoming JSON to be reshaped without writing custom code.

In this experiment, the Fake Store REST API returns nested JSON fields.
Before loading the data into PostgreSQL, these records must be
transformed into a relational structure.

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
```

This processor performs the **core transformation** stage of the ETL
process.

------------------------------------------------------------------------

# 3. Why JoltTransformJSON?

The incoming JSON is optimized for web applications, not relational
databases.

Typical transformation tasks include:

-   Renaming fields
-   Removing unwanted attributes
-   Flattening nested JSON
-   Reordering fields
-   Preparing records for database loading

------------------------------------------------------------------------

# 4. Input JSON

``` json
{
  "id": 1,
  "title": "Fjallraven Backpack",
  "price": 109.95,
  "description": "Laptop backpack",
  "category": "men's clothing",
  "image": "https://...",
  "rating": {
    "rate": 3.9,
    "count": 120
  }
}
```

------------------------------------------------------------------------

# 5. Desired Output

``` json
{
  "product_id": 1,
  "title": "Fjallraven Backpack",
  "price": 109.95,
  "description": "Laptop backpack",
  "category": "men's clothing",
  "image_url": "https://...",
  "rating": 3.9,
  "rating_count": 120
}
```

------------------------------------------------------------------------

# 6. Add the Processor

1.  Drag a **Processor** to the NiFi canvas.
2.  Search for **JoltTransformJSON**.
3.  Connect **SplitJson → JoltTransformJSON**.

> **Screenshot Placeholder:** Adding the JoltTransformJSON processor

------------------------------------------------------------------------

# 7. Configuration

## Scheduling

  Property           Value
  ------------------ --------------
  Run Schedule       0 sec
  Concurrent Tasks   1
  Execution          Timer Driven

## Properties

  Property             Value
  -------------------- --------
  Jolt Specification   Custom
  Jolt Transform       Shift

------------------------------------------------------------------------

# 8. Sample JOLT Specification

``` json
[
  {
    "operation": "shift",
    "spec": {
      "id": "product_id",
      "title": "title",
      "price": "price",
      "description": "description",
      "category": "category",
      "image": "image_url",
      "rating": {
        "rate": "rating",
        "count": "rating_count"
      }
    }
  }
]
```

------------------------------------------------------------------------

# 9. Explanation of the Specification

  Source Field   Target Field
  -------------- --------------
  id             product_id
  title          title
  image          image_url
  rating.rate    rating
  rating.count   rating_count

The nested `rating` object is flattened into two independent fields
suitable for storage in a relational table.

------------------------------------------------------------------------

# 10. Relationships

  Relationship   Description
  -------------- --------------------------------------------
  success        Transformation completed
  failure        Invalid JSON or invalid JOLT specification

Connect the **success** relationship to **UpdateRecord**.

------------------------------------------------------------------------

# 11. Validation

Verify that:

-   The processor is running.
-   The transformed FlowFile contains renamed fields.
-   The nested `rating` object no longer exists.
-   New fields `product_id`, `image_url`, `rating`, and `rating_count`
    are present.

Use **Data Provenance → View Content** to inspect the transformed JSON.

------------------------------------------------------------------------

# 12. Common Errors

  ---------------------------------------------------------------------------
  Error            Possible Cause                      Solution
  ---------------- ----------------------------------- ----------------------
  Invalid JOLT     Incorrect JSON syntax               Validate the
  specification                                        specification

  Transformation   Wrong operation type                Use the correct JOLT
  failed                                               operation

  Missing fields   Incorrect mapping                   Verify source field
                                                       names

  Empty output     Invalid specification               Test incrementally
  ---------------------------------------------------------------------------

------------------------------------------------------------------------

# 13. Best Practices

-   Validate the input JSON before creating the JOLT specification.
-   Start with simple field mappings and gradually add complexity.
-   Flatten nested structures before loading into relational databases.
-   Keep transformation rules readable and well documented.

------------------------------------------------------------------------

# 14. Expected Output

After successful execution:

-   Field names match the PostgreSQL table schema.
-   Nested JSON is flattened.
-   Records are ready for additional processing in **UpdateRecord**.

------------------------------------------------------------------------

# 15. Self-Assessment

1.  Why is JoltTransformJSON required?
2.  What is the purpose of the **Shift** operation?
3.  Why should nested JSON be flattened before loading into PostgreSQL?
4.  Which processor receives the transformed FlowFiles next?
5.  Which fields were renamed in this experiment?

------------------------------------------------------------------------

# 16. Chapter Summary

This chapter introduced the JoltTransformJSON processor and demonstrated
how JOLT specifications are used to reshape JSON documents. Students
transformed nested API responses into a relational format suitable for
loading into PostgreSQL, completing the primary transformation stage of
the ETL pipeline.

------------------------------------------------------------------------

**Next Chapter:** Chapter-07-UpdateRecord.md
