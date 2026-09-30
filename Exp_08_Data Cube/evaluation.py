```python
# =========================================================
# 📊 OLAP LAB AUTO EVALUATION SCRIPT
# Data Cube & Multidimensional Aggregation
# =========================================================

import psycopg2
import time
import pandas as pd

# =========================================================
# 🎓 STUDENT INPUT
# =========================================================

experiment_name = "Data Cube & Multidimensional Aggregations"
faculty_name = input("Enter Faculty Name: ")

student_name = input("Enter Student Name: ")
roll_no = input("Enter Roll No: ")
batch = input("Enter Batch: ")
date = input("Enter Date: ")

# =========================================================
# 🔌 DATABASE CONNECTION
# =========================================================

conn = psycopg2.connect(
    dbname="olap_lab",
    user="postgres",
    password="your_password",
    host="localhost"
)

cur = conn.cursor()

# =========================================================
# 📊 CHECK TABLE & DATA
# =========================================================

marks = 0

try:
    cur.execute("SELECT COUNT(*) FROM sales;")
    rows = cur.fetchone()[0]
    if rows > 0:
        marks += 5
        data_status = f"Loaded ({rows} rows)"
    else:
        data_status = "Empty"
except:
    data_status = "Table Missing"

# =========================================================
# 🧠 QUERY EXECUTION + TIMING
# =========================================================

results = []

def run_query(name, query):
    try:
        start = time.time()
        cur.execute(query)
        cur.fetchall()
        t = round(time.time() - start, 4)
        results.append([name, t])
        return t
    except:
        results.append([name, "Failed"])
        return None

# GROUP BY
t1 = run_query("GROUP BY", """
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY region, product;
""")

# ROLLUP
t2 = run_query("ROLLUP", """
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY ROLLUP(region, product);
""")

# CUBE
t3 = run_query("CUBE", """
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY CUBE(region, product);
""")

# GROUPING SETS
t4 = run_query("GROUPING SETS", """
SELECT region, product, SUM(revenue)
FROM sales
GROUP BY GROUPING SETS (
(region, product),
(region),
(product),
()
);
""")

# Ranking
t5 = run_query("RANKING", """
SELECT region, product, SUM(revenue),
RANK() OVER (PARTITION BY region ORDER BY SUM(revenue) DESC)
FROM sales
GROUP BY region, product;
""")

# Running Total
t6 = run_query("RUNNING TOTAL", """
SELECT year, region,
SUM(revenue),
SUM(SUM(revenue)) OVER (PARTITION BY region ORDER BY year)
FROM sales
GROUP BY year, region;
""")

# =========================================================
# 📊 BENCHMARK TABLE
# =========================================================

benchmark_df = pd.DataFrame(results, columns=["Query", "Execution Time (sec)"])

# =========================================================
# ⚙️ OPTIMIZATION CHECK
# =========================================================

optimization = "Not Applied"

try:
    cur.execute("CREATE INDEX IF NOT EXISTS idx_test ON sales(region, product);")
    optimization = "Index Created"
    marks += 5
except:
    pass

# =========================================================
# 🌐 API DATA CHECK
# =========================================================

api_status = "Not Found"

try:
    cur.execute("SELECT COUNT(*) FROM bitcoin_price;")
    api_rows = cur.fetchone()[0]

    if api_rows > 0:
        api_status = f"Data Present ({api_rows} rows)"
        marks += 10
except:
    pass

# =========================================================
# 📊 OLAP VALIDATION
# =========================================================

if t1 and t2 and t3:
    marks += 15

if t5 and t6:
    marks += 10

# =========================================================
# 🎯 FINAL MARKS & GRADE
# =========================================================

if marks >= 40:
    grade = "A+"
elif marks >= 35:
    grade = "A"
elif marks >= 25:
    grade = "B"
elif marks >= 15:
    grade = "C"
else:
    grade = "D"

# =========================================================
# 📄 REPORT GENERATION
# =========================================================

report = f"""
===============================
📊 OLAP LAB EVALUATION REPORT
===============================

Experiment: {experiment_name}
Faculty: {faculty_name}

-------------------------------
Student Name: {student_name}
Roll No: {roll_no}
Batch: {batch}
Date: {date}

-------------------------------
📂 DATA STATUS
-------------------------------
{data_status}

-------------------------------
⚡ QUERY PERFORMANCE
-------------------------------
{benchmark_df.to_string(index=False)}

-------------------------------
⚙️ OPTIMIZATION
-------------------------------
{optimization}

-------------------------------
🌐 API DATA
-------------------------------
{api_status}

-------------------------------
🎯 FINAL RESULT
-------------------------------
Marks: {marks}/50
Grade: {grade}

===============================
"""

file_name = f"{roll_no}_olap_report.txt"

with open(file_name, "w") as f:
    f.write(report)

print("\n✅ Evaluation Completed")
print("📄 Report saved as:", file_name)

cur.close()
conn.close()
```
