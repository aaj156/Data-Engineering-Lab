# Chapter 05 -- SplitJson Processor

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

The **SplitJson** processor divides a JSON array into multiple
FlowFiles, where each FlowFile contains a single JSON object. This
allows Apache NiFi to process each record independently, improving
scalability, error handling, and downstream processing.

In this experiment, the Fake Store REST API returns an array of
products. SplitJson converts that array into individual product records
before transformation.

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
```

SplitJson is the first step in the **Transform** phase.

------------------------------------------------------------------------

# 3. Why SplitJson?

Without SplitJson:

-   One FlowFile contains all products.
-   Individual record processing is difficult.
-   A single error may affect the entire dataset.

With SplitJson:

-   One product = One FlowFile.
-   Records are processed independently.
-   Better parallelism and fault isolation.

------------------------------------------------------------------------

# 4. Input and Output

### Input

``` json
[
  {
    "id":1,
    "title":"Backpack"
  },
  {
    "id":2,
    "title":"T-Shirt"
  }
]
```

### Output

FlowFile 1

``` json
{
  "id":1,
  "title":"Backpack"
}
```

FlowFile 2

``` json
{
  "id":2,
  "title":"T-Shirt"
}
```

------------------------------------------------------------------------

# 5. Add the Processor

1.  Drag a **Processor** to the NiFi canvas.
2.  Search for **SplitJson**.
3.  Click **Add**.
4.  Connect **InvokeHTTP → SplitJson**.

> **Screenshot Placeholder:** Adding the SplitJson processor

------------------------------------------------------------------------

# 6. Configuration

## Scheduling

  Property           Value
  ------------------ --------------
  Run Schedule       0 sec
  Concurrent Tasks   1
  Execution          Timer Driven

## Properties

  Property                    Value
  --------------------------- ------------------------
  JsonPath Expression         `$.*`
  Null Value Representation   empty string (default)

> **Note:** If the input JSON is a root array, `$.*` creates one
> FlowFile per array element.

------------------------------------------------------------------------

# 7. Relationships

  Relationship   Description
  -------------- ----------------------------------
  splits         Successfully generated FlowFiles
  original       Original JSON array
  failure        Invalid JSON or processing error

Connect the **splits** relationship to **JoltTransformJSON**.

------------------------------------------------------------------------

# 8. FlowFile Behaviour

After execution:

-   Original array → 20 individual FlowFiles (for the Fake Store API).
-   Each FlowFile contains exactly one product record.
-   Each FlowFile keeps its own attributes and provenance.

------------------------------------------------------------------------

# 9. Validation

Verify that:

-   SplitJson status is **Running**.
-   Queue after SplitJson contains multiple FlowFiles.
-   Provenance shows FlowFiles created from the original array.
-   Each FlowFile contains one JSON object.

------------------------------------------------------------------------

# 10. Common Errors

  -------------------------------------------------------------------------
  Error          Possible Cause                      Solution
  -------------- ----------------------------------- ----------------------
  Invalid        Incorrect expression                Use `$.*` for a root
  JsonPath                                           array

  No FlowFiles   Input is not an array               Verify InvokeHTTP
  generated                                          output

  Failure        Malformed JSON                      Validate API response
  relationship                                       
  triggered                                          

  Queue not      Downstream processor stopped        Start the next
  increasing                                         processor
  -------------------------------------------------------------------------

------------------------------------------------------------------------

# 11. Best Practices

-   Confirm the JSON structure before selecting a JsonPath.
-   Use Data Provenance to inspect split records.
-   Keep the original relationship if auditing is required.
-   Process one logical record per FlowFile whenever possible.

------------------------------------------------------------------------

# 12. Expected Output

After successful execution:

-   One input JSON array becomes multiple FlowFiles.
-   Each FlowFile contains one product.
-   The FlowFiles are transferred to **JoltTransformJSON**.

------------------------------------------------------------------------

# 13. Self-Assessment

1.  Why is SplitJson required in this experiment?
2.  What does the JsonPath `$.*` represent?
3.  Which relationship carries the split records?
4.  What happens if the input is not a JSON array?
5.  How many FlowFiles are expected from the Fake Store API response?

------------------------------------------------------------------------

# 14. Chapter Summary

This chapter explained how the SplitJson processor converts a JSON array
into individual FlowFiles. This enables record-level transformation,
validation, and loading, making the ETL pipeline more scalable and
easier to debug.

------------------------------------------------------------------------

**Next Chapter:** Chapter-06-JoltTransformJSON.md
