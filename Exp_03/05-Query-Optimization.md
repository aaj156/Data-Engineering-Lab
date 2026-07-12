# Part 05: Query Optimization

## 🎯 Objective

Learn how to improve SQL query performance using indexes, table partitioning, and execution plan analysis in PostgreSQL.

---

# 📚 Learning Outcomes

After completing this module, you will be able to:

- Understand why query optimization is important.
- Create and use indexes effectively.
- Analyze query execution plans using `EXPLAIN`.
- Measure actual query performance using `EXPLAIN ANALYZE`.
- Understand table partitioning for large datasets.
- Apply basic optimization techniques for relational databases.

---

# 🏛 Business Scenario

The University Management System has been in use for **five years**.

The **Enrollment** table now contains **millions of records** collected over multiple academic years.

Faculty members have reported that generating student reports has become slow.

As the **Database Administrator (DBA)**, your task is to analyze the queries and improve their performance.

---

# 📖 What is Query Optimization?

Query Optimization is the process of improving the performance of SQL queries so that data can be retrieved more efficiently.

Good query optimization helps to:

- Reduce query execution time.
- Minimize disk I/O.
- Improve response time.
- Support large-scale databases.
- Reduce server workload.

---

# 🎯 Business Requirement 1

## Analyze Query Execution

Before optimizing a query, understand how PostgreSQL executes it.

### 💻 SQL Command

```sql
EXPLAIN

SELECT *

FROM enrollment

WHERE student_id = 3;
```

### 🔍 Explanation

`EXPLAIN` displays the execution plan chosen by PostgreSQL without executing the query.

Typical information includes:

- Sequential Scan
- Index Scan
- Estimated Cost
- Estimated Rows

### Sample Output

```text
Seq Scan on enrollment
Filter: (student_id = 3)
Cost: 0.00..18.10
```

> **Observation:** PostgreSQL scans every row because no suitable index exists.

---

# 🎯 Business Requirement 2

## Speed Up Student Search

Searching students by **student_id** is taking too long.

Create an index on the `student_id` column.

### 💻 SQL Command

```sql
CREATE INDEX idx_enrollment_student

ON enrollment(student_id);
```

### 🔍 Explanation

| Statement | Purpose |
|-----------|---------|
| CREATE INDEX | Creates an index |
| idx_enrollment_student | Index name |
| student_id | Indexed column |

Indexes allow PostgreSQL to locate rows quickly instead of scanning the entire table.

---

### Verify the Improvement

```sql
EXPLAIN

SELECT *

FROM enrollment

WHERE student_id = 3;
```

### Sample Output

```text
Index Scan using idx_enrollment_student
```

> **Observation:** PostgreSQL now uses the index instead of performing a full table scan.

---

# 🎯 Business Requirement 3

## Frequently Search by Course and Semester

Faculty members often search enrollments using both **course_id** and **semester_id**.

A composite index can improve these queries.

### 💻 SQL Command

```sql
CREATE INDEX idx_course_semester

ON enrollment(course_id, semester_id);
```

### Example Query

```sql
SELECT *

FROM enrollment

WHERE course_id = 1

AND semester_id = 1;
```

> **Observation:** Composite indexes improve performance when multiple columns are frequently searched together.

---

# 🎯 Business Requirement 4

## Measure Actual Query Performance

The DBA wants to know how much time a query actually takes.

### 💻 SQL Command

```sql
EXPLAIN ANALYZE

SELECT *

FROM enrollment

WHERE student_id = 3;
```

### 🔍 Explanation

Unlike `EXPLAIN`, `EXPLAIN ANALYZE` executes the query and displays:

- Actual execution time
- Planning time
- Number of rows returned
- Scan method used

### Sample Output

```text
Index Scan

Planning Time: 0.25 ms

Execution Time: 0.08 ms
```

---

# 🎯 Business Requirement 5

## Store Millions of Records Efficiently

The university stores enrollment records for every academic year.

Instead of storing everything in one large table, divide the data into smaller partitions.

This technique is called **Table Partitioning**.

---

## Example Partitioned Table

```sql
CREATE TABLE enrollment_partitioned
(
    enrollment_id INT,
    student_id INT,
    course_id INT,
    semester_id INT,
    marks NUMERIC(5,2),
    grade CHAR(2)
)

PARTITION BY LIST (semester_id);
```

---

## Create Individual Partitions

```sql
CREATE TABLE enrollment_sem1

PARTITION OF enrollment_partitioned

FOR VALUES IN (1);
```

```sql
CREATE TABLE enrollment_sem2

PARTITION OF enrollment_partitioned

FOR VALUES IN (2);
```

### Why Partition Tables?

- Faster query execution.
- Easier maintenance.
- Efficient archival of old data.
- Better scalability.

---

# 🎯 Business Requirement 6

## Display Existing Indexes

The DBA wants to verify the indexes created on a table.

### 💻 SQL Command

```sql
SELECT

indexname,

indexdef

FROM pg_indexes

WHERE tablename='enrollment';
```

### Expected Output

| Index Name | Description |
|------------|-------------|
| idx_enrollment_student | Index on student_id |
| idx_course_semester | Composite Index |

---

# 📌 Best Practices for Query Optimization

✅ Create indexes only on frequently searched columns.

✅ Avoid creating unnecessary indexes.

✅ Use composite indexes when multiple columns are queried together.

✅ Analyze execution plans before optimization.

✅ Use `EXPLAIN ANALYZE` to verify improvements.

✅ Partition very large tables instead of storing all records together.

---

# 📊 Optimization Summary

| Technique | Purpose |
|-----------|---------|
| Index | Speed up searches |
| Composite Index | Optimize multi-column searches |
| EXPLAIN | View execution plan |
| EXPLAIN ANALYZE | Measure actual execution time |
| Partitioning | Improve performance on large tables |

---

# 🎯 Key Takeaways

- Query optimization improves database performance.
- Indexes reduce the need for full table scans.
- Composite indexes improve multi-column searches.
- `EXPLAIN` helps understand query execution.
- `EXPLAIN ANALYZE` measures real execution performance.
- Table partitioning is useful for very large datasets.

---

# 💻 Practice Tasks

1. Create an index on the `course_id` column.
2. Use `EXPLAIN` to analyze a query before creating an index.
3. Execute the same query after creating the index and compare the execution plan.
4. Create a composite index on `(student_id, semester_id)`.
5. List all indexes created on the `enrollment` table.
6. Explain the difference between `EXPLAIN` and `EXPLAIN ANALYZE`.
7. Describe one real-world scenario where table partitioning is beneficial.

---

# 💡 Data Engineering Insight

Large-scale data platforms such as banking systems, e-commerce applications, healthcare systems, and educational portals manage millions of records every day. Efficient indexing, execution plan analysis, and partitioning are essential techniques used by database administrators and data engineers to ensure fast query performance and scalable data processing.

---

# ➡️ Next Module

Continue with **06-OLAP-Analytics-and-Viva.md**, where you will generate management reports using OLAP-style analytical SQL queries, solve real-world reporting problems, and review important viva questions.
