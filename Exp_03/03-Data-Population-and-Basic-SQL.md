# Part 03: Data Population and Basic SQL

## 🎯 Objective

Populate the normalized database with sample data and learn how to retrieve information using basic SQL queries. In this module, you will use SQL Data Manipulation Language (DML) commands and practice querying relational tables.

---

# 📚 Learning Outcomes

After completing this module, you will be able to:

- Insert records into PostgreSQL tables.
- Retrieve data using `SELECT`.
- Filter records using `WHERE`.
- Sort records using `ORDER BY`.
- Group data using `GROUP BY`.
- Filter grouped data using `HAVING`.
- Retrieve related information using `JOIN`.
- Write simple subqueries.

---

# 📖 What is DML?

**Data Manipulation Language (DML)** is used to add, modify, delete, and retrieve data stored in database tables.

Common DML commands include:

| Command | Purpose |
|----------|---------|
| `INSERT` | Add new records |
| `UPDATE` | Modify existing records |
| `DELETE` | Remove records |
| `SELECT` | Retrieve records |

---

# Step 1: Insert Sample Data

Insert the records in the order shown below to satisfy foreign key relationships.

```text
Department
    ↓
Faculty
    ↓
Student
    ↓
Semester
    ↓
Course
    ↓
Enrollment
```

---

# 🏢 Insert Departments

```sql
INSERT INTO department (department_name)
VALUES
('Computer Engineering'),
('Information Technology'),
('Electronics Engineering');
```

### Explanation

- Adds three departments.
- `department_id` is generated automatically.

### Expected Output

```text
INSERT 0 3
```

---

# 👨‍🏫 Insert Faculty

```sql
INSERT INTO faculty
(faculty_name,email,department_id)

VALUES
('Dr. Sharma','sharma@university.edu',1),
('Prof. Patel','patel@university.edu',2),
('Dr. Mehta','mehta@university.edu',3);
```

### Expected Output

```text
INSERT 0 3
```

---

# 🎓 Insert Students

```sql
INSERT INTO student
(first_name,last_name,email,phone,dob,department_id)

VALUES
('Rahul','Patil','rahul@university.edu','9876543210','2003-02-15',1),

('Sneha','Joshi','sneha@university.edu','9876543211','2002-11-20',2),

('Amit','Kulkarni','amit@university.edu','9876543212','2003-04-18',1),

('Priya','Deshmukh','priya@university.edu','9876543213','2002-09-11',3),

('Rohan','Shinde','rohan@university.edu','9876543214','2003-01-05',2);
```

---

# 📘 Insert Semester

```sql
INSERT INTO semester
(semester_name,academic_year)

VALUES

('Semester I','2025-26'),

('Semester II','2025-26');
```

---

# 📚 Insert Courses

```sql
INSERT INTO course

(course_name,
credits,
faculty_id,
department_id)

VALUES

('Database Systems',4,1,1),

('Operating Systems',4,1,1),

('Web Technologies',3,2,2),

('Digital Electronics',4,3,3);
```

---

# 📝 Insert Enrollments

```sql
INSERT INTO enrollment

(student_id,
course_id,
semester_id,
marks,
grade)

VALUES

(1,1,1,88,'A'),

(1,2,1,91,'A'),

(2,3,1,79,'B'),

(3,1,1,84,'A'),

(4,4,1,73,'B'),

(5,3,2,95,'A');
```

---

# Step 2: Verify Inserted Data

Display all departments.

```sql
SELECT * FROM department;
```

### Expected Output

| department_id | department_name |
|---------------|-----------------|
| 1 | Computer Engineering |
| 2 | Information Technology |
| 3 | Electronics Engineering |

---

Display all students.

```sql
SELECT * FROM student;
```

---

Display all courses.

```sql
SELECT * FROM course;
```

---

# Step 3: Retrieve Specific Columns

Retrieve student names.

```sql
SELECT first_name,last_name
FROM student;
```

### Explanation

Displays only the selected columns instead of the complete table.

---

# Step 4: Filter Records (WHERE)

Display students from the Computer Engineering department.

```sql
SELECT *

FROM student

WHERE department_id=1;
```

---

Display students born after 2003.

```sql
SELECT *

FROM student

WHERE dob>'2003-01-01';
```

---

# Step 5: Sort Records (ORDER BY)

Sort students alphabetically.

```sql
SELECT *

FROM student

ORDER BY first_name;
```

Sort marks in descending order.

```sql
SELECT *

FROM enrollment

ORDER BY marks DESC;
```

---

# Step 6: Aggregate Functions

Find the average marks.

```sql
SELECT AVG(marks)

FROM enrollment;
```

Find the highest marks.

```sql
SELECT MAX(marks)

FROM enrollment;
```

Find the total number of students.

```sql
SELECT COUNT(*)

FROM student;
```

---

# Step 7: GROUP BY

Display average marks for each course.

```sql
SELECT

course_id,

AVG(marks)

FROM enrollment

GROUP BY course_id;
```

---

# Step 8: HAVING

Display courses with average marks greater than 80.

```sql
SELECT

course_id,

AVG(marks)

FROM enrollment

GROUP BY course_id

HAVING AVG(marks)>80;
```

---

# Step 9: INNER JOIN

Display student names with course names.

```sql
SELECT

s.first_name,

c.course_name

FROM student s

JOIN enrollment e

ON s.student_id=e.student_id

JOIN course c

ON c.course_id=e.course_id;
```

### Explanation

- Student table stores student information.
- Enrollment connects students and courses.
- Course stores course details.

The joins combine information from all three tables.

---

# Step 10: Simple Subquery

Display students who scored above the average marks.

```sql
SELECT

student_id,

marks

FROM enrollment

WHERE marks>

(

SELECT AVG(marks)

FROM enrollment

);
```

---

# 📌 Summary

In this module, you learned how to:

- Insert records into PostgreSQL tables.
- Retrieve specific data using SQL.
- Filter records using `WHERE`.
- Sort results using `ORDER BY`.
- Perform calculations using aggregate functions.
- Group records using `GROUP BY`.
- Filter grouped records using `HAVING`.
- Combine tables using `JOIN`.
- Write simple subqueries.

---

# 🎯 Key Takeaways

- DML commands are used to manipulate database records.
- SQL queries can retrieve both simple and complex information.
- Joins combine data from multiple related tables.
- Aggregate functions summarize data efficiently.

---

# 💻 Practice Tasks

1. Insert two additional students into the `student` table.
2. Display only student email addresses.
3. Find students whose marks are greater than 85.
4. Display all courses in alphabetical order.
5. Count the number of students in each department.
6. Display faculty names along with their department names using a JOIN.
7. Find the student(s) who scored the highest marks.
8. Write a query to display students enrolled in **Database Systems**.

---

# 💡 Data Engineering Insight

Operational databases continuously receive new records through `INSERT`, `UPDATE`, and `DELETE` operations. In real-world data engineering, ETL/ELT pipelines periodically extract this transactional data, transform it into analytical datasets, and load it into data warehouses for reporting and business intelligence.

---

# ➡️ Next Module

Continue with **04-Advanced-SQL-and-Window-Functions.md**, where you will learn advanced SQL techniques including `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, `LEAD()`, and other powerful analytical functions.
