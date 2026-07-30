# Data Engineering Laboratory

# Experiment 04 -- NoSQL Basics: CRUD & Indexing in MongoDB

## Experiment Overview

This experiment introduces students to MongoDB, a NoSQL document
database. Students will install and configure MongoDB, create a
database, perform CRUD operations, work with flexible schemas, create
indexes, execute aggregation queries, and connect MongoDB with Python.

> **Learning Philosophy**
>
> This is a **guided hands-on laboratory**. Most commands are **typed
> manually by students**. The provided shell scripts act as
> **interactive instructors**, explaining each step and verifying
> progress through checkpoints instead of performing all tasks
> automatically.

------------------------------------------------------------------------

# Learning Objectives

After completing this experiment, you will be able to:

-   Understand NoSQL and document-oriented databases.
-   Install and configure MongoDB Community Edition.
-   Create databases and collections.
-   Insert, read, update and delete documents.
-   Work with nested documents and arrays.
-   Create and analyze indexes.
-   Execute aggregation pipelines.
-   Connect MongoDB with Python using PyMongo.

------------------------------------------------------------------------

# Expected Outcome

Students will gain practical knowledge of MongoDB document stores and
understand how NoSQL databases are used in modern Data Engineering
applications.

------------------------------------------------------------------------

# Prerequisites

Before starting this experiment, ensure the following are available:

-   Ubuntu / WSL Linux
-   `delab` user account
-   Git
-   Curl
-   Python 3
-   pip
-   VS Code
-   Internet connection
-   Terminal access with sudo privileges

------------------------------------------------------------------------

# Folder Structure

``` text
DE_Exp_04_MongoDB/
│
├── README.md
├── START.sh
│
├── guide/
├── scripts/
├── mongodb/
├── datasets/
├── python/
├── checkpoints/
└── reports/
```

------------------------------------------------------------------------

# Experiment Workflow

``` text
README.md
    │
    ▼
START.sh
    │
    ▼
Installation
    │
    ▼
Checkpoint 1
    │
    ▼
Create Database
    │
    ▼
CRUD Operations
    │
    ▼
Checkpoint 2
    │
    ▼
Indexing
    │
    ▼
Aggregation
    │
    ▼
Python Integration
    │
    ▼
Report Submission
```

------------------------------------------------------------------------

# How to Perform This Experiment

## Step 1 -- Open Ubuntu Terminal

Navigate to the experiment folder.

``` bash
cd ~/DataEngineeringLab/experiments/DE_Exp_04_MongoDB
```

------------------------------------------------------------------------

## Step 2 -- Start the Interactive Guide

``` bash
chmod +x START.sh
./START.sh
```

The interactive guide will instruct you through every stage of the
experiment.

> **Important:** Do not skip checkpoints.

------------------------------------------------------------------------

# Learning Path

Follow the sections in the following order.

  Step   Topic
  ------ ----------------------
  1      MongoDB Installation
  2      Verify Installation
  3      Start MongoDB Server
  4      Create Database
  5      CRUD Operations
  6      Query Documents
  7      Indexing
  8      Aggregation
  9      Python Integration
  10     Report Preparation

------------------------------------------------------------------------

# Student Guidelines

-   Read every instruction carefully.
-   Type every command manually unless instructed otherwise.
-   Verify expected output before continuing.
-   Complete every checkpoint.
-   Save screenshots whenever instructed.
-   Do not modify experiment files.

------------------------------------------------------------------------

# Checkpoints

During the experiment you will verify:

-   MongoDB installation
-   MongoDB server status
-   Database creation
-   Collection creation
-   CRUD operations
-   Index creation
-   Python connectivity

------------------------------------------------------------------------

# Files Used During the Experiment

  Folder        Purpose
  ------------- --------------------------------------
  guide         Step-by-step theory and instructions
  scripts       Interactive shell guides
  mongodb       MongoDB JavaScript files
  datasets      Sample datasets
  python        Python integration examples
  checkpoints   Verification steps
  reports       Report template and screenshots

------------------------------------------------------------------------

# Submission Checklist

Before submitting, ensure you have completed the following.

-   MongoDB installed successfully
-   Database created
-   Collections created
-   CRUD operations completed
-   Indexes created
-   Aggregation queries executed
-   Python connectivity verified
-   Required screenshots captured
-   Experiment report completed

------------------------------------------------------------------------

# Troubleshooting

If you encounter an error:

1.  Read the error message carefully.
2.  Recheck the previous step.
3.  Verify the expected output.
4.  Repeat the checkpoint.
5.  Contact the instructor only after attempting the above.

------------------------------------------------------------------------

# Next Experiment

After completing this experiment, proceed to the next Data Engineering
laboratory experiment according to the course schedule.

------------------------------------------------------------------------

# Version

**Experiment:** DE Exp 04

**Topic:** NoSQL Basics -- CRUD & Indexing in MongoDB

**Document Version:** 1.0
