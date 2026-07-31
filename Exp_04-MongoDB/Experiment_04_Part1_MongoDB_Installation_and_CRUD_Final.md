# Experiment 04 -- Part 1

# Installation and Configuration of MongoDB to Execute NoSQL Commands

## Objective

-   Install MongoDB Community Edition on Ubuntu 24.04 (WSL)
-   Configure MongoDB
-   Start and enable the MongoDB service
-   Connect using Mongo Shell (`mongosh`)
-   Create a database and collection
-   Perform basic CRUD operations
-   Verify MongoDB installation and configuration

------------------------------------------------------------------------

# Prerequisites

-   Windows with WSL2
-   Ubuntu 24.04 LTS
-   Internet connection
-   Sudo privileges

------------------------------------------------------------------------

# Step 1 -- Verify Ubuntu Version

``` bash
lsb_release -a
```

Expected:

``` text
Distributor ID: Ubuntu
Description: Ubuntu 24.04 LTS
Release: 24.04
Codename: noble
```

------------------------------------------------------------------------

# Step 2 -- Update Ubuntu

``` bash
sudo apt update
sudo apt upgrade -y
```

------------------------------------------------------------------------

# Step 3 -- Verify Existing MongoDB Installation

``` bash
mongod --version
mongosh --version
```

If both commands return **command not found**, continue.

(Optional cleanup)

``` bash
sudo apt remove mongodb mongodb-org* -y
sudo apt autoremove -y
```

------------------------------------------------------------------------

# Step 4 -- Install Required Packages

``` bash
sudo apt install -y curl wget gnupg ca-certificates
```

Verify:

``` bash
curl --version
gpg --version
```

------------------------------------------------------------------------

# Step 5 -- Import MongoDB GPG Key

``` bash
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg
```

Verify:

``` bash
ls -l /usr/share/keyrings/mongodb-server-8.0.gpg
```

------------------------------------------------------------------------

# Step 6 -- Add MongoDB Repository

``` bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | \
sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

------------------------------------------------------------------------

# Step 7 -- Refresh Package Index

``` bash
sudo apt update
```

Ensure no repository or GPG errors are shown.

------------------------------------------------------------------------

# Step 8 -- Install MongoDB

``` bash
sudo apt install -y mongodb-org
```

------------------------------------------------------------------------

# Step 9 -- Verify Installation

``` bash
mongod --version
mongosh --version
```

Expected: - MongoDB Server 8.0.x - MongoDB Shell 2.x

------------------------------------------------------------------------

# Step 10 -- Verify Configuration

``` bash
ls -l /etc/mongod.conf
cat /etc/mongod.conf
```

Important settings:

-   dbPath: `/var/lib/mongodb`
-   Port: `27017`
-   bindIp: `127.0.0.1`

Verify directories:

``` bash
ls -ld /var/lib/mongodb
ls -ld /var/log/mongodb
```

------------------------------------------------------------------------

# Step 11 -- Start MongoDB

If your WSL supports **systemd** (recommended):

``` bash
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
```

Status should show:

``` text
Active: active (running)
```

If `systemctl` is unavailable, use:

``` bash
mongod --dbpath /data/db
```

------------------------------------------------------------------------

# Step 12 -- Connect to MongoDB

Open a new Ubuntu terminal.

``` bash
mongosh
```

Expected prompt:

``` text
test>
```

------------------------------------------------------------------------

# MongoDB CRUD Practice

## Show Databases

``` javascript
show dbs
```

## Create / Switch Database

``` javascript
use CollegeDB
```

## Create Collection

``` javascript
db.createCollection("students")
```

## Show Collections

``` javascript
show collections
```

## Insert One Document

``` javascript
db.students.insertOne({
    roll:1,
    name:"Akshay",
    department:"AIDS",
    semester:7,
    cgpa:8.95
})
```

## Verify Database

``` javascript
show dbs
```

## View Documents

``` javascript
db.students.find()
db.students.find().pretty()
```

## Insert Multiple Documents

``` javascript
db.students.insertMany([
{roll:2,name:"Rahul",department:"Computer",semester:7,cgpa:8.5},
{roll:3,name:"Sneha",department:"IT",semester:6,cgpa:9.2},
{roll:4,name:"Neha",department:"AIDS",semester:7,cgpa:9.6},
{roll:5,name:"Amit",department:"EXTC",semester:8,cgpa:7.9}
])
```

## Count Documents

``` javascript
db.students.countDocuments()
```

## Find One

``` javascript
db.students.findOne()
```

## Find by Roll

``` javascript
db.students.find({roll:3})
```

## Find by Department

``` javascript
db.students.find({department:"AIDS"})
```

## Find by Condition

``` javascript
db.students.find({cgpa:{$gt:9}})
```

## Sort

Ascending

``` javascript
db.students.find().sort({cgpa:1})
```

Descending

``` javascript
db.students.find().sort({cgpa:-1})
```

## Update

``` javascript
db.students.updateOne(
 {roll:2},
 {$set:{cgpa:9.15}}
)
```

Verify

``` javascript
db.students.find({roll:2})
```

## Delete

``` javascript
db.students.deleteOne({roll:5})
```

Verify

``` javascript
db.students.find()
```

## Drop Collection

``` javascript
db.students.drop()
```

## Drop Database

``` javascript
db.dropDatabase()
```

## Exit Mongo Shell

``` javascript
exit
```

------------------------------------------------------------------------

# MongoDB Service Commands (Ubuntu)

``` bash
sudo systemctl start mongod
sudo systemctl stop mongod
sudo systemctl restart mongod
sudo systemctl status mongod
sudo systemctl enable mongod
```

------------------------------------------------------------------------

# Expected Outcome

Students should be able to:

-   Install MongoDB successfully.
-   Configure and start the MongoDB server.
-   Connect using `mongosh`.
-   Create databases and collections.
-   Perform CRUD operations.
-   Query and sort documents.
-   Update and delete records.
-   Manage the MongoDB service.

------------------------------------------------------------------------

# Viva Questions

1.  What is NoSQL?
2.  What is MongoDB?
3.  Difference between SQL and NoSQL.
4.  What is a Document?
5.  What is a Collection?
6.  What is ObjectId?
7.  Difference between `mongod` and `mongosh`.
8.  Difference between `insertOne()` and `insertMany()`.
9.  Difference between `updateOne()` and `replaceOne()`.
10. Explain CRUD operations in MongoDB.

------------------------------------------------------------------------

# Part 2 Preview

In Part 2, a real-world Data Engineering pipeline will be implemented:

**Open REST API → Python ETL → MongoDB → CRUD → Aggregation**

using a public JSON dataset instead of manually created documents.
