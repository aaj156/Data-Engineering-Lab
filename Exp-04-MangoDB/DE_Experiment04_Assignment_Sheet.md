# Data Engineering Laboratory

# Assignment Sheet -- Experiment 04

## NoSQL Basics: CRUD & Indexing in MongoDB

**Course:** Data Engineering Laboratory\
**Experiment:** 04\
**Duration:** 2--3 Hours\
**Submission:** During the laboratory session

------------------------------------------------------------------------

# Instructions

-   Complete all assignments using **MongoDB Community Edition**.
-   Type MongoDB commands manually wherever applicable.
-   Use meaningful sample data.
-   Verify every operation using suitable MongoDB queries.
-   Demonstrate your solution to the instructor.
-   Submit the required files and screenshots before leaving the lab.

------------------------------------------------------------------------

# Assignment 1 -- Library Management System (CRUD)

## Problem Statement

Design a MongoDB database for a college library.

### Tasks

1.  Create a database named **library_db**.
2.  Create a collection named **books**.
3.  Insert at least **10 book documents**.
4.  Use flexible schema by adding extra fields to some books.

Suggested fields:

-   Book ID
-   Title
-   Author
-   Category
-   Publisher
-   Price
-   Availability

Optional fields:

-   Edition
-   ISBN
-   Language
-   Number of Pages
-   eBook Available

### Perform

-   Insert documents
-   Display all books
-   Display only available books
-   Update the price of one book
-   Delete one book

------------------------------------------------------------------------

# Assignment 2 -- Student Course Registration System

## Problem Statement

Create a MongoDB database to manage student registrations.

### Tasks

1.  Create **student_db**.
2.  Create **registrations** collection.
3.  Insert at least **15 student documents**.

Mandatory fields:

-   Student ID
-   Name
-   Department
-   Semester
-   Subjects (Array)
-   CGPA

Optional fields:

-   Internship
-   Certifications
-   Placement Status

### Write Queries

-   Students having CGPA greater than 8.5
-   Students registered for "Data Engineering"
-   Students having internships
-   Display only Name and CGPA
-   Count total students

------------------------------------------------------------------------

# Assignment 3 -- Online Shopping Analytics

Use the **products** collection created during the experiment.

### Tasks

Create indexes on:

-   Product ID
-   Brand
-   Category

### Execute Queries

-   Top five most expensive products
-   Products priced between ₹10,000 and ₹50,000
-   Products belonging to Electronics category

Use:

``` javascript
explain("executionStats")
```

Compare query execution before and after indexing.

Create a comparison table:

  Query   Before Index   After Index
  ------- -------------- -------------
                         

------------------------------------------------------------------------

# Assignment 4 -- Sales Dashboard using Aggregation

## Problem Statement

Create a **sales** collection.

Insert at least **20 sales documents**.

Suggested fields:

-   Product Name
-   Category
-   Quantity
-   Unit Price
-   City
-   Salesperson

### Aggregation Tasks

Find:

-   Total sales by category
-   Average sales by city
-   Maximum sale amount
-   Minimum sale amount
-   Number of sales per category

### Challenge

Display categories having average sales greater than ₹20,000.

------------------------------------------------------------------------

# Assignment 5 -- Python + MongoDB Mini Project

Develop a menu-driven **Inventory Management System** using Python and
MongoDB.

### Menu

1.  Add Product
2.  Search Product
3.  Update Product
4.  Delete Product
5.  Display All Products
6.  Exit

### Requirements

-   Use PyMongo
-   Store data in MongoDB
-   Validate Product ID
-   Handle invalid input
-   Display meaningful messages

### Bonus

Generate and insert **50 products** automatically using the **Faker**
library.

------------------------------------------------------------------------

# Submission Requirements

Submit the following:

-   MongoDB JavaScript (.js) files
-   Python (.py) files (where applicable)
-   Screenshots of important outputs
-   Observation Sheet
-   Experiment Report

------------------------------------------------------------------------

# Evaluation Rubric

  Criteria                           Marks
  ------------------------------- --------
  Database Design                        3
  CRUD Operations                        4
  Query Writing                          3
  Indexing & Aggregation                 4
  Python Integration                     4
  Documentation & Demonstration          2
  **Total**                         **20**

------------------------------------------------------------------------

# Expected Learning Outcomes

After completing this assignment, students should be able to:

-   Design document-oriented databases.
-   Apply CRUD operations using MongoDB.
-   Write efficient filter and projection queries.
-   Improve query performance using indexes.
-   Analyze data using aggregation pipelines.
-   Integrate MongoDB with Python applications.
-   Develop simple NoSQL-based data engineering solutions.

**Best of Luck!**
