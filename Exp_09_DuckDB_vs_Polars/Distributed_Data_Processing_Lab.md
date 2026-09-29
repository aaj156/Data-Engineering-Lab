# 🧪 Distributed Data Processing Lab

## Using DuckDB & Polars (Without Spark/Hadoop)

---

# 🔍 **Step 0: Pre-Installation Check (IMPORTANT)**

Before installing, check if required libraries are already available.

## ▶️ Run in Python (VS Code / Terminal / Jupyter)

```python
import importlib

libraries = ["duckdb", "polars", "pandas", "pyarrow", "matplotlib"]

for lib in libraries:
    try:
        importlib.import_module(lib)
        print(f"{lib} ✅ Already Installed")
    except ImportError:
        print(f"{lib} ❌ Not Installed")
```

---

## 📌 If NOT installed → run in TERMINAL

```bash
pip install duckdb polars pandas pyarrow matplotlib
```

👉 For Jupyter Notebook:

```python
!pip install duckdb polars pandas pyarrow matplotlib
```

---

## ⚠️ Terminal Clarification

| Step Type      | Where to Run                |
| -------------- | --------------------------- |
| pip install    | Terminal / CMD / PowerShell |
| Python scripts | VS Code / Jupyter           |
| Dataset setup  | File Explorer               |

---

# 📁 **Step 1: Dataset Setup**

```
project_folder/
 ├── data/
 │    └── ecommerce.csv
 └── lab.py
```

---

# 🐍 **Step 2: Load Dataset with Timing**

```python
import duckdb
import polars as pl
import time

con = duckdb.connect()

# DuckDB Load
start = time.time()
df_duck = con.execute("SELECT * FROM 'data/ecommerce.csv'").df()
duck_load_time = time.time() - start

# Polars Load
start = time.time()
df_polars = pl.read_csv("data/ecommerce.csv")
polars_load_time = time.time() - start

print("DuckDB Load Time:", duck_load_time)
print("Polars Load Time:", polars_load_time)
```

---

# 📊 **Step 3: Benchmark Setup**

```python
import pandas as pd
benchmark_results = []

def record(engine, operation, exec_time, rows):
    benchmark_results.append({
        "Engine": engine,
        "Operation": operation,
        "Execution Time (sec)": round(exec_time, 4),
        "Rows Output": rows
    })
```

---

# 🔍 **Step 4: Execute Queries**

---

## 🔹 Query 1: Sales by Country

```python
# DuckDB
start = time.time()
res = con.execute("""
SELECT Country, SUM(Quantity * UnitPrice) AS TotalSales
FROM 'data/ecommerce.csv'
GROUP BY Country
""").df()
record("DuckDB", "Sales by Country", time.time()-start, len(res))

# Polars
start = time.time()
res2 = df_polars.with_columns(
    (pl.col("Quantity") * pl.col("UnitPrice")).alias("Sales")
).groupby("Country").agg(pl.col("Sales").sum())
record("Polars", "Sales by Country", time.time()-start, res2.shape[0])
```

---

## 🔹 Query 2: Top 10 Products

```python
# DuckDB
start = time.time()
res = con.execute("""
SELECT Description, SUM(Quantity) AS TotalSold
FROM 'data/ecommerce.csv'
GROUP BY Description
ORDER BY TotalSold DESC
LIMIT 10
""").df()
record("DuckDB", "Top Products", time.time()-start, len(res))

# Polars
start = time.time()
res2 = df_polars.groupby("Description").agg(
    pl.col("Quantity").sum()
).sort("Quantity", descending=True).head(10)
record("Polars", "Top Products", time.time()-start, res2.shape[0])
```

---

## 🔹 Query 3: Monthly Sales Trend

```python
# DuckDB
start = time.time()
res = con.execute("""
SELECT strftime('%Y-%m', InvoiceDate) AS Month,
SUM(Quantity * UnitPrice) AS Sales
FROM 'data/ecommerce.csv'
GROUP BY Month
ORDER BY Month
""").df()
record("DuckDB", "Monthly Sales", time.time()-start, len(res))

# Polars
start = time.time()
res2 = df_polars.with_columns([
    (pl.col("Quantity") * pl.col("UnitPrice")).alias("Sales"),
    pl.col("InvoiceDate").str.slice(0,7).alias("Month")
]).groupby("Month").agg(pl.col("Sales").sum())
record("Polars", "Monthly Sales", time.time()-start, res2.shape[0])
```

---

## 🔹 Query 4: Avg Order Value

```python
# DuckDB
start = time.time()
res = con.execute("""
SELECT Country, AVG(Quantity * UnitPrice)
FROM 'data/ecommerce.csv'
GROUP BY Country
""").df()
record("DuckDB", "Avg Order Value", time.time()-start, len(res))

# Polars
start = time.time()
res2 = df_polars.with_columns(
    (pl.col("Quantity") * pl.col("UnitPrice")).alias("Sales")
).groupby("Country").agg(pl.col("Sales").mean())
record("Polars", "Avg Order Value", time.time()-start, res2.shape[0])
```

---

## 🔹 Query 5: High Revenue Transactions

```python
# DuckDB
start = time.time()
res = con.execute("""
SELECT * FROM 'data/ecommerce.csv'
WHERE Quantity * UnitPrice > 1000
""").df()
record("DuckDB", "High Revenue Filter", time.time()-start, len(res))

# Polars
start = time.time()
res2 = df_polars.filter(
    (pl.col("Quantity") * pl.col("UnitPrice")) > 1000
)
record("Polars", "High Revenue Filter", time.time()-start, res2.shape[0])
```

---

# 📊 **Step 5: Benchmark Table**

```python
benchmark_df = pd.DataFrame(benchmark_results)

pivot_table = benchmark_df.pivot(
    index="Operation",
    columns="Engine",
    values="Execution Time (sec)"
)

print(pivot_table)
```

---

# 🧠 **Step 6: Theory – DuckDB vs Polars**

## 🔷 Architecture

| Feature   | DuckDB        | Polars           |
| --------- | ------------- | ---------------- |
| Type      | SQL Engine    | DataFrame Engine |
| Execution | Query Planner | Lazy Execution   |

---

## 🔷 Parallelism

| DuckDB      | Polars              |
| ----------- | ------------------- |
| Query-level | Column-level + SIMD |

---

## 🔷 Use Cases

| Use Case         | Tool   |
| ---------------- | ------ |
| SQL Analytics    | DuckDB |
| Python Pipelines | Polars |

---

# 🚀 **Assignment Tasks**

---

## 🧩 Task 1: Format Optimization

* Convert CSV → Parquet
* Compare:

  * Execution time
  * File size

---

## 🧩 Task 2: Lazy Execution (Polars)

```python
df_lazy = pl.scan_csv("data/ecommerce.csv")

df_lazy.groupby("Country").agg(
    pl.col("Quantity").sum()
).explain()
```

Compare:

* Normal vs Lazy execution time
* Query plan

---

## 🧩 Task 3: Mini Project (Choose One)

* Customer Segmentation
* Sales Trend Analysis
* Product Performance

---

# 🏁 **Submission Requirements**

Students must submit:

* Code (.py / .ipynb)
* Output screenshots
* Benchmark table
* Short report (1–2 pages)

---

# 🏁 **Final Conclusion**

This experiment demonstrates that DuckDB and Polars can efficiently simulate distributed data processing using parallel execution on a single machine, without requiring Spark or Hadoop.

---
