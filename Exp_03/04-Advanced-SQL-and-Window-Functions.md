# Part 04: Advanced SQL and Window Functions

## 🎯 Objective

Learn how to solve analytical business problems using SQL Window Functions. Unlike aggregate functions, window functions perform calculations across a set of rows while preserving individual row details.

---

# 📚 Learning Outcomes

After completing this module, you will be able to:

- Understand the purpose of SQL Window Functions.
- Generate rankings using `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.
- Compare consecutive rows using `LAG()` and `LEAD()`.
- Calculate running totals and moving averages.
- Solve analytical business problems using SQL.

---

# 🏛 Business Scenario

The semester examinations have been completed, and the **Examination Cell** needs analytical reports for academic decision-making.

Some of the requested reports are:

- Prepare a merit list of students.
- Identify students with equal ranks.
- Compare student performance with the previous student.
- Compare student performance with the next student.
- Calculate cumulative marks.
- Analyze performance trends.

These reports cannot be generated efficiently using basic SQL alone. SQL **Window Functions** provide a powerful solution.

---

# 📖 What are Window Functions?

A **Window Function** performs calculations across a set of rows related to the current row without combining them into a single result.

Unlike `GROUP BY`, window functions preserve every row while adding analytical information.

General Syntax:

```sql
function_name() OVER (
    [PARTITION BY column]
    ORDER BY column
)
```

---

# 🎯 Business Requirement 1

## Prepare the University Merit List

The Examination Cell wants to assign a unique rank to every student based on marks.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    ROW_NUMBER() OVER (
        ORDER BY marks DESC
    ) AS merit_rank
FROM enrollment;
```

### 🔍 Explanation

| Clause | Purpose |
|---------|---------|
| `ROW_NUMBER()` | Assigns a unique number to every row |
| `OVER()` | Defines the window |
| `ORDER BY marks DESC` | Highest marks receive Rank 1 |

### Expected Output

| Student ID | Marks | Merit Rank |
|------------|------:|-----------:|
| 5 | 95 | 1 |
| 2 | 91 | 2 |
| 1 | 88 | 3 |
| 3 | 84 | 4 |
| 4 | 73 | 5 |

> **Observation:** Even if two students have the same marks, `ROW_NUMBER()` assigns different ranks.

---

# 🎯 Business Requirement 2

## Students with Equal Marks Should Receive the Same Rank

The university wants students with identical marks to share the same rank.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    RANK() OVER (
        ORDER BY marks DESC
    ) AS student_rank
FROM enrollment;
```

### Example Output

| Student | Marks | Rank |
|---------|------:|-----:|
| Rahul | 95 | 1 |
| Amit | 95 | 1 |
| Sneha | 90 | 3 |

> **Observation:** `RANK()` skips the next rank after a tie.

---

# 🎯 Business Requirement 3

## Continuous Ranking Without Gaps

The Examination Cell prefers consecutive ranks even when students have equal marks.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    DENSE_RANK() OVER (
        ORDER BY marks DESC
    ) AS dense_rank
FROM enrollment;
```

### Example Output

| Student | Marks | Dense Rank |
|---------|------:|-----------:|
| Rahul | 95 | 1 |
| Amit | 95 | 1 |
| Sneha | 90 | 2 |

### Difference Between Ranking Functions

| Function | Duplicate Ranks | Skips Rank |
|-----------|-----------------|------------|
| ROW_NUMBER() | ❌ No | ❌ No |
| RANK() | ✅ Yes | ✅ Yes |
| DENSE_RANK() | ✅ Yes | ❌ No |

---

# 🎯 Business Requirement 4

## Compare Current Marks with Previous Student

The Examination Cell wants to compare each student's marks with the previous student in the ranking.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    LAG(marks) OVER (
        ORDER BY marks DESC
    ) AS previous_marks
FROM enrollment;
```

### Expected Output

| Student | Marks | Previous Marks |
|---------|------:|---------------:|
| Rahul | 95 | NULL |
| Sneha | 91 | 95 |
| Amit | 88 | 91 |

> **Observation:** The first row has no previous record, so `NULL` is returned.

---

# 🎯 Business Requirement 5

## Compare Current Marks with Next Student

The Examination Cell wants to compare each student's marks with the next student.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    LEAD(marks) OVER (
        ORDER BY marks DESC
    ) AS next_marks
FROM enrollment;
```

### Expected Output

| Student | Marks | Next Marks |
|---------|------:|-----------:|
| Rahul | 95 | 91 |
| Sneha | 91 | 88 |
| Amit | 88 | 84 |

---

# 🎯 Business Requirement 6

## Calculate Running Total of Marks

The university wants to calculate cumulative marks while moving down the merit list.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    SUM(marks) OVER (
        ORDER BY marks DESC
    ) AS running_total
FROM enrollment;
```

---

# 🎯 Business Requirement 7

## Calculate Running Average

The Examination Cell wants to observe the average marks as students are processed in rank order.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks,
    AVG(marks) OVER (
        ORDER BY marks DESC
    ) AS running_average
FROM enrollment;
```

---

# 📌 Summary

In this module, you learned how to:

- Generate unique rankings.
- Handle tied rankings.
- Compare consecutive rows.
- Calculate cumulative values.
- Solve analytical business problems using SQL.

---

# 🎯 Key Takeaways

- Window functions preserve individual rows while adding analytical information.
- `ROW_NUMBER()` generates unique sequence numbers.
- `RANK()` and `DENSE_RANK()` handle tied values differently.
- `LAG()` and `LEAD()` compare adjacent rows.
- Running totals and averages are useful for trend analysis and reporting.

---

# 💻 Practice Tasks

1. Generate a merit list using `ROW_NUMBER()`.
2. Assign student ranks using `RANK()`.
3. Compare the output of `RANK()` and `DENSE_RANK()`.
4. Display previous marks using `LAG()`.
5. Display next marks using `LEAD()`.
6. Calculate the running total of marks.
7. Calculate the running average of marks.
8. Generate department-wise student rankings using `PARTITION BY department_id`.

---

# 💡 Data Engineering Insight

Window functions are extensively used in modern data engineering and analytics platforms for ranking, trend analysis, time-series processing, customer segmentation, financial reporting, and business intelligence dashboards. They enable powerful analytical queries without modifying the underlying data, making them an essential skill for data engineers and analysts.

---

# ➡️ Next Module

Continue with **05-Query-Optimization.md**, where you will learn how to improve SQL query performance using indexes, table partitioning, and execution plan analysis with `EXPLAIN` and `EXPLAIN ANALYZE`.
