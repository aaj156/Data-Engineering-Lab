# Chapter 04 -- InvokeHTTP Processor

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

------------------------------------------------------------------------

# 1. Introduction

The **InvokeHTTP** processor is the starting point of the ETL pipeline.
It sends HTTP requests to web services or REST APIs and receives the
response as a FlowFile. In this experiment, it extracts product data
from the Fake Store REST API.

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
```

InvokeHTTP performs the **Extract** phase of ETL by retrieving raw JSON
data.

------------------------------------------------------------------------

# 3. Why InvokeHTTP?

-   Connects to REST APIs
-   Supports HTTP/HTTPS
-   Retrieves JSON, XML, CSV and text
-   Supports authentication methods
-   Generates FlowFiles for downstream processors

------------------------------------------------------------------------

# 4. REST API Used

**URL**

``` text
https://fakestoreapi.com/products
```

**Method**

``` text
GET
```

Expected Response:

-   Status Code: **200 OK**
-   MIME Type: **application/json**
-   JSON array of products

------------------------------------------------------------------------

# 5. How InvokeHTTP Works

1.  Sends an HTTP GET request.
2.  Waits for the server response.
3.  Creates a FlowFile.
4.  Stores the API response as FlowFile content.
5.  Adds HTTP metadata as FlowFile attributes.
6.  Transfers the FlowFile to the **success** relationship.

------------------------------------------------------------------------

# 6. Add the Processor

1.  Open Apache NiFi.
2.  Drag a **Processor** onto the canvas.
3.  Search for **InvokeHTTP**.
4.  Click **Add**.

> **Screenshot Placeholder:** Adding the InvokeHTTP processor

------------------------------------------------------------------------

# 7. Configuration

## Scheduling

  Property           Value
  ------------------ --------------
  Run Schedule       0 sec
  Concurrent Tasks   1
  Execution          Timer Driven

## Settings

  Property                 Value
  ------------------------ -----------------------------------
  HTTP Method              GET
  Remote URL               https://fakestoreapi.com/products
  Follow Redirects         true
  Always Output Response   true
  Read Timeout             30 sec
  Penalization Period      30 sec

------------------------------------------------------------------------

# 8. Relationships

  Relationship   Description
  -------------- -----------------------------------
  success        Request completed successfully
  retry          Temporary communication failure
  no retry       Permanent failure
  response       Optional response FlowFile
  original       Original FlowFile (if applicable)

For this experiment, connect the **success** relationship to
**SplitJson**.

------------------------------------------------------------------------

# 9. FlowFile Content

Example:

``` json
[
  {
    "id":1,
    "title":"Fjallraven Backpack",
    "price":109.95,
    "category":"men's clothing"
  }
]
```

------------------------------------------------------------------------

# 10. FlowFile Attributes

Common attributes generated include:

  Attribute                   Example
  --------------------------- ------------------
  mime.type                   application/json
  invokehttp.status.code      200
  invokehttp.status.message   OK
  uuid                        Auto-generated

------------------------------------------------------------------------

# 11. Validation

Verify that:

-   Processor status is **Running**
-   FlowFiles are generated
-   HTTP status is **200**
-   Queue between InvokeHTTP and SplitJson contains FlowFiles
-   Data Provenance shows successful execution

------------------------------------------------------------------------

# 12. Common Errors

  ------------------------------------------------------------------------
  Error         Possible Cause                      Solution
  ------------- ----------------------------------- ----------------------
  404 Not Found Incorrect URL                       Verify Remote URL

  500 Internal  API issue                           Retry later
  Server Error                                      

  SSL Error     Certificate/network issue           Check internet or
                                                    HTTPS configuration

  Connection    No internet                         Verify connectivity
  Refused                                           

  Empty         API unavailable                     Test URL in browser or
  Response                                          curl
  ------------------------------------------------------------------------

------------------------------------------------------------------------

# 13. Best Practices

-   Test the API URL in a browser before configuring NiFi.
-   Keep timeout values reasonable.
-   Handle retry relationships where appropriate.
-   Monitor processor bulletins for errors.
-   Check Data Provenance after each run.

------------------------------------------------------------------------

# 14. Expected Output

After successful execution:

-   One FlowFile containing the JSON array is produced.
-   The FlowFile is transferred to **SplitJson**.
-   The processor icon turns green while running.

------------------------------------------------------------------------

# 15. Self-Assessment

1.  What is the purpose of InvokeHTTP?
2.  Why is GET used in this experiment?
3.  Which relationship carries successful FlowFiles?
4.  Where is the JSON response stored?
5.  Which FlowFile attribute stores the HTTP status code?

------------------------------------------------------------------------

# 16. Chapter Summary

This chapter introduced the InvokeHTTP processor and demonstrated how it
performs the Extract phase of the ETL pipeline by consuming a REST API
and generating FlowFiles for downstream processing.

------------------------------------------------------------------------

**Next Chapter:** Chapter-05-SplitJson.md
