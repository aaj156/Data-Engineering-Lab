# Experiment 05 – Building REST APIs for Data Capture using FastAPI, MongoDB & Elasticsearch

> **Course:** Data Engineering Laboratory  
> **Experiment No.:** 05  
> **Title:** Building REST APIs for Data Capture

---

# 1. Aim

To develop REST APIs using FastAPI, validate JSON payloads using Pydantic, store data into MongoDB, index data into Elasticsearch, and retrieve data through REST endpoints to understand how data enters modern Data Engineering pipelines.

---

# 2. Learning Outcomes

After completing this experiment, students will be able to:

- Build REST APIs using FastAPI.
- Understand HTTP GET and POST methods.
- Validate JSON payloads.
- Store data into MongoDB.
- Index documents into Elasticsearch.
- Query Elasticsearch.
- Test APIs using Swagger UI.
- Understand data ingestion pipelines.

---

# 3. Software Required

| Software | Purpose |
|-----------|----------|
| Python 3.11+ | Programming |
| VS Code | IDE |
| MongoDB Community Server | NoSQL Database |
| MongoDB Compass | GUI |
| Elasticsearch | Search Engine |
| Kibana (Optional) | Visualization |
| Postman (Optional) | API Testing |

---

# 4. Architecture

```
Client
   │
POST Request
   │
FastAPI
   │
Pydantic Validation
   │
 ┌───────────────┐
 │               │
 ▼               ▼
MongoDB     Elasticsearch
(Store)       (Index)
 │               │
 └──────┬────────┘
        ▼
 GET/Search Response
```

---

# 5. Project Structure

```
Experiment05_REST_API/

│
├── app.py
├── database.py
├── elastic.py
├── models.py
├── requirements.txt
├── README.md
└── venv/
```

---

# 6. Step-by-Step Procedure

## Step 1 – Verify Python

```bash
python --version
```

Expected:

```
Python 3.11.x
```

---

## Step 2 – Verify pip

```bash
pip --version
```

---

## Step 3 – Create Project Folder

```text
DataEngineeringLab/
    Experiment05_REST_API/
```

Open the folder in VS Code.

---

## Step 4 – Create Virtual Environment

Windows

```bash
python -m venv venv
venv\Scripts\activate
```

Linux

```bash
python3 -m venv venv
source venv/bin/activate
```

Expected:

```
(venv)
```

---

## Step 5 – Install Packages

```bash
pip install fastapi uvicorn pymongo elasticsearch pydantic
```

Create `requirements.txt`

```
fastapi
uvicorn
pymongo
elasticsearch
pydantic
```

---

# 7. MongoDB Setup

## Check Installation

```bash
mongod --version
```

If not installed:

1. Download MongoDB Community Server.
2. Install MongoDB Compass.
3. Install MongoDB as Windows Service.

Verify service is running.

Open Compass:

```
mongodb://localhost:27017
```

---

# 8. Elasticsearch Setup

## Check Installation

```bash
elasticsearch --version
```

If not installed:

1. Download Elasticsearch ZIP.
2. Extract.
3. Edit:

```
config/elasticsearch.yml
```

Ensure:

```yaml
network.host: localhost
http.port: 9200
```

Start Elasticsearch.

Windows

```bash
bin\elasticsearch.bat
```

Linux

```bash
./bin/elasticsearch
```

Verify

```
http://localhost:9200
```

---

# 9. Create Files

Create

```
app.py
database.py
elastic.py
models.py
```

---

# 10. MongoDB Connection

Create `database.py`

```python
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")

db = client["college"]

students = db["students"]
```

**Note**

MongoDB creates the database and collection automatically after the first insert.

---

# 11. Data Model

Create `models.py`

```python
from pydantic import BaseModel

class Student(BaseModel):
    roll:int
    name:str
    branch:str
    marks:float
```

---

# 12. Elasticsearch Connection

Create `elastic.py`

```python
from elasticsearch import Elasticsearch

es = Elasticsearch("http://localhost:9200")
```

---

# 13. FastAPI Application

Create `app.py`

```python
from fastapi import FastAPI
from models import Student
from database import students
from elastic import es

app = FastAPI()

@app.get("/")
def home():
    return {"message":"REST API Server Running"}

@app.post("/students")
def add_student(student: Student):
    data = student.model_dump()
    students.insert_one(data)
    es.index(index="students", document=data)
    return {"message":"Inserted Successfully"}

@app.get("/students")
def get_students():
    result=[]
    for s in students.find({}, {"_id":0}):
        result.append(s)
    return result

@app.get("/search/{name}")
def search(name:str):
    query={
        "query":{
            "match":{
                "name":name
            }
        }
    }
    res=es.search(index="students", body=query)
    return res["hits"]["hits"]
```

---

# 14. Run Server

```bash
uvicorn app:app --reload
```

Open

```
http://127.0.0.1:8000/docs
```

---

# 15. Test POST

Sample JSON

```json
{
  "roll":101,
  "name":"Rahul",
  "branch":"Computer",
  "marks":89
}
```

---

# 16. Verify MongoDB

Open MongoDB Compass

```
college
```

↓

```
students
```

Verify inserted document.

---

# 17. Verify Elasticsearch

Open

```
http://localhost:9200/students/_search?pretty
```

Verify indexed document.

---

# 18. Test GET

```
GET /students
```

---

# 19. Test Search

```
GET /search/Rahul
```

---

# 20. Common Errors

| Error | Solution |
|--------|----------|
| python not recognized | Install Python and add to PATH |
| ModuleNotFoundError | Install packages using pip |
| MongoDB connection failed | Start MongoDB Service |
| localhost:9200 unavailable | Start Elasticsearch |
| Port 8000 busy | Stop previous server |

---

# 21. Viva Questions

1. What is REST API?
2. Difference between GET and POST?
3. What is JSON?
4. What is FastAPI?
5. Why Pydantic?
6. Why MongoDB?
7. Why Elasticsearch?
8. Difference between MongoDB and PostgreSQL?
9. What is CRUD?
10. Why Swagger?

---

# 22. Assignment

Create an Employee REST API with:

- Employee ID
- Name
- Department
- Salary

Store in MongoDB and index in Elasticsearch.

---

# 23. Checklist

- [ ] Python Installed
- [ ] MongoDB Installed
- [ ] Elasticsearch Running
- [ ] FastAPI Installed
- [ ] API Running
- [ ] POST Tested
- [ ] GET Tested
- [ ] MongoDB Verified
- [ ] Elasticsearch Verified

---

# 24. Conclusion

This experiment demonstrated a complete data ingestion workflow where JSON data is accepted through REST APIs, validated using Pydantic, stored in MongoDB, indexed in Elasticsearch, and retrieved through GET endpoints. This represents a simplified version of a modern Data Engineering ingestion pipeline.
