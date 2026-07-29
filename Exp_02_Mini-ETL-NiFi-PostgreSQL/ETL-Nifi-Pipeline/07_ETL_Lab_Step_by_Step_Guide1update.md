# Mini ETL Laboratory -- Step-by-Step Guide (Version 3)

## Experiment: Building a Mini ETL Pipeline using Apache NiFi and PostgreSQL

> **Objective:** Build an end-to-end ETL pipeline that extracts product
> data from a REST API, transforms it using Apache NiFi, and loads it
> into PostgreSQL.

------------------------------------------------------------------------

# Step 1 -- Verify the Environment

Run:

``` bash
java -version
psql --version
python3 --version
git --version
```

Ensure Java 21, PostgreSQL, Python and Git are installed.

------------------------------------------------------------------------

# Step 2 -- Start PostgreSQL

``` bash
sudo systemctl start postgresql
sudo systemctl status postgresql
```

Expected: **active (running)**.

------------------------------------------------------------------------

# Step 3 -- Start Apache NiFi

``` bash
cd ~/Mini-ETL-NiFi-PostgreSQL/software/nifi/bin
./nifi.sh start
./nifi.sh status
```

Wait until **Status: UP**.

Open:

``` text
https://localhost:8443/nifi/
```

Accept the browser certificate warning and sign in.

------------------------------------------------------------------------

# Step 4 -- Understand the NiFi Interface

The left toolbar contains: - Processor - Input Port - Output Port -
Funnel - Process Group - Label

The canvas is the workspace where processors are connected to create a
data flow.

------------------------------------------------------------------------

# Step 5 -- Create the ETL Flow

Create the following processors in order:

1.  InvokeHTTP
2.  SplitJson
3.  JoltTransformJSON
4.  UpdateRecord
5.  PutDatabaseRecord

To add a processor: 1. Drag the **Processor** icon from the left
toolbar. 2. Drop it on the canvas. 3. Double-click it. 4. Search for the
processor name. 5. Click **Add**. 6. Rename if required.

------------------------------------------------------------------------

# Step 6 -- Configure InvokeHTTP

Open **Properties**.

  Property                 Value
  ------------------------ -----------------------------------
  HTTP Method              GET
  Remote URL               https://fakestoreapi.com/products
  Always Output Response   true
  Follow Redirects         true

Click **Apply**.

Purpose: Extract JSON data from the REST API.

------------------------------------------------------------------------

# Step 7 -- Configure SplitJson

Open **Properties**.

  Property              Value
  --------------------- -------
  JsonPath Expression   \$.\*

Purpose: Split the returned JSON array into one FlowFile per product.

------------------------------------------------------------------------

# Step 8 -- Configure JoltTransformJSON

Open **Properties**.

Set **Jolt Transform = Shift**.

Paste:

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

Purpose: Convert nested API JSON into a relational structure.

------------------------------------------------------------------------

# Step 9 -- Configure UpdateRecord

Open **Properties**.

## Create JsonTreeReader

-   Record Reader → Create New Service
-   Select **JsonTreeReader**
-   Click **Create**

## Create JsonRecordSetWriter

-   Record Writer → Create New Service
-   Select **JsonRecordSetWriter**
-   Click **Create**

Click **Apply**.

------------------------------------------------------------------------

# Step 10 -- Configure PutDatabaseRecord

Create a **DBCPConnectionPool** controller service.

Configure:

  Property   Value
  ---------- ------------------------------------------
  JDBC URL   jdbc:postgresql://localhost:5432/etl_lab
  Driver     org.postgresql.Driver
  Username   etluser
  Password   etl@123

Processor settings:

  Property                   Value
  -------------------------- --------------------
  Database Connection Pool   DBCPConnectionPool
  Table Name                 products
  Statement Type             INSERT
  Record Reader              JsonTreeReader

------------------------------------------------------------------------

# Step 11 -- Connect Processors

Drag the **success** relationship:

InvokeHTTP → SplitJson → JoltTransformJSON → UpdateRecord →
PutDatabaseRecord

------------------------------------------------------------------------

# Step 12 -- Enable Controller Services

Enable: - DBCPConnectionPool - JsonTreeReader - JsonRecordSetWriter

Wait until all services become **green**.

------------------------------------------------------------------------

# Step 13 -- Run the Pipeline

Start in reverse dependency order:

1.  PutDatabaseRecord
2.  UpdateRecord
3.  JoltTransformJSON
4.  SplitJson
5.  InvokeHTTP

Observe queue counts until processing completes.

------------------------------------------------------------------------

# Step 14 -- Validate the Database

``` bash
sudo -u postgres psql -d etl_lab
```

``` sql
SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 10;
SELECT category, COUNT(*) FROM products GROUP BY category;
```

------------------------------------------------------------------------

# Step 15 -- Export the Flow

Use **Download Flow Definition** and save as **MiniETL.json**.

------------------------------------------------------------------------

# Step 16 -- Generate Reports

``` bash
./generate_student_report_V2.sh
./assignment_grading_v2.sh
./pipeline_validation_report.sh
./final_lab_report.sh
```

------------------------------------------------------------------------

# Troubleshooting

-   Verify Java 21 using `java -version`.
-   Ensure NiFi reports **Status: UP**.
-   Test with `curl -k https://localhost:8443/nifi/`.
-   Accept the HTTPS certificate warning.
-   Confirm PostgreSQL is running.
-   Ensure controller services are enabled (green).

------------------------------------------------------------------------

# Submission Checklist

-   Environment verified
-   PostgreSQL running
-   NiFi running
-   ETL flow created
-   Controller services enabled
-   Data loaded into PostgreSQL
-   SQL validation completed
-   MiniETL.json exported
-   Reports generated
