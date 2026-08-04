# CHECKLIST.md
# Data Engineering Laboratory
## Experiment 05 – Student & Faculty Checklist

---

# Purpose

This checklist helps students and faculty verify that every stage of the experiment has been completed successfully.

---

# Student Information

| Field | Details |
|-------|---------|
| Student Name | __________________________ |
| Roll Number | __________________________ |
| Class / Division | __________________________ |
| Batch | __________________________ |
| Date | __________________________ |

---

# Part A – Pre-Lab Checklist

## System Readiness

| Item | Status (✓/✗) | Remarks |
|------|:------------:|---------|
| Laptop/Desktop Available | | |
| Internet Connection | | |
| VS Code Installed | | |
| Python 3.11+ Installed | | |
| pip Installed | | |
| Virtual Environment Created | | |
| Virtual Environment Activated | | |

---

## Software Installation

| Software | Status | Verified By |
|----------|:------:|-------------|
| FastAPI | | |
| Uvicorn | | |
| Pydantic | | |
| PyMongo | | |
| Elasticsearch Python Library | | |
| MongoDB Community Server | | |
| MongoDB Compass | | |
| Elasticsearch Server | | |

---

# Part B – Environment Verification

| Verification | Expected | ✓/✗ |
|-------------|----------|:---:|
| `python --version` | Version displayed | |
| `pip --version` | Version displayed | |
| `(venv)` visible | Virtual environment active | |
| MongoDB Service Running | Connected | |
| Elasticsearch Running | http://localhost:9200 | |
| Swagger Opens | http://127.0.0.1:8000/docs | |

---

# Part C – Project Setup

| Task | ✓/✗ |
|------|:---:|
| Project Folder Created | |
| requirements.txt Created | |
| app.py Created | |
| database.py Created | |
| models.py Created | |
| elastic.py Created | |

---

# Part D – Coding Checklist

## MongoDB

| Task | ✓/✗ |
|------|:---:|
| Connection Established | |
| Database Created | |
| Collection Created | |

## Elasticsearch

| Task | ✓/✗ |
|------|:---:|
| Connection Established | |
| Index Created | |
| Search Working | |

## FastAPI

| Task | ✓/✗ |
|------|:---:|
| Root API Working | |
| POST API Working | |
| GET API Working | |
| Search API Working | |

---

# Part E – API Testing

| Test | Expected | ✓/✗ |
|------|----------|:---:|
| POST Request | Success Message | |
| GET Request | All Records | |
| Search API | Matching Record | |
| Invalid JSON | Validation Error | |

---

# Part F – Database Verification

## MongoDB

| Check | ✓/✗ |
|-------|:---:|
| Document Inserted | |
| Data Visible in Compass | |

## Elasticsearch

| Check | ✓/✗ |
|-------|:---:|
| Document Indexed | |
| Search Successful | |

---

# Part G – Screenshots Collected

| Screenshot | ✓/✗ |
|------------|:---:|
| Virtual Environment | |
| Swagger UI | |
| POST Response | |
| GET Response | |
| Search Response | |
| MongoDB Compass | |
| Elasticsearch Search | |

---

# Part H – Submission Checklist

| Item | ✓/✗ |
|------|:---:|
| Source Code | |
| README Followed | |
| Experiment Report | |
| Assignment Completed | |
| Viva Prepared | |
| Screenshots Attached | |

---

# Faculty Evaluation Checklist

| Criteria | Completed (✓/✗) |
|----------|:---------------:|
| Student Performed Installation | |
| Student Explained Architecture | |
| Student Demonstrated POST API | |
| Student Demonstrated GET API | |
| Student Demonstrated Search API | |
| MongoDB Verified | |
| Elasticsearch Verified | |
| Viva Conducted | |
| Report Submitted | |

---

# Common Verification URLs

| Service | URL |
|---------|-----|
| Swagger UI | http://127.0.0.1:8000/docs |
| FastAPI Root | http://127.0.0.1:8000 |
| Elasticsearch | http://localhost:9200 |
| Elasticsearch Search | http://localhost:9200/students/_search?pretty |
| MongoDB | mongodb://localhost:27017 |

---

# Final Outcome Checklist

By the end of the experiment, the student should be able to:

- [ ] Explain REST APIs
- [ ] Explain JSON Validation
- [ ] Develop APIs using FastAPI
- [ ] Store Data in MongoDB
- [ ] Index Data in Elasticsearch
- [ ] Retrieve Data using GET APIs
- [ ] Search Data using Elasticsearch
- [ ] Explain the complete Data Engineering Data Ingestion Pipeline

---

## Faculty Remarks

____________________________________________________

____________________________________________________

Faculty Signature: _______________________

Date: _______________________

---

## Student Declaration

I hereby declare that I have successfully completed this experiment and verified all the above checkpoints.

Student Signature: _______________________

Date: _______________________
