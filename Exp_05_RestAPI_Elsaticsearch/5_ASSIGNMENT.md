# ASSIGNMENT.md
# Data Engineering Laboratory
## Experiment 05 – Assignment Sheet

---

# Assignment Objectives

After completing the experiment, students should be able to independently design REST APIs, validate JSON payloads, store data in MongoDB, and perform search operations using Elasticsearch.

---

# Submission Guidelines

- Submit source code.
- Submit screenshots of API execution.
- Include MongoDB and Elasticsearch verification.
- Attach a short report.
- Demonstrate the application during the viva.

---

# Level 1 – Beginner (10 Marks)

## Assignment 1 – Student Management API

Create a REST API with the following fields:

- Roll Number
- Name
- Branch
- Semester
- Marks

### Requirements

- Create POST endpoint.
- Create GET endpoint.
- Validate JSON.
- Store data in MongoDB.

### Sample JSON

```json
{
  "roll": 101,
  "name": "Rahul",
  "branch": "Computer",
  "semester": 5,
  "marks": 89
}
```

---

# Level 2 – Intermediate (15 Marks)

## Assignment 2 – Employee Management API

Fields

- Employee ID
- Name
- Department
- Designation
- Salary

### Requirements

- POST
- GET
- Search employee by name
- Store in MongoDB
- Index in Elasticsearch

---

## Assignment 3 – Product Inventory API

Fields

- Product ID
- Product Name
- Category
- Price
- Quantity

Implement:

- POST
- GET
- Search by category
- Search by product name

---

# Level 3 – Advanced (20 Marks)

## Assignment 4 – Hospital Management API

Fields

- Patient ID
- Name
- Doctor
- Disease
- Admission Date

Requirements

- POST
- GET
- Search
- Update (PUT)
- Delete

---

## Assignment 5 – Library Management API

Fields

- Book ID
- Title
- Author
- Publisher
- Status

Create complete CRUD APIs and enable Elasticsearch search by title and author.

---

# Challenge Assignment (25 Marks)

## Smart Attendance REST API

Create APIs for attendance management.

Fields

- Roll Number
- Student Name
- Subject
- Date
- Attendance Status

### Additional Features

- Search by student name
- Search by subject
- Search by date
- Attendance statistics

---

# Mini Project (30 Marks)

Develop a complete REST API system for any ONE domain:

- College Management
- Banking
- E-Commerce
- Healthcare
- Hotel Management
- Vehicle Management
- Food Delivery

Minimum Requirements

- 5 Collections
- 10+ REST APIs
- JSON Validation
- MongoDB Storage
- Elasticsearch Search
- Swagger Documentation

---

# Bonus Tasks

1. Add PUT endpoint.
2. Add DELETE endpoint.
3. Add pagination.
4. Add sorting.
5. Add filtering.
6. Add bulk insert.
7. Export data to JSON.
8. Import data from JSON.
9. Add timestamps.
10. Add logging.

---

# Industry Scenario

An online shopping platform receives thousands of product updates every minute.

Design a REST API that:

- Accepts product information.
- Validates the JSON payload.
- Stores records in MongoDB.
- Indexes documents in Elasticsearch.
- Allows fast search by product name and category.

Draw the complete architecture and explain the data flow.

---

# Evaluation Rubric

| Criteria | Marks |
|----------|------:|
| API Design | 5 |
| JSON Validation | 5 |
| MongoDB Integration | 5 |
| Elasticsearch Integration | 5 |
| Testing & Documentation | 5 |
| Code Quality | 5 |
| **Total** | **30** |

---

# Submission Checklist

- [ ] Source Code
- [ ] Screenshots
- [ ] MongoDB Verification
- [ ] Elasticsearch Verification
- [ ] Swagger Documentation
- [ ] Report
- [ ] Viva Demonstration

---

# Expected Learning Outcome

Students will be able to design scalable REST APIs, validate incoming data, integrate NoSQL databases, implement search functionality using Elasticsearch, and understand the role of REST APIs in modern Data Engineering pipelines.
