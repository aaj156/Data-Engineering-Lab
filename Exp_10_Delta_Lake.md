# 🧪 **LAB MANUAL: Implementing Delta Lake Features in a Lakehouse Environment (Real Dataset)**

---

# 🎯 **Objective**

To implement and understand Delta Lake features including:

* Delta Table Creation
* Data Versioning (Insert, Update, Delete)
* Time Travel
* Schema Enforcement
* Real-world transformations on large dataset (10–20 MB)

---

# 📥 **Dataset**

## 🔗 Download Dataset

👉 https://www.analyticsengineering.com/datasets/ecommerce-sales

* Size: ~7–8 MB
* Type: E-commerce dataset
* Suitable for analytics and transformations

---

# 🚀 **Step-by-Step Execution in Google Colab**

---

# 🧭 **Step 1: Open Google Colab**

👉 https://colab.research.google.com

* Click **New Notebook**

---

# 📁 **Step 2: Create Project Structure**

```python
import os
os.makedirs("data", exist_ok=True)
print("Project folder created")
```

---

# 📤 **Step 3: Upload Dataset**

```python
from google.colab import files
uploaded = files.upload()
```

Move file to folder:

```python
import shutil

for file in uploaded.keys():
    shutil.move(file, "data/" + file)
```

---

# 🧠 **Step 4: Verify Dataset**

```python
import pandas as pd

df = pd.read_csv("data/your_file.csv")
df.head()
```

---

# ⚙️ **Step 5: Install Required Libraries**

```python
!pip install pyspark delta-spark matplotlib
```

---

# ⚡ **Step 6: Create Spark Session**

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("DeltaLakeLab") \
    .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
    .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
    .getOrCreate()
```

---

# 📊 **Step 7: Load Dataset in Spark**

```python
df = spark.read.csv("data/your_file.csv", header=True, inferSchema=True)

df.show(5)
df.printSchema()
```

---

# 📈 **Step 8: Initial Visualization**

```python
import matplotlib.pyplot as plt

pdf = df.limit(1000).toPandas()

pdf.groupby("Country").size().head(10).plot(kind="bar")
plt.title("Top Countries by Transactions")
plt.show()
```

---

# 🪵 **Step 9: Create Delta Table**

```python
df.write.format("delta").mode("overwrite").save("delta/ecommerce_delta")

print("Delta Table Created")
```

---

# 🔄 **Step 10: Insert Records**

```python
new_df = df.limit(5)

new_df.write.format("delta").mode("append").save("delta/ecommerce_delta")
```

### ✅ Expected:

* New version created
* Row count increases

---

# ✏️ **Step 11: Update Records**

```python
from delta.tables import DeltaTable

delta_table = DeltaTable.forPath(spark, "delta/ecommerce_delta")

delta_table.update(
    condition="Country = 'United Kingdom'",
    set={"Quantity": "Quantity + 10"}
)
```

### ✅ Expected:

* Records updated
* Version increment

---

# ❌ **Step 12: Delete Records**

```python
delta_table.delete("Quantity < 0")
```

### ✅ Expected:

* Invalid rows removed

---

# 🧭 **Step 13: Check Version History**

```python
delta_table.history().show()
```

### ✅ Expected Output:

```
version | operation
0       | WRITE
1       | APPEND
2       | UPDATE
3       | DELETE
```

---

# ⏳ **Step 14: Time Travel**

## 🔹 Old Version

```python
old_df = spark.read.format("delta") \
    .option("versionAsOf", 0) \
    .load("delta/ecommerce_delta")

old_df.show(5)
```

---

## 🔹 Latest Version

```python
latest_df = spark.read.format("delta").load("delta/ecommerce_delta")
latest_df.show(5)
```

---

# 📊 **Visualization: Version Comparison**

```python
old_count = old_df.count()
new_count = latest_df.count()

plt.bar(["Old Version", "Latest Version"], [old_count, new_count])
plt.title("Time Travel Comparison")
plt.ylabel("Row Count")
plt.show()
```

---

# 🧪 **Step 15: Schema Enforcement**

```python
bad_df = spark.createDataFrame(
    [(1, "WrongData")],
    ["id", "invalid_column"]
)

bad_df.write.format("delta").mode("append").save("delta/ecommerce_delta")
```

### ❌ Expected Error:

```
AnalysisException: Schema mismatch detected
```

---

# 📊 **Step 16: Sales Analysis**

```python
sales_df = latest_df.withColumn(
    "Sales", latest_df["Quantity"] * latest_df["UnitPrice"]
)

sales_summary = sales_df.groupBy("Country").sum("Sales").toPandas()
```

---

# 📈 **Visualization: Sales by Country**

```python
sales_summary.sort_values("sum(Sales)", ascending=False).head(10).plot(
    kind="bar", x="Country", y="sum(Sales)", legend=False
)

plt.title("Top Revenue Countries")
plt.ylabel("Sales")
plt.show()
```

---

# 🧠 **Observations**

| Feature            | Observation                |
| ------------------ | -------------------------- |
| Insert             | New version created        |
| Update             | Version updated            |
| Delete             | Logical removal            |
| Time Travel        | Historical data accessible |
| Schema Enforcement | Invalid writes blocked     |

---

# 🏁 **Conclusion**

Delta Lake enables a Lakehouse architecture by providing:

* ACID Transactions
* Version Control
* Time Travel
* Schema Enforcement

This ensures reliable, scalable, and auditable data processing.

---

# 🚀 **Advanced Extensions**

---

## 🧩 **1. MERGE (UPSERT Operation)**

```python
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
```

### ✅ Outcome:

* Updates + inserts handled automatically

---

## 🧩 **2. Schema Evolution**

```python
new_data = spark.createDataFrame([
    (6, "Smartwatch", 10000, 10)
], ["id", "product", "price", "discount"])

new_data.write.format("delta") \
    .option("mergeSchema", "true") \
    .mode("append") \
    .save("delta/ecommerce_delta")
```

### ✅ Outcome:

* New column added dynamically

---

## 🧩 **3. VACUUM (Cleanup Old Data)**

```python
spark.sql("VACUUM delta.`delta/ecommerce_delta` RETAIN 168 HOURS")
```

### ✅ Outcome:

* Old files removed
* Storage optimized

---

# 📊 **Bonus Visualization**

```python
history_df = delta_table.history().toPandas()

history_df["version"].plot(kind="line")
plt.title("Delta Table Versions")
plt.show()
```

---

# 📌 **Final Summary**

| Extension        | Concept         | Use Case             |
| ---------------- | --------------- | -------------------- |
| MERGE            | Upsert          | Incremental ETL      |
| Schema Evolution | Flexible schema | Changing data        |
| VACUUM           | Cleanup         | Storage optimization |

---

# 🎓 **Submission Requirements**

Students must submit:

* Code notebook (.ipynb)
* Screenshots of outputs
* Observations
* Final conclusion

---
