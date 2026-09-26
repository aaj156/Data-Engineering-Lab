# 📘 **Lab Experiment: Data Cube & Multidimensional Aggregations**

## 🎯 **Objective**

To perform and analyze multidimensional OLAP operations using:

* Multi-dimensional GROUP BY
* ROLLUP, CUBE, GROUPING SETS
* Execution plan comparison
* Query optimization techniques
* Real-time data ingestion from API

---

# 🖥️ **Environment Setup (WSL Ubuntu)**

## Step 1: Open WSL Terminal

```bash
wsl
```

## Step 2: Update System

```bash
sudo apt update
```

---

# 🔍 **Step 3: Check PostgreSQL Installation**

```bash
psql --version
```

### ✔ If Installed:

```
psql (PostgreSQL) 14.x
```

### ❌ If Not Installed:

```bash
sudo apt install postgresql postgresql-contrib -y
```

---

# ▶️ **Step 4: Start PostgreSQL Service**

```bash
sudo service postgresql status
```

If not running:

```bash
sudo service postgresql start
```

---

# 🔐 **Step 5: Switch to PostgreSQL User**

```bash
sudo -i -u postgres
```

---

# 🗄️ **Step 6: Open PostgreSQL CLI**

```bash
psql
```

---

# 🧱 **Step 7: Create Database**

```sql
CREATE DATABASE olap_lab;
\c olap_lab
```

---

# 📊 **Step 8: Create Table**

```sql
CREATE TABLE sales (
    region VARCHAR(50),
    product VARCHAR(50),
    year INT,
    revenue INT
);
```

---

# 📥 **Step 9: Insert Sample Data**

```sql
INSERT INTO sales VALUES
('North', 'Laptop', 2023, 50000),
('North', 'Mobile', 2023, 30000),
('South', 'Laptop', 2023, 45000),
('South', 'Mobile', 2023, 25000),
('North', 'Laptop', 2024, 60000),
('North', 'Mobile', 2024, 35000),
('South', 'Laptop', 2024, 48000),
('South', 'Mobile', 2024, 28000);
```

---

# 🔍 **Step 10: Verify Data**

```sql
SELECT * FROM sales;
```

---

# 📌 **PART A: Multi-Dimension GROUP BY**

```sql
SELECT region, product, SUM(revenue) AS total_revenue
FROM sales
GROUP BY region, product;
```

---

# 📌 **PART B: OLAP Operations**

## 1. ROLLUP

```sql
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY ROLLUP(region, product);
```

## 2. CUBE

```sql
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY CUBE(region, product);
```

## 3. GROUPING SETS

```sql
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY GROUPING SETS (
    (region, product),
    (region),
    (product),
    ()
);
```

---

# 🧠 **Step 11: Identify Aggregation Levels**

```sql
SELECT 
    region,
    product,
    SUM(revenue),
    GROUPING(region) AS g_region,
    GROUPING(product) AS g_product
FROM sales
GROUP BY CUBE(region, product);
```

---

# 📊 **PART C: Advanced OLAP Operations**

## Ranking

```sql
SELECT 
    region,
    product,
    SUM(revenue),
    RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC)
FROM sales
GROUP BY region, product;
```

## Running Total

```sql
SELECT 
    year,
    region,
    SUM(revenue),
    SUM(SUM(revenue)) OVER (PARTITION BY region ORDER BY year)
FROM sales
GROUP BY year, region;
```

## Percentage Contribution

```sql
SELECT 
    region,
    product,
    SUM(revenue),
    ROUND(100.0 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 2)
FROM sales
GROUP BY region, product;
```

---

# ⚙️ **PART D: Query Optimization**

## Step 1: Execution Plan

```sql
EXPLAIN ANALYZE
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY region, product;
```

## Step 2: Compare with CUBE

```sql
EXPLAIN ANALYZE
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY CUBE(region, product);
```

---

## Step 3: Disable Hash Aggregation

```sql
SET enable_hashagg = OFF;
```

---

## Step 4: Create Index

```sql
CREATE INDEX idx_sales_region_product ON sales(region, product);
```

---

## Step 5: Enable Parallel Execution

```sql
SET max_parallel_workers_per_gather = 4;
```

---

## Step 6: Increase Dataset Size

```sql
INSERT INTO sales
SELECT 
    region,
    product,
    year,
    revenue + (random()*10000)::int
FROM sales, generate_series(1,1000);
```

---

# 🌐 **PART E: Real-Time Data Injection**

## Step 1: Check curl

```bash
curl --version
```

If not installed:

```bash
sudo apt install curl -y
```

---

## Step 2: Fetch API Data

```bash
curl https://api.coindesk.com/v1/bpi/currentprice.json
```

---

## Step 3: Install Python

```bash
python3 --version
```

If not:

```bash
sudo apt install python3 python3-pip -y
```

---

## Step 4: Install Libraries

```bash
pip3 install requests psycopg2 pandas
```

---

## Step 5: Python ETL Script

```python
import requests
import psycopg2

url = "https://api.coindesk.com/v1/bpi/currentprice.json"
data = requests.get(url).json()

price = data['bpi']['USD']['rate_float']

conn = psycopg2.connect(
    dbname="olap_lab",
    user="postgres",
    password="your_password",
    host="localhost"
)

cur = conn.cursor()

cur.execute("""
CREATE TABLE IF NOT EXISTS bitcoin_price (
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price FLOAT
);
""")

cur.execute("INSERT INTO bitcoin_price(price) VALUES (%s);", (price,))

conn.commit()
cur.close()
conn.close()
```

---

## Step 6: Run Script

```bash
python3 script.py
```

---

## Step 7: OLAP on API Data

```sql
SELECT 
    DATE(timestamp),
    AVG(price),
    MAX(price),
    MIN(price)
FROM bitcoin_price
GROUP BY DATE(timestamp);
```

---

# 🔄 **Optional: Automate Data Collection**

```bash
crontab -e
```

Add:

```bash
*/5 * * * * python3 /home/yourpath/script.py
```

---

# 🧹 **Step 12: Exit**

```sql
\q
```

```bash
exit
```

---

# 🎯 **Final Outcome**

✔ Multi-dimensional aggregation
✔ OLAP cube operations
✔ Execution plan analysis
✔ Query optimization techniques
✔ Real-time data ingestion pipeline

---

# 🧠 **Viva Key Points**

* ROLLUP → Hierarchical aggregation
* CUBE → All combinations
* GROUPING SETS → Custom aggregation
* EXPLAIN ANALYZE → Performance insight
* Indexing improves aggregation speed

---
