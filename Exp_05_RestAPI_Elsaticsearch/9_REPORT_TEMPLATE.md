# REPORT_TEMPLATE.md
# Data Engineering Laboratory
## Experiment Report Template

---

# Cover Page

**Institute:** ________________________________________

**Department:** ______________________________________

**Course:** Data Engineering Laboratory

**Experiment No.:** 05

**Experiment Title:** Building REST APIs for Data Capture using FastAPI, MongoDB & Elasticsearch

**Student Name:** ___________________________________

**Roll Number:** ____________________________________

**Class / Division:** _________________________________

**Faculty Name:** ___________________________________

**Date of Performance:** _____________________________

**Date of Submission:** _____________________________

---

# Certificate

This is to certify that **Mr./Ms. __________________________** has successfully completed Experiment No. 05 titled **"Building REST APIs for Data Capture using FastAPI, MongoDB & Elasticsearch"** as part of the Data Engineering Laboratory.

Faculty Signature: _______________________

Date: _______________________

---

# Index

1. Aim
2. Objectives
3. Theory
4. Software Requirements
5. Architecture
6. Algorithm
7. Procedure
8. Program Code
9. Sample Input
10. Sample Output
11. Observations
12. Result
13. Learning Outcomes
14. Viva Questions
15. Conclusion

---

# 1. Aim

Write the aim of the experiment.

______________________________________________________________________

______________________________________________________________________

---

# 2. Objectives

Write at least four objectives.

1.
2.
3.
4.

---

# 3. Theory

## REST API

_____________________________________________________

_____________________________________________________

## FastAPI

_____________________________________________________

_____________________________________________________

## MongoDB

_____________________________________________________

_____________________________________________________

## Elasticsearch

_____________________________________________________

_____________________________________________________

## Data Engineering Pipeline

_____________________________________________________

_____________________________________________________

---

# 4. Software Requirements

| Software | Version | Verified (✓/✗) |
|-----------|---------|----------------|
| Python | | |
| VS Code | | |
| MongoDB | | |
| MongoDB Compass | | |
| Elasticsearch | | |
| FastAPI | | |

---

# 5. Architecture Diagram

Paste or draw the architecture.

```
Client
   │
POST
   │
FastAPI
   │
Validation
   │
 ┌────────────┐
 ▼            ▼
MongoDB   Elasticsearch
   │            │
   └─────┬──────┘
         ▼
      GET/Search
```

---

# 6. Algorithm

1.
2.
3.
4.
5.
6.
7.
8.
9.
10.

---

# 7. Experimental Procedure

| Step | Description | Completed |
|------|-------------|-----------|
| 1 | Verify Python | |
| 2 | Create Virtual Environment | |
| 3 | Install Packages | |
| 4 | Verify MongoDB | |
| 5 | Verify Elasticsearch | |
| 6 | Create Project | |
| 7 | Write Code | |
| 8 | Run FastAPI | |
| 9 | Test APIs | |
| 10 | Verify Databases | |

---

# 8. Source Code

## database.py

Paste your code.

---

## models.py

Paste your code.

---

## elastic.py

Paste your code.

---

## app.py

Paste your code.

---

# 9. Sample Input

```json
{
  "roll":101,
  "name":"Rahul",
  "branch":"Computer",
  "marks":89
}
```

Add additional test cases below.

| Test Case | JSON Payload | Expected Result | Actual Result |
|-----------|--------------|-----------------|---------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

---

# 10. Sample Output

## POST API Response

Paste screenshot/output.

---

## GET API Response

Paste screenshot/output.

---

## Search API Response

Paste screenshot/output.

---

## MongoDB Compass Screenshot

Paste screenshot.

---

## Elasticsearch Output

Paste screenshot.

---

## Swagger UI

Paste screenshot.

---

# 11. Observations

| Observation | Remarks |
|-------------|---------|
| API Started Successfully | |
| POST Working | |
| GET Working | |
| MongoDB Insert Successful | |
| Elasticsearch Index Created | |
| Search Successful | |

---

# 12. Result

Write the result of the experiment.

______________________________________________________

______________________________________________________

---

# 13. Learning Outcomes

Tick the achieved outcomes.

- [ ] Understood REST APIs
- [ ] Built FastAPI application
- [ ] Validated JSON payloads
- [ ] Stored data in MongoDB
- [ ] Indexed data into Elasticsearch
- [ ] Queried Elasticsearch
- [ ] Tested APIs using Swagger

---

# 14. Viva Questions

Answer the following.

1. What is REST API?

Answer:

_____________________________________________________

2. Difference between GET and POST?

Answer:

_____________________________________________________

3. Why MongoDB?

Answer:

_____________________________________________________

4. Why Elasticsearch?

Answer:

_____________________________________________________

5. What is JSON?

Answer:

_____________________________________________________

---

# 15. Conclusion

Write what you learned from this experiment.

_____________________________________________________

_____________________________________________________

_____________________________________________________

---

# Faculty Evaluation

| Criteria | Marks |
|-----------|------:|
| Preparation | /2 |
| Coding | /5 |
| API Development | /5 |
| Testing | /3 |
| Viva | /3 |
| Report | /2 |
| **Total** | **/20** |

Faculty Remarks

_____________________________________________________

_____________________________________________________

Faculty Signature: ________________________

Date: ________________________
