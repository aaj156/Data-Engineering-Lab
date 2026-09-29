```python
# =========================================================
# 🧪 DELTA LAKE AUTO EVALUATION SCRIPT (REAL DATASET)
# =========================================================

import os
import time
import pandas as pd
import matplotlib.pyplot as plt

from pyspark.sql import SparkSession
from delta.tables import DeltaTable

# =========================================================
# 🎓 STUDENT + EXPERIMENT INPUT
# =========================================================

experiment_name = input("Enter Experiment Name: ")
faculty_name = input("Enter Faculty Instructor Name: ")

student_name = input("Enter Student Name: ")
roll_no = input("Enter Roll No: ")
batch = input("Enter Batch/Class: ")
date = input("Enter Submission Date: ")

# =========================================================
# 📂 PATH CONFIG
# =========================================================

DATA_PATH = "data/your_file.csv"   # <-- update if needed
DELTA_PATH = "delta/ecommerce_delta"

# =========================================================
# ⚙️ SPARK SESSION
# =========================================================

spark = SparkSession.builder \
    .appName("DeltaAutoEval") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .getOrCreate()

# =========================================================
# 📊 LOAD DATA
# =========================================================

start = time.time()
df = spark.read.csv(DATA_PATH, header=True, inferSchema=True)
load_time = time.time() - start

row_count = df.count()
columns = df.columns

print("\nDataset Loaded Successfully")
print("Rows:", row_count)
print("Columns:", columns)

# =========================================================
# 📈 BASIC ANALYSIS
# =========================================================

country_count = df.groupBy("Country").count().toPandas()

country_count.sort_values("count", ascending=False).head(10).plot(
    kind="bar", x="Country", y="count", legend=False
)
plt.title("Top Countries")
plt.savefig(f"{roll_no}_countries.png")
plt.close()

# =========================================================
# 🪵 CREATE DELTA TABLE
# =========================================================

df.write.format("delta").mode("overwrite").save(DELTA_PATH)
delta_table = DeltaTable.forPath(spark, DELTA_PATH)

# =========================================================
# 🔄 INSERT
# =========================================================

new_df = df.limit(5)
new_df.write.format("delta").mode("append").save(DELTA_PATH)

# =========================================================
# ✏️ UPDATE
# =========================================================

delta_table.update(
    condition="Country = 'United Kingdom'",
    set={"Quantity": "Quantity + 5"}
)

# =========================================================
# ❌ DELETE
# =========================================================

delta_table.delete("Quantity < 0")

# =========================================================
# 🧭 VERSION HISTORY
# =========================================================

history_df = delta_table.history().toPandas()
version_count = len(history_df)

history_df["version"].plot()
plt.title("Delta Versions")
plt.savefig(f"{roll_no}_versions.png")
plt.close()

# =========================================================
# ⏳ TIME TRAVEL
# =========================================================

old_df = spark.read.format("delta").option("versionAsOf", 0).load(DELTA_PATH)
latest_df = spark.read.format("delta").load(DELTA_PATH)

old_count = old_df.count()
new_count = latest_df.count()

plt.bar(["Old", "Latest"], [old_count, new_count])
plt.title("Time Travel Comparison")
plt.savefig(f"{roll_no}_timetravel.png")
plt.close()

# =========================================================
# 🧪 SCHEMA ENFORCEMENT
# =========================================================

schema_test_result = "Passed"

try:
    bad_df = spark.createDataFrame([(1, "Wrong")], ["id", "invalid"])
    bad_df.write.format("delta").mode("append").save(DELTA_PATH)
    schema_test_result = "Failed (No Error)"
except Exception:
    schema_test_result = "Passed (Error Raised)"

# =========================================================
# 🚀 ADVANCED TASKS
# =========================================================

# MERGE
merge_status = "Not Done"
try:
    updates_df = spark.createDataFrame([
        (1, "Laptop", 52000),
        (5, "Camera", 30000)
    ], ["id", "product", "price"])

    delta_table.alias("target").merge(
        updates_df.alias("source"),
        "target.id = source.id"
    ).whenMatchedUpdateAll() \
     .whenNotMatchedInsertAll() \
     .execute()

    merge_status = "Done"
except:
    pass

# Schema Evolution
schema_evolution_status = "Not Done"
try:
    new_data = spark.createDataFrame([
        (6, "Smartwatch", 10000, 10)
    ], ["id", "product", "price", "discount"])

    new_data.write.format("delta") \
        .option("mergeSchema", "true") \
        .mode("append") \
        .save(DELTA_PATH)

    schema_evolution_status = "Done"
except:
    pass

# VACUUM
vacuum_status = "Not Done"
try:
    spark.sql(f"VACUUM delta.`{DELTA_PATH}` RETAIN 168 HOURS")
    vacuum_status = "Done"
except:
    pass

# =========================================================
# 📊 SALES ANALYSIS
# =========================================================

sales_df = latest_df.withColumn(
    "Sales", latest_df["Quantity"] * latest_df["UnitPrice"]
)

sales_summary = sales_df.groupBy("Country").sum("Sales").toPandas()

sales_summary.sort_values("sum(Sales)", ascending=False).head(10).plot(
    kind="bar", x="Country", y="sum(Sales)", legend=False
)
plt.title("Sales by Country")
plt.savefig(f"{roll_no}_sales.png")
plt.close()

# =========================================================
# 🧠 MARKS CALCULATION
# =========================================================

marks = 0

if row_count > 0:
    marks += 5

if version_count >= 3:
    marks += 10

if old_count != new_count:
    marks += 10

if schema_test_result.startswith("Passed"):
    marks += 10

if merge_status == "Done":
    marks += 5

if schema_evolution_status == "Done":
    marks += 5

if vacuum_status == "Done":
    marks += 5

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

# =========================================================
# 📄 REPORT GENERATION
# =========================================================

report = f"""
===============================
📊 DELTA LAKE LAB REPORT
===============================

Experiment Name: {experiment_name}
Faculty Instructor: {faculty_name}

-------------------------------
Student Name: {student_name}
Roll No: {roll_no}
Batch: {batch}
Date: {date}

-------------------------------
📂 DATASET INFO
-------------------------------
Rows: {row_count}
Columns: {columns}
Load Time: {round(load_time,2)} sec

-------------------------------
🧭 DELTA OPERATIONS
-------------------------------
Versions Created: {version_count}
Old Count: {old_count}
New Count: {new_count}

Schema Test: {schema_test_result}

-------------------------------
🚀 ADVANCED TASKS
-------------------------------
MERGE: {merge_status}
Schema Evalution: {schema_evolution_status}
VACUUM: {vacuum_status}

-------------------------------
🎯 FINAL RESULT
-------------------------------
Marks: {marks}/50
Grade: {grade}

===============================
"""

file_name = f"{roll_no}_delta_report.txt"

with open(file_name, "w") as f:
    f.write(report)

print("\n✅ Evaluation Completed")
print("📄 Report:", file_name)
print("📊 Graphs saved as PNG files")
```
