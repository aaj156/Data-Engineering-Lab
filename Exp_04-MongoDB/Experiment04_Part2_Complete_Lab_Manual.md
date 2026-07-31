# Experiment 04 -- Part 2 Complete Laboratory Manual

## Industry-Grade ETL Pipeline using REST API, Python and MongoDB

**Subject:** Data Engineering Laboratory

------------------------------------------------------------------------

## Preface

This manual combines all sections of Experiment 04 -- Part 2 into a
single classroom-ready reference. It guides students through designing,
implementing, testing, and evaluating an industry-style ETL pipeline
using Python and MongoDB.

------------------------------------------------------------------------

# Table of Contents

1.  Part A.1 -- Introduction & Architecture
2.  Part A.2 -- Environment Setup
3.  Part B.1 -- Configuration & Data Extraction
4.  Part B.2 -- Validation & Transformation
5.  Part C -- Main ETL Pipeline
6.  Part D -- MongoDB Operations
7.  Part E -- Mini Project & Assessment
8.  Appendix A -- Software Versions
9.  Appendix B -- Project Directory
10. Appendix C -- Submission Checklist

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART A.1 -- Introduction & Architecture

## Data Engineering Laboratory

------------------------------------------------------------------------

# Experiment Details

  ---------------------------------------------------------------------
  Item                        Details
  --------------------------- -----------------------------------------
  Experiment No.              04

  Experiment Title            Industry-Grade ETL Pipeline using REST
                              API, Python and MongoDB

  Subject                     Data Engineering Laboratory

  Tools Used                  Ubuntu 24.04 (WSL), Python 3.x, MongoDB
                              8.x, MongoDB Compass, VS Code

  Database                    MongoDB

  Programming Language        Python

  Data Source                 DummyJSON REST API
  ---------------------------------------------------------------------

------------------------------------------------------------------------

# Aim

To develop an industry-grade ETL pipeline that extracts data from a REST
API, validates and transforms the data using Python, loads it into
MongoDB, performs CRUD operations, executes aggregation queries, and
exports processed datasets.

------------------------------------------------------------------------

# Objectives

After completing this experiment, students will be able to:

1.  Explain the ETL process.
2.  Retrieve JSON data from a REST API.
3.  Validate incoming data.
4.  Transform JSON documents.
5.  Store documents in MongoDB.
6.  Perform CRUD operations.
7.  Execute aggregation pipelines.
8.  Export data to JSON and CSV.
9.  Build a modular ETL application.

------------------------------------------------------------------------

# Learning Outcomes

Students will be able to:

-   Design an ETL workflow.
-   Consume REST APIs.
-   Process semi-structured JSON data.
-   Validate and transform data.
-   Perform incremental loading using Upsert.
-   Query MongoDB using CRUD and Aggregation.
-   Export processed datasets.
-   Develop modular Python applications.

------------------------------------------------------------------------

# Introduction

Modern organizations collect data from web applications, IoT devices,
cloud services, mobile applications, and enterprise systems. Before this
data becomes useful, it must be collected, validated, transformed, and
stored. This complete process is called **ETL (Extract, Transform and
Load)** and forms the backbone of modern Data Engineering.

In this experiment, students will implement an ETL pipeline that
downloads product information from the DummyJSON REST API, transforms
the data, stores it in MongoDB, and performs analysis using MongoDB
queries.

------------------------------------------------------------------------

# ETL Overview

  Stage       Description
  ----------- ----------------------------------------
  Extract     Collect data from the REST API.
  Transform   Validate, clean and enrich the data.
  Load        Store the processed data into MongoDB.

------------------------------------------------------------------------

# ETL Architecture

``` text
REST API
   │
   ▼
Extract
   │
   ▼
Validation
   │
   ▼
Transformation
   │
   ▼
MongoDB (Upsert)
   │
   ├── CRUD
   ├── Aggregation
   └── Export JSON / CSV
```

------------------------------------------------------------------------

# REST API

A REST API allows applications to communicate over HTTP.

HTTP methods:

  Method   Purpose
  -------- ---------------
  GET      Retrieve data
  POST     Create data
  PUT      Replace data
  PATCH    Update data
  DELETE   Delete data

This experiment uses only the **GET** method.

API Endpoint:

``` text
https://dummyjson.com/products
```

------------------------------------------------------------------------

# Sample JSON

``` json
{
  "id":1,
  "title":"Essence Mascara Lash Princess",
  "price":9.99,
  "category":"beauty",
  "brand":"Essence",
  "rating":2.56,
  "stock":99
}
```

------------------------------------------------------------------------

# MongoDB Overview

MongoDB is a NoSQL document-oriented database that stores information as
BSON documents.

  Relational Database   MongoDB
  --------------------- ------------
  Database              Database
  Table                 Collection
  Row                   Document
  Column                Field
  Primary Key           ObjectId

Advantages:

-   Flexible schema
-   Native JSON-like documents
-   High scalability
-   Excellent Python integration

------------------------------------------------------------------------

# Project Modules

  File              Responsibility
  ----------------- ----------------------
  config.py         Configuration
  extractor.py      Download data
  validator.py      Validate data
  transformer.py    Transform data
  loader.py         Load into MongoDB
  exporter.py       Export JSON/CSV
  products_etl.py   Execute ETL workflow

------------------------------------------------------------------------

# Software Requirements

-   Ubuntu 24.04 LTS
-   Python 3.11+
-   MongoDB 8.x
-   MongoDB Compass
-   Internet connection

------------------------------------------------------------------------

# Prerequisites

Students should have completed:

-   Experiment 04 -- Part 1 (MongoDB Installation)
-   Basic Linux Commands
-   Python Fundamentals
-   JSON Basics
-   MongoDB CRUD Operations

------------------------------------------------------------------------

# Project Structure (Preview)

``` text
Exp04_Part2/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── exports/
├── logs/
├── output/
├── config.py
├── extractor.py
├── validator.py
├── transformer.py
├── loader.py
├── exporter.py
├── products_etl.py
├── requirements.txt
└── README.md
```

------------------------------------------------------------------------

# Experiment Workflow

``` text
Create Workspace
      │
      ▼
Configure Python
      │
      ▼
Test REST API
      │
      ▼
Develop ETL Modules
      │
      ▼
Execute ETL
      │
      ▼
Verify MongoDB
      │
      ▼
CRUD Operations
      │
      ▼
Aggregation
      │
      ▼
Export JSON / CSV
```

------------------------------------------------------------------------

# Checkpoint

Before proceeding to **Part A.2**, you should understand:

-   ETL workflow
-   REST API basics
-   JSON structure
-   MongoDB document model
-   Purpose of each ETL module

------------------------------------------------------------------------

# Next Part

**PART A.2 -- Environment Setup**

Students will:

1.  Create the project workspace.
2.  Build the folder structure.
3.  Configure a Python virtual environment.
4.  Install dependencies.
5.  Verify MongoDB.
6.  Test the REST API.

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART A.2 -- Environment Setup

This section performs the initial environment setup required before
building the ETL pipeline.

------------------------------------------------------------------------

# Step 1 -- Create the Project Workspace

## Aim

Create a dedicated project directory for the ETL experiment.

## Command

``` bash
mkdir -p ~/Exp04_Part2
cd ~/Exp04_Part2
pwd
```

## Command Explanation

  Command    Purpose
  ---------- ----------------------------------------------------
  mkdir -p   Creates the directory if it does not already exist
  cd         Changes to the project directory
  pwd        Displays the current working directory

## Expected Output

``` text
/home/<username>/Exp04_Part2
```

## Verification

``` bash
ls
```

The directory should be empty.

## Common Errors

**Permission denied**

Solution: Create the folder inside your home directory (`~`).

------------------------------------------------------------------------

# Step 2 -- Create the Project Directory Structure

## Aim

Organize the project using an industry-standard folder layout.

## Commands

``` bash
mkdir -p data/raw
mkdir -p data/processed
mkdir -p data/exports
mkdir logs
mkdir output
```

Verify:

``` bash
tree .
```

If `tree` is not installed:

``` bash
sudo apt install tree -y
tree .
```

## Expected Structure

``` text
Exp04_Part2/
├── data/
│   ├── raw/
│   ├── processed/
│   └── exports/
├── logs/
└── output/
```

------------------------------------------------------------------------

# Step 3 -- Create a Python Virtual Environment

## Why?

A virtual environment isolates project dependencies from the system
Python installation.

## Commands

``` bash
python3 -m venv venv
```

Activate:

``` bash
source venv/bin/activate
```

Verify:

``` bash
python --version
which python
```

## Expected Output

The prompt changes to:

``` text
(venv)
```

------------------------------------------------------------------------

# Step 4 -- Install Required Packages

## Aim

Install all Python libraries required for the ETL pipeline.

## Command

``` bash
pip install requests pymongo pandas
```

Save dependency list:

``` bash
pip freeze > requirements.txt
```

Verify:

``` bash
pip list
```

Packages should include:

-   requests
-   pymongo
-   pandas

------------------------------------------------------------------------

# Step 5 -- Verify MongoDB

Ensure the MongoDB service is running.

``` bash
sudo systemctl status mongod
```

Expected:

``` text
Active: active (running)
```

Connect:

``` bash
mongosh
```

Inside MongoDB:

``` javascript
show dbs
exit
```

------------------------------------------------------------------------

# Step 6 -- Test the REST API

## Aim

Verify that the API is reachable before writing any Python code.

Command:

``` bash
curl https://dummyjson.com/products | head
```

## Explanation

  Part      Meaning
  --------- -----------------------------------
  curl      Sends an HTTP GET request
  URL       REST API endpoint
  \| head   Displays only the first few lines

Expected:

``` json
{
  "products":[
```

------------------------------------------------------------------------

# Step 7 -- Create Initial Project Files

Create all source files now.

``` bash
touch config.py
touch extractor.py
touch validator.py
touch transformer.py
touch loader.py
touch exporter.py
touch products_etl.py
```

Verify:

``` bash
ls
```

Expected:

``` text
config.py
extractor.py
validator.py
transformer.py
loader.py
exporter.py
products_etl.py
requirements.txt
```

------------------------------------------------------------------------

# Checkpoint

At this stage you should have:

-   Project workspace created
-   Folder structure created
-   Python virtual environment activated
-   Dependencies installed
-   MongoDB verified
-   REST API tested
-   Empty Python source files created

------------------------------------------------------------------------

# Troubleshooting

## ModuleNotFoundError

Activate the virtual environment again:

``` bash
source venv/bin/activate
```

## mongosh: command not found

Complete Experiment 04 Part 1 and verify MongoDB installation.

## curl: command not found

``` bash
sudo apt install curl -y
```

------------------------------------------------------------------------

# Next Part

**PART B.1 -- Creating `config.py` and `extractor.py`**

Students will create their first Python modules, understand
configuration management, perform HTTP GET requests using the `requests`
library, and retrieve JSON data from the REST API.

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART B.1 -- Creating `config.py` and `extractor.py`

## Objective

In this part, students will create the first two modules of the ETL
project:

-   `config.py` -- stores configuration values.
-   `extractor.py` -- retrieves product data from the REST API.

------------------------------------------------------------------------

# Module 1 -- config.py

## Aim

Create a central configuration file so application settings are
maintained in one place.

## Step 1: Create the file

``` bash
nano config.py
```

## Step 2: Enter the following code

``` python
API_URL = "https://dummyjson.com/products"
MONGO_URI = "mongodb://localhost:27017/"
DATABASE = "ProductDB"
COLLECTION = "products"
REQUEST_TIMEOUT = 10
```

## Explanation

  Variable          Purpose
  ----------------- ---------------------------
  API_URL           REST API endpoint
  MONGO_URI         MongoDB connection string
  DATABASE          Database name
  COLLECTION        Collection name
  REQUEST_TIMEOUT   HTTP timeout (seconds)

## Save

Press:

``` text
Ctrl + O
Enter
Ctrl + X
```

## Verify

``` bash
cat config.py
```

------------------------------------------------------------------------

# Module 2 -- extractor.py

## Aim

Download JSON data from the REST API.

## Step 1: Create the file

``` bash
nano extractor.py
```

## Step 2: Enter the following code

``` python
import requests
from config import API_URL, REQUEST_TIMEOUT

def extract_data():
    response = requests.get(API_URL, timeout=REQUEST_TIMEOUT)
    response.raise_for_status()

    payload = response.json()
    return payload["products"]


if __name__ == "__main__":
    products = extract_data()
    print(f"Downloaded {len(products)} products.")
    print(products[0])
```

## Code Explanation

-   `requests.get()` sends an HTTP GET request.
-   `timeout` prevents the request from waiting indefinitely.
-   `raise_for_status()` raises an exception if the server returns an
    error.
-   `response.json()` converts JSON into Python objects.
-   The API response contains a key named `products`; the function
    returns only that list.

------------------------------------------------------------------------

# Run the Program

``` bash
python extractor.py
```

## Expected Output

``` text
Downloaded 194 products.
{'id': 1, 'title': 'Essence Mascara Lash Princess', ...}
```

(The exact number of products may change if the API is updated.)

------------------------------------------------------------------------

# Verification

Confirm that:

-   The program runs without errors.
-   The number of downloaded products is displayed.
-   The first product is printed as a Python dictionary.

------------------------------------------------------------------------

# Common Errors

## ModuleNotFoundError: requests

Install the package:

``` bash
pip install requests
```

## ConnectionError

Check your internet connection and verify that the API endpoint is
reachable:

``` bash
curl https://dummyjson.com/products
```

## Timeout

Increase `REQUEST_TIMEOUT` in `config.py` if your network is slow.

------------------------------------------------------------------------

# Checkpoint

At the end of this section, you should have:

-   A reusable configuration module.
-   A working extractor module.
-   Successful retrieval of product data from the REST API.

------------------------------------------------------------------------

# Next Part

**PART B.2 -- Creating `validator.py` and `transformer.py`**

Students will validate incoming records, remove invalid data, rename
fields, flatten nested objects, and prepare documents for MongoDB.

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART B.2 -- Creating `validator.py` and `transformer.py`

## Objective

In this part you will:

-   Validate records received from the REST API.
-   Reject incomplete or invalid records.
-   Transform the data into a MongoDB-friendly format.

------------------------------------------------------------------------

# Module 3 -- validator.py

## Aim

Validate every product before it is loaded into MongoDB.

## Why Validation?

Real-world data can contain:

-   Missing values
-   Invalid data types
-   Negative prices
-   Empty fields

Validation improves data quality before loading.

------------------------------------------------------------------------

## Step 1 -- Create the file

``` bash
nano validator.py
```

------------------------------------------------------------------------

## Step 2 -- Enter the following code

``` python
def validate_product(product):
    required_fields = ["id", "title", "price", "category"]

    for field in required_fields:
        if field not in product:
            return False

    if not isinstance(product["price"], (int, float)):
        return False

    if product["price"] < 0:
        return False

    if str(product["title"]).strip() == "":
        return False

    return True
```

------------------------------------------------------------------------

## Code Explanation

  Code              Purpose
  ----------------- ----------------------------
  required_fields   Fields that must exist
  for loop          Checks each required field
  isinstance()      Confirms numeric price
  price \< 0        Rejects invalid prices
  strip()           Rejects empty titles
  return True       Record passed validation

------------------------------------------------------------------------

## Quick Test

Create a temporary test file.

``` bash
nano test_validator.py
```

``` python
from validator import validate_product

sample = {
    "id":1,
    "title":"Laptop",
    "price":65000,
    "category":"electronics"
}

print(validate_product(sample))
```

Run:

``` bash
python test_validator.py
```

Expected:

``` text
True
```

------------------------------------------------------------------------

# Module 4 -- transformer.py

## Aim

Transform validated records into the desired schema.

------------------------------------------------------------------------

## Why Transformation?

Transformation helps to:

-   Standardize field names
-   Add metadata
-   Flatten nested objects
-   Convert data types
-   Prepare documents for analytics

------------------------------------------------------------------------

## Step 1 -- Create the file

``` bash
nano transformer.py
```

------------------------------------------------------------------------

## Step 2 -- Enter the following code

``` python
from datetime import datetime

def transform_product(product):
    transformed = {
        "_id": product["id"],
        "product_name": product["title"],
        "product_price": float(product["price"]),
        "product_category": product["category"],
        "manufacturer": product.get("brand", "Unknown"),
        "rating": product.get("rating", 0),
        "stock": product.get("stock", 0),
        "source": "DummyJSON API",
        "ingestion_date": datetime.utcnow().isoformat()
    }

    if "dimensions" in product:
        dims = product["dimensions"]
        transformed["width"] = dims.get("width")
        transformed["height"] = dims.get("height")
        transformed["depth"] = dims.get("depth")

    return transformed
```

------------------------------------------------------------------------

## Field Mapping

  API Field   MongoDB Field
  ----------- ------------------
  id          \_id
  title       product_name
  price       product_price
  category    product_category
  brand       manufacturer

------------------------------------------------------------------------

## Code Explanation

-   `_id` is mapped from the API `id` to avoid duplicate documents.
-   `get()` safely retrieves optional fields.
-   `float()` ensures a consistent numeric type.
-   `ingestion_date` stores when the record entered the system.
-   Nested `dimensions` are flattened into separate fields.

------------------------------------------------------------------------

## Test the Transformer

Create:

``` bash
nano test_transformer.py
```

``` python
from transformer import transform_product

sample = {
    "id":1,
    "title":"Laptop",
    "price":65000,
    "category":"electronics",
    "brand":"ABC",
    "dimensions":{
        "width":25,
        "height":2,
        "depth":18
    }
}

print(transform_product(sample))
```

Run:

``` bash
python test_transformer.py
```

Expected output includes:

``` text
{
 '_id': 1,
 'product_name': 'Laptop',
 'product_price': 65000.0,
 'manufacturer': 'ABC',
 'width': 25,
 'height': 2,
 'depth': 18,
 ...
}
```

------------------------------------------------------------------------

# Checkpoint

You should now have:

-   `validator.py`
-   `transformer.py`
-   Successful validation tests
-   Successful transformation tests

------------------------------------------------------------------------

# Common Errors

## KeyError

Ensure required fields exist before transformation.

## IndentationError

Use consistent indentation (4 spaces).

## SyntaxError

Check missing commas, quotes, or brackets.

------------------------------------------------------------------------

# Summary

In this section you learned how to:

-   Validate incoming JSON records.
-   Reject invalid data.
-   Rename fields.
-   Flatten nested objects.
-   Add metadata.
-   Prepare clean MongoDB documents.

------------------------------------------------------------------------

# Next Part

**PART B.3 -- Creating `loader.py` and `exporter.py`**
# Module 1 -- `loader.py`

## Step 1 -- Create the file

``` bash
nano loader.py
```

## Step 2 -- Code

``` python
from pymongo import MongoClient
from config import MONGO_URI, DATABASE, COLLECTION

def load_products(products):
    client = MongoClient(MONGO_URI)
    db = client[DATABASE]
    collection = db[COLLECTION]

    for product in products:
        collection.replace_one(
            {"_id": product["_id"]},
            product,
            upsert=True
        )

    print(f"Loaded {len(products)} products into MongoDB.")
    client.close()

if __name__ == "__main__":
    print("Run products_etl.py to load products.")
```

### Explanation

-   `MongoClient()` connects to MongoDB.
-   `db[COLLECTION]` selects the collection.
-   `replace_one(..., upsert=True)` updates existing documents or
    inserts new ones.
-   `client.close()` closes the database connection.

### Verification

``` bash
python3 -c "from loader import load_products; print('loader.py imported successfully')"
```

### Verify in MongoDB

``` bash
mongosh
```

``` javascript
use ProductDB
show collections
db.products.countDocuments()
db.products.findOne()
```

------------------------------------------------------------------------

# Module 2 -- `exporter.py`

## Step 1 -- Create the file

``` bash
nano exporter.py
```

## Step 2 -- Code

``` python
import os
import json
import pandas as pd

OUTPUT_DIR = "output"

def export_json(products):
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    with open(f"{OUTPUT_DIR}/products.json", "w") as f:
        json.dump(products, f, indent=4)

def export_csv(products):
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    pd.DataFrame(products).to_csv(
        f"{OUTPUT_DIR}/products.csv",
        index=False
    )

if __name__ == "__main__":
    print("Run products_etl.py to export products.")
```

### Explanation

-   Creates the `output` directory automatically.
-   Exports formatted JSON using `json.dump()`.
-   Exports CSV using `pandas.DataFrame.to_csv()`.

### Verification

``` bash
python3 -c "from exporter import export_json, export_csv; print('exporter.py imported successfully')"
```

Expected output:

    exporter.py imported successfully

### Verify Output

``` bash
ls output
```

Expected:

    products.json
    products.csv

------------------------------------------------------------------------

# Common Errors

  Error                       Solution
  --------------------------- -----------------------
  pymongo not installed       `pip install pymongo`
  pandas not installed        `pip install pandas`
  MongoDB connection failed   Start MongoDB service
  output directory missing    Created automatically

------------------------------------------------------------------------

# Integration Flow

``` text
config.py
   ↓
extractor.py
   ↓
validator.py
   ↓
transformer.py
   ↓
loader.py
   ↓
exporter.py
   ↓
products_etl.py
```

------------------------------------------------------------------------

# Checkpoint

-   [ ] loader.py created
-   [ ] exporter.py created
-   [ ] MongoDB connection verified
-   [ ] JSON export verified
-   [ ] CSV export verified

------------------------------------------------------------------------

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART C -- Building the Main ETL Pipeline (`products_etl.py`)

## Objective

In this part, all previously created modules are integrated into a
single ETL pipeline.

The pipeline will:

1.  Extract product data from the REST API.
2.  Validate each record.
3.  Transform valid records.
4.  Load records into MongoDB using **Upsert**.
5.  Export the processed data to JSON and CSV.
6.  Display an execution summary.

------------------------------------------------------------------------

# ETL Pipeline Flow

``` text
REST API
   │
   ▼
extractor.py
   │
   ▼
validator.py
   │
   ▼
transformer.py
   │
   ▼
loader.py
   │
   ▼
exporter.py
```

------------------------------------------------------------------------

# Step 1 -- Create the Main Program

``` bash
nano products_etl.py
```

------------------------------------------------------------------------

# Step 2 -- Enter the Following Code

``` python
from extractor import extract_data
from validator import validate_product
from transformer import transform_product
from loader import load_products
from exporter import export_json, export_csv

def main():
    print("Starting ETL Pipeline...")

    raw_products = extract_data()

    valid_products = []
    rejected = 0

    for product in raw_products:
        if validate_product(product):
            valid_products.append(transform_product(product))
        else:
            rejected += 1

    load_products(valid_products)

    export_json(valid_products)
    export_csv(valid_products)

    print("\nETL Summary")
    print(f"Total Records   : {len(raw_products)}")
    print(f"Valid Records   : {len(valid_products)}")
    print(f"Rejected Records: {rejected}")

if __name__ == "__main__":
    main()
```

------------------------------------------------------------------------

# Program Explanation

  Statement             Purpose
  --------------------- -------------------------------------------
  extract_data()        Downloads products from the API
  validate_product()    Checks record validity
  transform_product()   Converts to the required schema
  load_products()       Performs incremental loading into MongoDB
  export_json()         Creates a JSON export
  export_csv()          Creates a CSV export

------------------------------------------------------------------------

# Step 3 -- Run the Pipeline

Activate the virtual environment if required.

``` bash
source venv/bin/activate
python products_etl.py
```

------------------------------------------------------------------------

# Expected Output

``` text
Starting ETL Pipeline...

ETL Summary
Total Records   : 194
Valid Records   : 194
Rejected Records: 0
```

(The total number of records may vary if the API dataset changes.)

------------------------------------------------------------------------

# Verify MongoDB

Open the MongoDB shell:

``` bash
mongosh
```

Execute:

``` javascript
use ProductDB
db.products.countDocuments()
db.products.findOne()
```

You should see the imported documents.

------------------------------------------------------------------------

# Verify Export Files

``` bash
ls output
```

Expected files:

``` text
products.json
products.csv
```

Preview the JSON file:

``` bash
head output/products.json
```

Preview the CSV file:

``` bash
head output/products.csv
```

------------------------------------------------------------------------

# Logging (Recommended Enhancement)

Add Python's `logging` module to record ETL execution in `logs/etl.log`.

Typical log entries include:

-   ETL started
-   API request successful
-   Validation complete
-   MongoDB load complete
-   Export completed
-   ETL finished

------------------------------------------------------------------------

# Common Errors

## MongoDB Connection Error

-   Verify MongoDB is running.
-   Confirm `MONGO_URI` in `config.py`.

## ImportError

Ensure all modules (`extractor.py`, `validator.py`, `transformer.py`,
`loader.py`, `exporter.py`) are present in the project directory.

## Permission Denied

Verify write permission for the `output/` directory.

------------------------------------------------------------------------

# Checkpoint

At the end of this part you should have:

-   A complete ETL pipeline.
-   Successful extraction, validation, transformation and loading.
-   MongoDB populated with product data.
-   JSON and CSV export files generated.

------------------------------------------------------------------------

# Next Part

**PART D -- MongoDB Operations**

You will perform CRUD operations, aggregation pipelines, indexing, and
verify the results using MongoDB Compass.

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART D -- MongoDB Operations

## Objective

After loading product data into MongoDB, you will learn how to retrieve,
modify, analyze, and optimize data using MongoDB queries.

------------------------------------------------------------------------

# Step 1 -- Start MongoDB Shell

``` bash
mongosh
```

Select the database:

``` javascript
use ProductDB
show collections
```

Expected collection:

``` text
products
```

------------------------------------------------------------------------

# Step 2 -- Verify Imported Data

Count the documents:

``` javascript
db.products.countDocuments()
```

Display one document:

``` javascript
db.products.findOne()
```

Display the first five documents:

``` javascript
db.products.find().limit(5)
```

------------------------------------------------------------------------

# Step 3 -- Read Operations (Find)

### Find all products

``` javascript
db.products.find()
```

### Find products in the beauty category

``` javascript
db.products.find({product_category:"beauty"})
```

### Find products with price greater than 500

``` javascript
db.products.find({product_price:{$gt:500}})
```

### Find products with rating greater than 4

``` javascript
db.products.find({rating:{$gt:4}})
```

### Projection

Return only selected fields:

``` javascript
db.products.find(
 {},
 {product_name:1,product_price:1,_id:0}
)
```

------------------------------------------------------------------------

# Step 4 -- Sorting and Limiting

Sort by price (ascending):

``` javascript
db.products.find().sort({product_price:1})
```

Sort by price (descending):

``` javascript
db.products.find().sort({product_price:-1})
```

Top 10 expensive products:

``` javascript
db.products.find().sort({product_price:-1}).limit(10)
```

------------------------------------------------------------------------

# Step 5 -- Update Operations

Update stock for one product:

``` javascript
db.products.updateOne(
 {_id:1},
 {$set:{stock:500}}
)
```

Increase stock by 25:

``` javascript
db.products.updateMany(
 {},
 {$inc:{stock:25}}
)
```

Verify:

``` javascript
db.products.find({_id:1})
```

------------------------------------------------------------------------

# Step 6 -- Delete Operations

Delete a single product:

``` javascript
db.products.deleteOne({_id:1})
```

Delete products with zero stock:

``` javascript
db.products.deleteMany({stock:0})
```

Verify:

``` javascript
db.products.countDocuments()
```

------------------------------------------------------------------------

# Step 7 -- Aggregation Framework

## Average Product Price

``` javascript
db.products.aggregate([
 {$group:{_id:null,AveragePrice:{$avg:"$product_price"}}}
])
```

## Products Per Category

``` javascript
db.products.aggregate([
 {$group:{_id:"$product_category",Count:{$sum:1}}},
 {$sort:{Count:-1}}
])
```

## Maximum Price

``` javascript
db.products.aggregate([
 {$group:{_id:null,MaxPrice:{$max:"$product_price"}}}
])
```

## Minimum Price

``` javascript
db.products.aggregate([
 {$group:{_id:null,MinPrice:{$min:"$product_price"}}}
])
```

## Average Rating Per Category

``` javascript
db.products.aggregate([
 {$group:{
   _id:"$product_category",
   AverageRating:{$avg:"$rating"}
 }},
 {$sort:{AverageRating:-1}}
])
```

------------------------------------------------------------------------

# Step 8 -- Create an Index

Create an index on category:

``` javascript
db.products.createIndex({product_category:1})
```

View indexes:

``` javascript
db.products.getIndexes()
```

Why indexes?

-   Faster searching
-   Faster filtering
-   Better query performance

------------------------------------------------------------------------

# Step 9 -- MongoDB Compass Verification

1.  Open MongoDB Compass.
2.  Connect to:

``` text
mongodb://localhost:27017
```

3.  Open **ProductDB**.
4.  Open **products** collection.
5.  Verify:
    -   Document count
    -   Field names
    -   Sample documents
    -   Indexes
6.  Use filters such as:

``` json
{"product_price":{"$gt":500}}
```

and

``` json
{"product_category":"beauty"}
```

------------------------------------------------------------------------

# Practice Exercises

1.  Find all products with stock greater than 100.
2.  Display only product name and rating.
3.  Find the five cheapest products.
4.  Calculate the average stock.
5.  Count products in each category.
6.  Update the manufacturer of one product.
7.  Delete products with rating below 2.

------------------------------------------------------------------------

# Viva Questions

1.  What is a document in MongoDB?
2.  Difference between Collection and Table.
3.  Why is `_id` unique?
4.  What is an aggregation pipeline?
5.  Difference between `updateOne()` and `updateMany()`.
6.  Why are indexes used?
7.  What is projection?
8.  Explain the `$group` stage.

------------------------------------------------------------------------

# Summary

In this part you learned to:

-   Retrieve documents using `find()`
-   Filter, project, sort, and limit results
-   Update and delete documents
-   Perform aggregation analysis
-   Create indexes
-   Verify the database using MongoDB Compass

------------------------------------------------------------------------

# Next Part

**PART E -- Mini Project, Assessment, Viva, and Additional Exercises**

------------------------------------------------------------------------

# Experiment 04 -- Part 2 (Industry Grade)

# PART E -- Mini Project, Assessment and Conclusion

## Objective

Apply the concepts learned throughout the experiment to build a complete
ETL solution and evaluate the outcome.

------------------------------------------------------------------------

# Mini Project

## Problem Statement

Build an ETL pipeline that extracts data from three DummyJSON APIs:

-   Products
-   Users
-   Carts

Store each dataset in a separate MongoDB collection.

------------------------------------------------------------------------

## Collections

  API        Collection
  ---------- ------------
  Products   products
  Users      users
  Carts      carts

Database:

``` text
ProductDB
```

------------------------------------------------------------------------

# Project Requirements

1.  Extract data using REST APIs.
2.  Validate incoming records.
3.  Transform field names and data types.
4.  Perform Upsert operations into MongoDB.
5.  Export processed data to JSON and CSV.
6.  Create indexes on frequently searched fields.
7.  Display an execution summary.

------------------------------------------------------------------------

# Expected Folder Structure

``` text
Exp04_Part2/
├── data/
├── logs/
├── output/
├── config.py
├── extractor.py
├── validator.py
├── transformer.py
├── loader.py
├── exporter.py
├── products_etl.py
├── users_etl.py
├── carts_etl.py
└── requirements.txt
```

------------------------------------------------------------------------

# Suggested Enhancements

-   Add logging (`logs/etl.log`)
-   Retry failed API requests
-   Record rejected documents
-   Store execution statistics
-   Use environment variables for configuration
-   Schedule the ETL job with Cron

------------------------------------------------------------------------

# Deliverables

Students should submit:

-   Source code
-   requirements.txt
-   MongoDB database
-   JSON export
-   CSV export
-   Screenshots
-   Lab report

------------------------------------------------------------------------

# Screenshots to Capture

1.  Project directory
2.  Virtual environment
3.  Successful ETL execution
4.  MongoDB collections
5.  CRUD queries
6.  Aggregation results
7.  MongoDB Compass
8.  Exported JSON
9.  Exported CSV

------------------------------------------------------------------------

# Evaluation Rubric

  Component                         Marks
  ----------------------------- ---------
  Environment setup                    10
  ETL implementation                   25
  Validation & Transformation          15
  MongoDB Loading                      15
  CRUD & Aggregation                   15
  Exports                              10
  Viva                                 10
  **Total**                       **100**

------------------------------------------------------------------------

# Industry Best Practices

-   Keep configuration separate from code.
-   Validate all incoming data.
-   Use modular programming.
-   Implement exception handling.
-   Use logging instead of only print statements.
-   Prefer Upsert for incremental loading.
-   Create indexes for frequently used queries.
-   Export processed datasets for reporting.

------------------------------------------------------------------------

# Troubleshooting Checklist

  Problem                     Possible Solution
  --------------------------- -------------------------------
  API unavailable             Check internet and endpoint
  MongoDB connection failed   Verify mongod service
  Missing Python package      Install using pip
  Empty export files          Verify ETL execution
  Duplicate records           Confirm Upsert implementation

------------------------------------------------------------------------

# Viva Questions

1.  What is ETL?
2.  Why is JSON preferred for REST APIs?
3.  Explain BSON.
4.  Difference between MongoDB and relational databases.
5.  What is Upsert?
6.  Why is validation required?
7.  What is data transformation?
8.  Explain CRUD operations.
9.  What is the Aggregation Framework?
10. Why are indexes important?

------------------------------------------------------------------------

# Additional Exercises

1.  Filter products by brand.
2.  Find products within a price range.
3.  Calculate average stock.
4.  Identify the highest-rated product.
5.  Export only electronics products.
6.  Add a timestamp to every document.
7.  Create an index on manufacturer.
8.  Build an ETL pipeline for another public REST API.

------------------------------------------------------------------------

# Learning Outcomes Review

After completing this experiment, you should be able to:

-   Build an end-to-end ETL pipeline.
-   Consume REST APIs using Python.
-   Validate and transform JSON data.
-   Store documents in MongoDB.
-   Perform CRUD operations.
-   Execute aggregation queries.
-   Export processed datasets.
-   Develop modular Data Engineering applications.

------------------------------------------------------------------------

# Conclusion

This experiment demonstrated an industry-style ETL workflow using Python
and MongoDB. Students implemented extraction from a REST API,
validation, transformation, incremental loading, querying, aggregation,
indexing, and data export. These skills form the foundation for modern
Data Engineering applications and can be extended to cloud data
platforms, streaming systems, and enterprise data pipelines.

------------------------------------------------------------------------

# Complete Experiment Summary

You have successfully completed:

-   Part A -- Introduction and Environment Setup
-   Part B -- ETL Module Development
-   Part C -- Main ETL Pipeline
-   Part D -- MongoDB CRUD and Aggregation
-   Part E -- Mini Project and Assessment

This completes **Experiment 04 -- Part 2: Industry-Grade ETL Pipeline
using REST API, Python and MongoDB**.

------------------------------------------------------------------------

# Appendix A -- Recommended Software Versions

  Software          Version
  ----------------- -----------
  Ubuntu            24.04 LTS
  Python            3.11+
  MongoDB           8.x
  MongoDB Compass   Latest
  VS Code           Latest

------------------------------------------------------------------------

# Appendix B -- Final Project Directory

``` text
Exp04_Part2/
├── data/
│   ├── raw/
│   ├── processed/
│   └── exports/
├── logs/
├── output/
├── config.py
├── extractor.py
├── validator.py
├── transformer.py
├── loader.py
├── exporter.py
├── products_etl.py
├── requirements.txt
└── README.md
```

------------------------------------------------------------------------

# Appendix C -- Student Submission Checklist

## Source Code

-   [ ] config.py
-   [ ] extractor.py
-   [ ] validator.py
-   [ ] transformer.py
-   [ ] loader.py
-   [ ] exporter.py
-   [ ] products_etl.py

## Output Files

-   [ ] products.json
-   [ ] products.csv
-   [ ] MongoDB database populated

## Evidence

-   [ ] Terminal screenshots
-   [ ] MongoDB Compass screenshots
-   [ ] CRUD query screenshots
-   [ ] Aggregation screenshots

------------------------------------------------------------------------

# References

1.  MongoDB Documentation -- https://www.mongodb.com/docs/
2.  PyMongo Documentation -- https://pymongo.readthedocs.io/
3.  Python Documentation -- https://docs.python.org/3/
4.  DummyJSON API -- https://dummyjson.com/

------------------------------------------------------------------------

# End of Manual

This manual is intended for classroom instruction, guided laboratory
sessions, self-learning, and assessment preparation.
