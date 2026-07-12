# Part 06: OLAP Analytics and Viva

## 🎯 Objective

Learn how SQL is used for analytical reporting by solving real-world business problems using OLAP-style queries. This module also includes viva questions, troubleshooting tips, and a summary of the complete experiment.

---

# 📚 Learning Outcomes

After completing this module, you will be able to:

- Develop analytical SQL queries for reporting.
- Generate management reports using aggregate and window functions.
- Analyze trends and performance across departments and semesters.
- Apply SQL to support data-driven decision making.
- Review key concepts through viva questions.

---

# 🏛 Business Scenario

The University Management wants to analyze academic performance using the data collected in the University Management System.

As a **Data Engineer**, your responsibility is to prepare reports that support academic planning and decision-making.

---

# 📖 What is OLAP?

**OLAP (Online Analytical Processing)** is used to analyze large volumes of data for reporting, trend analysis, and decision-making.

Unlike **OLTP**, which focuses on day-to-day transactions, OLAP focuses on answering analytical questions.

| OLTP | OLAP |
|------|------|
| Stores operational data | Analyzes historical data |
| Frequent INSERT, UPDATE, DELETE | Mostly SELECT queries |
| Transaction processing | Reporting and analytics |
| Fast individual transactions | Complex analytical queries |

---

# 🎯 Business Requirement 1

## Department-wise Average Marks

The Dean wants to compare the academic performance of each department.

### 💻 SQL Command

```sql
SELECT
    d.department_name,
    ROUND(AVG(e.marks),2) AS average_marks
FROM department d
JOIN student s
ON d.department_id = s.department_id
JOIN enrollment e
ON s.student_id = e.student_id
GROUP BY d.department_name
ORDER BY average_marks DESC;
```

### Expected Output

| Department | Average Marks |
|------------|--------------:|
| Computer Engineering | 87.67 |
| Information Technology | 87.00 |
| Electronics Engineering | 73.00 |

---

# 🎯 Business Requirement 2

## Top Performing Student in Each Department

The Vice Chancellor wants to identify the highest-scoring student from every department.

### 💻 SQL Command

```sql
SELECT *
FROM
(
    SELECT
        d.department_name,
        s.first_name,
        s.last_name,
        e.marks,

        DENSE_RANK() OVER
        (
            PARTITION BY d.department_name
            ORDER BY e.marks DESC
        ) AS dept_rank

    FROM department d
    JOIN student s
    ON d.department_id = s.department_id

    JOIN enrollment e
    ON s.student_id = e.student_id
)
AS ranked_students

WHERE dept_rank = 1;
```

### Explanation

- `PARTITION BY` creates separate rankings for each department.
- `DENSE_RANK()` identifies the highest scorer.

---

# 🎯 Business Requirement 3

## Students Scoring Above University Average

The Examination Cell wants to identify students performing above the overall university average.

### 💻 SQL Command

```sql
SELECT
    student_id,
    marks

FROM enrollment

WHERE marks >

(
    SELECT AVG(marks)

    FROM enrollment
);
```

---

# 🎯 Business Requirement 4

## Course-wise Student Count

The Academic Office wants to know student enrollment in each course.

### 💻 SQL Command

```sql
SELECT

c.course_name,

COUNT(*) AS total_students

FROM course c

JOIN enrollment e

ON c.course_id = e.course_id

GROUP BY c.course_name

ORDER BY total_students DESC;
```

---

# 🎯 Business Requirement 5

## Semester-wise Average Performance

Management wants to compare the average performance of each semester.

### 💻 SQL Command

```sql
SELECT

semester_id,

ROUND(AVG(marks),2) AS average_marks

FROM enrollment

GROUP BY semester_id

ORDER BY semester_id;
```

---

# 🎯 Business Requirement 6

## Grade Distribution

The Examination Cell wants to know how grades are distributed.

### 💻 SQL Command

```sql
SELECT

grade,

COUNT(*) AS total_students

FROM enrollment

GROUP BY grade

ORDER BY grade;
```

---

# 🎯 Business Requirement 7

## Overall Student Merit List

Generate the university merit list.

### 💻 SQL Command

```sql
SELECT

student_id,

marks,

RANK() OVER

(

ORDER BY marks DESC

)

AS university_rank

FROM enrollment;
```

---

# 📊 Analytical SQL Summary

| Analysis | SQL Feature Used |
|-----------|------------------|
| Department Performance | GROUP BY |
| Top Student | DENSE_RANK() |
| Above Average | Subquery |
| Student Count | COUNT() |
| Semester Analysis | AVG() |
| Grade Analysis | GROUP BY |
| Merit List | RANK() |

---

# 🎯 Mini Challenge

Write SQL queries to answer the following questions.

1. Which department has the highest average marks?
2. List the top **three** students in each department.
3. Display students who scored above **90** marks.
4. Find the total number of students in every semester.
5. Count the number of students receiving each grade.
6. Display courses having more than one enrolled student.
7. Find the student with the lowest marks.
8. Display department-wise maximum marks.

---

# 🎓 Viva Questions

### Basic

1. What is a relational database?
2. What is normalization?
3. Why is 3NF important?
4. What is the difference between a Primary Key and a Foreign Key?
5. What is referential integrity?

---

### SQL

6. What is the difference between `WHERE` and `HAVING`?
7. Explain the purpose of `GROUP BY`.
8. What is a JOIN?
9. What is a subquery?
10. What are aggregate functions?

---

### Window Functions

11. What is a Window Function?
12. Differentiate between `RANK()` and `DENSE_RANK()`.
13. Explain `ROW_NUMBER()`.
14. What is the purpose of `LAG()`?
15. What is the purpose of `LEAD()`?

---

### Query Optimization

16. Why are indexes used?
17. What is table partitioning?
18. Explain `EXPLAIN`.
19. What is the difference between `EXPLAIN` and `EXPLAIN ANALYZE`?
20. What causes a Sequential Scan?

---

### Data Engineering

21. Differentiate between OLTP and OLAP.
22. Why are analytical SQL queries important?
23. Where are window functions used in industry?
24. Why is query optimization important?
25. Explain the role of PostgreSQL in Data Engineering.

---

# ⚠ Troubleshooting

| Problem | Solution |
|----------|----------|
| Relation does not exist | Verify table names using `\dt` |
| Foreign key violation | Insert parent records before child records |
| Duplicate key error | Check Primary Key or UNIQUE values |
| NULL value error | Provide values for NOT NULL columns |
| Syntax error | Check commas, brackets, and SQL keywords |
| Query returns no rows | Verify inserted data and filtering conditions |

---

# 📌 Summary

In this experiment, you learned how to:

- Design a relational database from a real-world problem.
- Normalize the database up to Third Normal Form (3NF).
- Implement the schema in PostgreSQL.
- Insert and manage relational data.
- Write SQL queries from basic to advanced.
- Use window functions for analytical reporting.
- Optimize SQL queries using indexes and execution plans.
- Generate OLAP-style reports for management.

---

# 🎯 Key Takeaways

- Good database design is the foundation of every application.
- SQL is a powerful language for both operational and analytical workloads.
- Window functions simplify complex reporting tasks.
- Query optimization improves database performance.
- OLAP queries transform raw data into meaningful business insights.

---

# 💡 Data Engineering Insight

In modern organizations, operational databases store day-to-day transactions, while analytical queries transform this data into meaningful insights. Data engineers build pipelines that move data from OLTP systems into analytical platforms, where SQL is used to create dashboards, reports, and business intelligence solutions for decision-makers.

---

# 🏁 Completed..!

You have successfully completed the **Relational Schema Design & SQL Normalization using PostgreSQL** laboratory experiment.

You are now ready to apply these concepts to larger data engineering projects involving ETL pipelines, data warehouses, Apache Spark, and cloud-based analytical platforms.
