# Experiment 04 -- Part 2 (Guided Execution)

This lab is performed one command at a time. **Do not skip steps.**

## Step 1 -- Create Project

``` bash
mkdir -p ~/Exp04_Part2
cd ~/Exp04_Part2
pwd
```

## Step 2 -- Create Folder Structure

Run:

``` bash
bash setup_part2.sh
```

Verify:

``` bash
tree .
```

## Step 3 -- Create Python Environment

``` bash
python3 -m venv venv
source venv/bin/activate
python --version
```

## Step 4 -- Install Packages

``` bash
pip install requests pymongo pandas
pip freeze > requirements.txt
```

Verify:

``` bash
pip list
```

## Step 5 -- Verify MongoDB

``` bash
sudo systemctl status mongod
mongosh
```

Inside mongosh:

``` javascript
show dbs
exit
```

## Step 6 -- Test API

``` bash
curl https://dummyjson.com/products | head
```

## Step 7 -- Create Configuration

``` bash
nano config.py
```

Paste:

``` python
API_URL="https://dummyjson.com/products"
MONGO_URI="mongodb://localhost:27017/"
DATABASE="ProductDB"
COLLECTION="products"
```

Save and exit.

## Step 8 -- Create ETL Script

``` bash
nano products_etl.py
```

Paste the ETL script provided in the next section of the lab.

Run:

``` bash
python products_etl.py
```

## Step 9 -- Verify Database

``` bash
mongosh
```

``` javascript
show dbs
use ProductDB
show collections
db.products.countDocuments()
db.products.find().limit(3)
```

## Step 10 -- CRUD Practice

``` javascript
db.products.find({category:"beauty"})
db.products.find({price:{$gt:500}})
db.products.updateOne({id:1},{$set:{stock:999}})
db.products.find({id:1})
db.products.deleteOne({id:1})
```

## Step 11 -- Aggregation

``` javascript
db.products.aggregate([
{$group:{_id:"$category",Count:{$sum:1}}},
{$sort:{Count:-1}}
])
```

``` javascript
db.products.aggregate([
{$group:{_id:null,AveragePrice:{$avg:"$price"}}}
])
```

## Step 12 -- Verify Export Files

``` bash
ls output
cat output/summary.txt
```

## Step 13 -- MongoDB Compass

Connect to:

``` text
mongodb://localhost:27017
```

Capture screenshots: 1. ProductDB 2. products collection 3. Document
view 4. Aggregation result

## End of Part 2

Proceed to the mini project only after all steps complete successfully.
