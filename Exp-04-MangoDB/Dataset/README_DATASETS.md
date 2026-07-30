# Dataset Guide

These datasets are shared across multiple Data Engineering experiments.

Collections
- products.json (100 documents)
- customers.json (50 documents)
- orders.json (200 documents)
- reviews.json (300 documents)

Import Example

mongoimport --db ecommerce_db --collection products --file datasets/products.json --jsonArray

Suggested Future Use
- Experiment 04: MongoDB CRUD & Indexing
- Apache NiFi data ingestion
- Apache Spark analytics
- Kafka streaming simulation
- Airflow ETL workflows
