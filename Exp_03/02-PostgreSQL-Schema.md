# Part 02: PostgreSQL Schema Implementation

## 🎯 Objective

Implement the normalized database designed in Module 01 using PostgreSQL. In this module, you will create the database, define relational tables, apply constraints, and verify the schema.

---

# 📚 Learning Outcomes

After completing this module, you will be able to:

- Create a PostgreSQL database.
- Create relational tables using DDL commands.
- Define Primary Keys and Foreign Keys.
- Apply constraints to maintain data integrity.
- Verify the database schema using PostgreSQL tools.

---

# 🛠 Prerequisites

Ensure the following software is installed:

| Software | Version |
|----------|---------|
| PostgreSQL | 16+ (Recommended 17) |
| pgAdmin 4 | Latest |

Verify PostgreSQL installation:

```bash
psql --version
```

Expected Output

```text
psql (PostgreSQL) 17.x
```

---

# 📂 Step 1: Create the Database

Open **pgAdmin 4** or **psql** and execute:

```sql
CREATE DATABASE university_db;
```

Connect to the database.

```sql
\c university_db
```

---

# 📋 Step 2: Create Tables

The database consists of six normalized tables.

```
Department
Faculty
Student
Course
Semester
Enrollment
```

Create the tables in the following order to satisfy foreign key dependencies.

```
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

# 🏢 Department Table

```sql
CREATE TABLE department (
    department_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL
);
```

---

# 👨‍🏫 Faculty Table

```sql
CREATE TABLE faculty (
    faculty_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INT NOT NULL,

    CONSTRAINT fk_faculty_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);
```

---

# 🎓 Student Table

```sql
CREATE TABLE student (
    student_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    dob DATE,
    department_id INT NOT NULL,

    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);
```

---

# 📘 Semester Table

```sql
CREATE TABLE semester (
    semester_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    semester_name VARCHAR(30) NOT NULL,
    academic_year VARCHAR(10) NOT NULL
);
```

---

# 📚 Course Table

```sql
CREATE TABLE course (
    course_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 1 AND 6),

    faculty_id INT NOT NULL,
    department_id INT NOT NULL,

    CONSTRAINT fk_course_faculty
        FOREIGN KEY (faculty_id)
        REFERENCES faculty(faculty_id),

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES department(department_id)
);
```

---

# 📝 Enrollment Table

```sql
CREATE TABLE enrollment (
    enrollment_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,

    marks NUMERIC(5,2) CHECK (marks BETWEEN 0 AND 100),

    grade CHAR(2),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id),

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES course(course_id),

    CONSTRAINT fk_enrollment_semester
        FOREIGN KEY (semester_id)
        REFERENCES semester(semester_id)
);
```

---

# 🔍 Step 3: Verify Tables

List all tables.

```sql
\dt
```

Expected Output

```text
department
faculty
student
semester
course
enrollment
```

---

Describe a table.

```sql
\d student
```

View complete schema.

```sql
\d
```

---

# 📊 Database Schema Overview

```text
Department
      │
      ├────────────┐
      │            │
      ▼            ▼
 Faculty       Student
      │
      ▼
   Course
      │
      ▼
 Enrollment
      ▲
      │
 Semester
```

---

# 📌 Constraints Used

| Constraint | Purpose |
|------------|---------|
| PRIMARY KEY | Unique record identifier |
| FOREIGN KEY | Maintains table relationships |
| NOT NULL | Prevents missing values |
| UNIQUE | Avoids duplicate records |
| CHECK | Validates data values |

---

# 💡 Why Use Constraints?

Constraints improve database quality by:

- Preventing duplicate records.
- Enforcing valid relationships.
- Maintaining referential integrity.
- Reducing inconsistent data.
- Improving application reliability.

---

# 📁 Files Used

```
sql/
    create_database.sql
    create_tables.sql
```

---

# 🎯 Key Takeaways

- PostgreSQL implements relational schemas using DDL statements.
- Primary and Foreign Keys establish relationships between tables.
- Constraints ensure data consistency and integrity.
- A normalized schema provides a strong foundation for efficient querying.

---

# 💻 Practice Task

1. Create the `university_db` database.
2. Execute all table creation statements.
3. Verify that six tables are created successfully.
4. Identify the Primary Key and Foreign Key of each table.
5. Explain why the `Enrollment` table references three different tables.

---

# 💡 Data Engineering Insight

Normalized relational databases are commonly used in **Online Transaction Processing (OLTP)** systems, where maintaining accurate and consistent data is critical. In modern data engineering pipelines, these operational databases often act as the **source systems** from which ETL/ELT processes extract data into analytical data warehouses.

---

# ➡️ Next Module

Continue with **03-Data-Population-and-Basic-SQL.md**, where you will populate the database with sample records and learn to retrieve meaningful information using SQL queries.
