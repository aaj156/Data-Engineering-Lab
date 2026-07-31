# Experiment 04 -- Part 2 (Enhanced)

## Industry-Grade ETL Pipeline using REST API, Python and MongoDB

# Recommended Project Structure

``` text
Exp04_Part2/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── exports/
│
├── logs/
│   └── etl.log
│
├── output/
│   ├── products.json
│   ├── products.csv
│   └── summary.txt
│
├── products_etl.py
├── config.py
├── requirements.txt
└── README.md
```

------------------------------------------------------------------------

# Configuration (config.py)

``` python
API_URL="https://dummyjson.com/products"
MONGO_URI="mongodb://localhost:27017/"
DATABASE="ProductDB"
COLLECTION="products"
```

------------------------------------------------------------------------

# Logging

``` python
import logging

logging.basicConfig(
    filename="logs/etl.log",
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s"
)

logging.info("ETL Started")
```

------------------------------------------------------------------------

# Data Validation

Validate each product before inserting.

Rules:

-   id should exist.
-   title should not be empty.
-   price must be numeric.
-   rating must be numeric.
-   stock cannot be negative.

Example

``` python
def validate(product):
    required=["id","title","price","category"]

    for field in required:
        if field not in product:
            return False

    if not isinstance(product["price"],(int,float)):
        return False

    if product["price"]<0:
        return False

    return True
```

------------------------------------------------------------------------

# Transformation Pipeline

Transform API data before loading.

Example transformations

  API Field   MongoDB Field
  ----------- ------------------
  title       product_name
  brand       manufacturer
  price       product_price
  category    product_category

Add new fields

``` python
product["source"]="DummyJSON"
product["currency"]="USD"
product["ingestion_date"]=datetime.now().isoformat()
```

Flatten nested dimensions

Input

``` json
"dimensions":{
 "width":20,
 "height":10,
 "depth":5
}
```

Output

``` python
product["width"]=product["dimensions"]["width"]
product["height"]=product["dimensions"]["height"]
product["depth"]=product["dimensions"]["depth"]

product.pop("dimensions",None)
```

Convert types

``` python
product["price"]=float(product["price"])
product["rating"]=float(product["rating"])
```

------------------------------------------------------------------------

# Incremental Loading using Upsert

Avoid deleting existing data.

``` python
collection.update_one(
    {"id":product["id"]},
    {"$set":product},
    upsert=True
)
```

Advantages

-   Prevents duplicates
-   Updates changed products
-   Supports incremental ETL

------------------------------------------------------------------------

# Export Processed Data

JSON

``` python
import json

with open("output/products.json","w") as f:
    json.dump(products,f,indent=4)
```

CSV

``` python
import pandas as pd

pd.DataFrame(products).to_csv(
    "output/products.csv",
    index=False
)
```

------------------------------------------------------------------------

# Exception Handling

``` python
import requests

try:
    response=requests.get(API_URL,timeout=30)
    response.raise_for_status()
except requests.exceptions.Timeout:
    print("Timeout occurred")
except requests.exceptions.ConnectionError:
    print("Connection failed")
except requests.exceptions.HTTPError as e:
    print(e)
```

Retry logic

``` python
import time

for attempt in range(3):
    try:
        response=requests.get(API_URL,timeout=20)
        response.raise_for_status()
        break
    except Exception:
        time.sleep(3)
```

------------------------------------------------------------------------

# MongoDB Compass Verification

1.  Open MongoDB Compass.
2.  Connect using

``` text
mongodb://localhost:27017
```

3.  Verify database

``` text
ProductDB
```

4.  Open collection

``` text
products
```

5.  Check

-   Document count
-   Nested objects
-   Arrays
-   Indexes

6.  Run filters

``` json
{
"price":{"$gt":500}
}
```

``` json
{
"category":"beauty"
}
```

Sort

``` json
{
"price":-1
}
```

------------------------------------------------------------------------

# Mini Project Challenge

## APIs

Products

``` text
https://dummyjson.com/products
```

Users

``` text
https://dummyjson.com/users
```

Carts

``` text
https://dummyjson.com/carts
```

Collections

``` text
ProductDB.products
ProductDB.users
ProductDB.carts
```

Students should

-   Create three ETL scripts.
-   Validate all datasets.
-   Apply transformations.
-   Upsert into MongoDB.
-   Export JSON and CSV.
-   Create indexes.

------------------------------------------------------------------------

# Cross-Collection Analysis

Products per User

``` javascript
db.carts.aggregate([
{
$unwind:"$products"
},
{
$group:{
_id:"$userId",
TotalProducts:{
$sum:"$products.quantity"
}
}
}
])
```

Most Expensive Product

``` javascript
db.products.find().sort({price:-1}).limit(1)
```

Average Product Rating

``` javascript
db.products.aggregate([
{
$group:{
_id:null,
AverageRating:{
$avg:"$rating"
}
}
}
])
```

Products by Category

``` javascript
db.products.aggregate([
{
$group:{
_id:"$category",
Count:{
$sum:1
}
}
},
{
$sort:{Count:-1}
}
])
```

Top Five Users

``` javascript
db.users.find().limit(5)
```

------------------------------------------------------------------------

# Expected Deliverables

-   Project folder
-   ETL source code
-   Log file
-   JSON export
-   CSV export
-   MongoDB database
-   MongoDB Compass screenshots
-   Lab report
-   GitHub repository (optional)

------------------------------------------------------------------------

# Learning Outcomes

Students will understand:

-   REST API integration
-   ETL architecture
-   Data validation
-   Data transformation
-   Incremental loading
-   MongoDB CRUD
-   Aggregation framework
-   Indexing
-   Exporting datasets
-   Production-ready ETL design
