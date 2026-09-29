# ==========================================
# 🧪 FINAL LAB AUTO EVALUATION + VISUALIZATION
# ==========================================

import duckdb
import polars as pl
import pandas as pd
import time
import os
import matplotlib.pyplot as plt

# ==========================================
# 🎓 STUDENT INPUT
# ==========================================

student_name = input("Enter Student Name: ")
roll_no = input("Enter Roll No: ")
batch = input("Enter Batch/Class: ")
date = input("Enter Submission Date: ")

# ==========================================
# 📂 DATA PATH
# ==========================================

DATA_PATH = "data/ecommerce.csv"

# ==========================================
# ⚙️ SETUP
# ==========================================

con = duckdb.connect()
benchmark_results = []

def record(engine, operation, exec_time, rows):
    benchmark_results.append({
        "Engine": engine,
        "Operation": operation,
        "Time": round(exec_time, 4),
        "Rows": rows
    })

# ==========================================
# 📊 LOAD DATA
# ==========================================

start = time.time()
df_duck = con.execute(f"SELECT * FROM '{DATA_PATH}'").df()
duck_load = time.time() - start

start = time.time()
df_polars = pl.read_csv(DATA_PATH)
polars_load = time.time() - start

record("DuckDB", "Load CSV", duck_load, len(df_duck))
record("Polars", "Load CSV", polars_load, df_polars.shape[0])

# ==========================================
# 🔍 QUERY EXECUTION
# ==========================================

# Q1 Sales by Country
start = time.time()
q1_duck = con.execute("""
SELECT Country, SUM(Quantity*UnitPrice) AS Sales
FROM df_duck GROUP BY Country
""").df()
record("DuckDB", "Sales by Country", time.time()-start, len(q1_duck))

start = time.time()
q1_polars = df_polars.with_columns(
    (pl.col("Quantity")*pl.col("UnitPrice")).alias("Sales")
).groupby("Country").agg(pl.col("Sales").sum())
record("Polars", "Sales by Country", time.time()-start, q1_polars.shape[0])

# Q2 Top Products
start = time.time()
q2_duck = con.execute("""
SELECT Description, SUM(Quantity) AS TotalSold
FROM df_duck GROUP BY Description
ORDER BY TotalSold DESC LIMIT 10
""").df()
record("DuckDB", "Top Products", time.time()-start, len(q2_duck))

start = time.time()
q2_polars = df_polars.groupby("Description").agg(
    pl.col("Quantity").sum()
).sort("Quantity", descending=True).head(10)
record("Polars", "Top Products", time.time()-start, q2_polars.shape[0])

# Q3 Monthly Sales
start = time.time()
q3_duck = con.execute("""
SELECT substr(InvoiceDate,1,7) AS Month,
SUM(Quantity*UnitPrice) AS Sales
FROM df_duck GROUP BY Month ORDER BY Month
""").df()
record("DuckDB", "Monthly Sales", time.time()-start, len(q3_duck))

start = time.time()
q3_polars = df_polars.with_columns([
    (pl.col("Quantity")*pl.col("UnitPrice")).alias("Sales"),
    pl.col("InvoiceDate").str.slice(0,7).alias("Month")
]).groupby("Month").agg(pl.col("Sales").sum()).sort("Month")
record("Polars", "Monthly Sales", time.time()-start, q3_polars.shape[0])

# Q4 Avg Order Value
start = time.time()
con.execute("SELECT Country, AVG(Quantity*UnitPrice) FROM df_duck GROUP BY Country").df()
record("DuckDB", "Avg Order Value", time.time()-start, len(q1_duck))

start = time.time()
df_polars.with_columns(
    (pl.col("Quantity")*pl.col("UnitPrice")).alias("Sales")
).groupby("Country").agg(pl.col("Sales").mean())
record("Polars", "Avg Order Value", time.time()-start, q1_polars.shape[0])

# Q5 High Revenue Filter
start = time.time()
q5_duck = con.execute("""
SELECT * FROM df_duck WHERE Quantity*UnitPrice > 1000
""").df()
record("DuckDB", "High Revenue Filter", time.time()-start, len(q5_duck))

start = time.time()
q5_polars = df_polars.filter(
    (pl.col("Quantity")*pl.col("UnitPrice")) > 1000
)
record("Polars", "High Revenue Filter", time.time()-start, q5_polars.shape[0])

# ==========================================
# 🚀 TASK 1: PARQUET OPTIMIZATION
# ==========================================

con.execute("COPY df_duck TO 'data/data.parquet' (FORMAT PARQUET)")

start = time.time()
con.execute("SELECT SUM(Quantity*UnitPrice) FROM 'data/data.parquet'").fetchall()
parquet_time = time.time() - start

# ==========================================
# ⚡ TASK 2: LAZY EXECUTION
# ==========================================

start = time.time()
df_polars.groupby("Country").agg(pl.col("Quantity").sum())
normal_time = time.time() - start

start = time.time()
pl.scan_csv(DATA_PATH).groupby("Country").agg(pl.col("Quantity").sum()).collect()
lazy_time = time.time() - start

# ==========================================
# 📊 BENCHMARK TABLE
# ==========================================

df_bench = pd.DataFrame(benchmark_results)
pivot = df_bench.pivot(index="Operation", columns="Engine", values="Time")

print("\n📊 Benchmark Table:\n")
print(pivot)

# ==========================================
# 📈 VISUALIZATION 1: PERFORMANCE
# ==========================================

pivot.plot(kind="bar")
plt.title("DuckDB vs Polars Performance")
plt.ylabel("Time (seconds)")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig(f"{roll_no}_performance.png")
plt.show()

# ==========================================
# 📈 VISUALIZATION 2: MONTHLY SALES
# ==========================================

monthly_df = q3_duck

plt.figure()
plt.plot(monthly_df["Month"], monthly_df["Sales"])
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Sales")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig(f"{roll_no}_monthly_sales.png")
plt.show()

# ==========================================
# 📈 VISUALIZATION 3: TOP PRODUCTS
# ==========================================

plt.figure()
plt.barh(q2_duck["Description"], q2_duck["TotalSold"])
plt.title("Top 10 Products")
plt.xlabel("Quantity Sold")
plt.tight_layout()
plt.savefig(f"{roll_no}_top_products.png")
plt.show()

# ==========================================
# 🧠 AUTO EVALUATION
# ==========================================

marks = 0

if len(benchmark_results) >= 10:
    marks += 10

if not pivot.empty:
    marks += 10

if parquet_time < duck_load:
    marks += 10

if lazy_time <= normal_time:
    marks += 10

marks += 5  # analysis
marks += 5  # setup

# Grade
if marks >= 45:
    grade = "A+"
elif marks >= 40:
    grade = "A"
elif marks >= 35:
    grade = "B"
elif marks >= 25:
    grade = "C"
else:
    grade = "D"

# ==========================================
# 📄 REPORT GENERATION
# ==========================================

report = f"""
==============================
📊 LAB EVALUATION REPORT
==============================

Student Name: {student_name}
Roll No: {roll_no}
Batch: {batch}
Date: {date}

------------------------------
📈 PERFORMANCE TABLE
------------------------------
{pivot}

------------------------------
🚀 TASK 1 (PARQUET)
------------------------------
Parquet Time: {parquet_time:.4f}

------------------------------
⚡ TASK 2 (LAZY EXECUTION)
------------------------------
Normal Time: {normal_time:.4f}
Lazy Time: {lazy_time:.4f}

------------------------------
🎯 FINAL RESULT
------------------------------
Marks: {marks}/50
Grade: {grade}

==============================
"""

file_name = f"{roll_no}_report.txt"
with open(file_name, "w") as f:
    f.write(report)

print("\n✅ Report Generated:", file_name)
print("📊 Graphs Saved as PNG files")
