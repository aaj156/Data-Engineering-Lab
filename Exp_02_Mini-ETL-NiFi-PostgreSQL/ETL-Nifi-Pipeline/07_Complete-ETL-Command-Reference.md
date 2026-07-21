# Mini ETL Laboratory -- Complete Command Reference

## Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

This document consolidates the essential commands, configurations, and
actions from Chapters 1--11. Each entry explains **what to do**, **where
to do it**, and **why it is required**.

------------------------------------------------------------------------

# Chapter 01 -- Environment Preparation

  ------------------------------------------------------------------------------
  Command / Action                           Purpose
  ------------------------------------------ -----------------------------------
  `sudo apt update && sudo apt upgrade -y`   Update package lists and install
                                             latest security updates.

  `java -version`                            Verify Java 21 installation
                                             required by Apache NiFi.

  `python3 --version`                        Verify Python installation.

  `git --version`                            Verify Git installation.

  `psql --version`                           Verify PostgreSQL client
                                             installation.

  `tree -L 2`                                Display project directory
                                             structure.
  ------------------------------------------------------------------------------

------------------------------------------------------------------------

# Chapter 02 -- ETL Architecture

  ------------------------------------------------------------------------------
  Command / Configuration                    Purpose
  ------------------------------------------ -----------------------------------
  `curl https://fakestoreapi.com/products`   Test REST API accessibility.

  `SELECT COUNT(*) FROM products;`           Verify records after ETL execution.

  `\dt`                                      Display PostgreSQL tables.
  ------------------------------------------------------------------------------

------------------------------------------------------------------------

# Chapter 03 -- Apache NiFi Basics

  ---------------------------------------------------------------------------------------
  Command / Action                                    Purpose
  --------------------------------------------------- -----------------------------------
  `cd ~/Mini-ETL-NiFi-PostgreSQL/software/nifi/bin`   Navigate to NiFi binaries.

  `./nifi.sh start`                                   Start Apache NiFi.

  `./nifi.sh stop`                                    Stop Apache NiFi.

  `./nifi.sh status`                                  Check NiFi status.

  `tail -f ../logs/nifi-app.log`                      Monitor NiFi logs.

  Open `https://localhost:8443/nifi`                  Access NiFi Web UI.
  ---------------------------------------------------------------------------------------

------------------------------------------------------------------------

# Chapter 04 -- InvokeHTTP

  Configuration            Value                                 Why
  ------------------------ ------------------------------------- --------------------------------------
  Processor                InvokeHTTP                            Extract data from REST API.
  HTTP Method              `GET`                                 Retrieve data.
  Remote URL               `https://fakestoreapi.com/products`   Source dataset.
  Always Output Response   `true`                                Store API response in FlowFile.
  Follow Redirects         `true`                                Handle HTTP redirects automatically.

------------------------------------------------------------------------

# Chapter 05 -- SplitJson

  Configuration   Value       Why
  --------------- ----------- ------------------------------------------
  Processor       SplitJson   Split JSON array into records.
  JsonPath        `$.*`       Select every element of the root array.
  Relationship    `splits`    Send individual JSON objects downstream.

------------------------------------------------------------------------

# Chapter 06 -- JoltTransformJSON

  Configuration   Value               Why
  --------------- ------------------- ----------------------------
  Processor       JoltTransformJSON   Restructure JSON.
  Transform       Shift               Rename/map fields.
  Input           Split JSON          One record at a time.
  Output          Flattened JSON      Matches PostgreSQL schema.

### JOLT Mapping

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

Purpose: Convert nested REST API JSON into a relational-friendly
structure.

------------------------------------------------------------------------

# Chapter 07 -- UpdateRecord

  Configuration   Value                 Why
  --------------- --------------------- ------------------------
  Record Reader   JsonTreeReader        Read JSON records.
  Record Writer   JsonRecordSetWriter   Write updated records.
  RecordPath      `/category`           Update category field.
  Derived Field   `processed_by`        Store ETL metadata.
  Derived Field   `source_system`       Track data origin.

Purpose: Clean, standardize, and enrich records before loading.

------------------------------------------------------------------------

# Chapter 08 -- PutDatabaseRecord

  --------------------------------------------------------------------------------------------
  Configuration           Value                                        Why
  ----------------------- -------------------------------------------- -----------------------
  JDBC URL                `jdbc:postgresql://localhost:5432/etl_lab`   Connect to PostgreSQL.

  Driver                  `org.postgresql.Driver`                      JDBC driver class.

  Table                   `products`                                   Destination table.

  Statement Type          INSERT                                       Insert transformed
                                                                       records.

  Record Reader           JsonTreeReader                               Read JSON input.
  --------------------------------------------------------------------------------------------

Useful SQL:

``` sql
SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 10;
SELECT category, COUNT(*) FROM products GROUP BY category;
```

Purpose: Validate successful database loading.

------------------------------------------------------------------------

# Chapter 09 -- Running the Pipeline

## Start Order

1.  Enable Controller Services
2.  PutDatabaseRecord
3.  UpdateRecord
4.  JoltTransformJSON
5.  SplitJson
6.  InvokeHTTP

## Stop Order

1.  InvokeHTTP
2.  SplitJson
3.  JoltTransformJSON
4.  UpdateRecord
5.  PutDatabaseRecord

Purpose: Prevent incomplete processing and queue buildup.

------------------------------------------------------------------------

# Chapter 10 -- Validation

  ------------------------------------------------------------------------------------------------------------------------
  Command                                                                              Purpose
  ------------------------------------------------------------------------------------ -----------------------------------
  `curl https://fakestoreapi.com/products`                                             Verify REST API.

  `SELECT COUNT(*) FROM products;`                                                     Verify inserted records.

  `SELECT * FROM products LIMIT 10;`                                                   Inspect data.

  `\d products`                                                                        Verify schema.

  `SELECT indexname FROM pg_indexes WHERE tablename='products';`                       Verify indexes.

  `SELECT product_id, COUNT(*) FROM products GROUP BY product_id HAVING COUNT(*)>1;`   Detect duplicates.
  ------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

# Chapter 11 -- Industry Best Practices

  Action                                    Purpose
  ----------------------------------------- ------------------------------------
  Use Process Groups                        Improve organization.
  Configure Failure Relationships           Prevent data loss.
  Enable Back Pressure                      Protect system resources.
  Monitor Provenance                        Debug FlowFiles.
  Use Git for SQL, NiFi flows and scripts   Version control.
  Export `MiniETL.json`                     Reuse and submit the ETL pipeline.
  Capture screenshots                       Document experiment evidence.
  Generate reports                          Support assessment and grading.

------------------------------------------------------------------------

# Overall ETL Execution Flow

``` text
Start PostgreSQL
      ↓
Start Apache NiFi
      ↓
Open NiFi UI
      ↓
Configure InvokeHTTP
      ↓
Configure SplitJson
      ↓
Configure JoltTransformJSON
      ↓
Configure UpdateRecord
      ↓
Configure PutDatabaseRecord
      ↓
Enable Controller Services
      ↓
Run Pipeline
      ↓
Validate PostgreSQL
      ↓
Export MiniETL.json
      ↓
Generate Report
```
