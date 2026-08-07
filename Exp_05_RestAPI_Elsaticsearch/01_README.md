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


# Step 1: Create Project Directory

Create a new project folder.

```bash
mkdir Exp5_API_MongoD
cd Exp5_API_MongoD
```

**Explanation**

- `mkdir` creates a new directory.
- `cd` moves into the project directory.

---

# Step 2: Create Python Virtual Environment

```bash
python3 -m venv venv
```

Activate the virtual environment.

```bash
source venv/bin/activate
```

**Explanation**

A virtual environment isolates project-specific Python packages from the system Python installation.

Expected prompt

```text
(venv) user@ubuntu:~/Exp5_API_MongoD$
```

---

# Step 3: Install Required Python Packages

```bash
pip install fastapi uvicorn pymongo elasticsearch pydantic
```

**Explanation**

| Package | Purpose |
|---------|---------|
| FastAPI | REST API Framework |
| Uvicorn | ASGI Web Server |
| PyMongo | MongoDB Connectivity |
| Elasticsearch | Elasticsearch Python Client |
| Pydantic | Data Validation |

---

# Step 4: Verify Installed Packages

```bash
pip list
```
```
Output displayed like this 
Package           Version
----------------- -----------
annotated-doc     0.0.5
annotated-types   0.8.0
anyio             4.14.2
certifi           2026.7.22
click             8.4.2
dnspython         2.8.0
elastic-transport 9.4.2
elasticsearch     9.5.0
fastapi           0.141.1
h11               0.16.0
idna              3.18
pip               24.0
pydantic          2.13.4
pydantic_core     2.46.4
pymongo           4.17.0
python-dateutil   2.9.0.post0
six               1.17.0
sniffio           1.3.1
starlette         1.3.1
typing_extensions 4.16.0
typing-inspection 0.4.2
urllib3           2.7.0
uvicorn           0.52.1
```


Displays all installed packages.

```bash
pip freeze
```
```
Output displayed like this 
annotated-doc==0.0.5
annotated-types==0.8.0
anyio==4.14.2
certifi==2026.7.22
click==8.4.2
dnspython==2.8.0
elastic-transport==9.4.2
elasticsearch==9.5.0
fastapi==0.141.1
h11==0.16.0
idna==3.18
pydantic==2.13.4
pydantic_core==2.46.4
pymongo==4.17.0
python-dateutil==2.9.0.post0
six==1.17.0
sniffio==1.3.1
starlette==1.3.1
typing-inspection==0.4.2
typing_extensions==4.16.0
urllib3==2.7.0
uvicorn==0.52.1
```
Displays installed packages with versions.

---

# Step 5: Create requirements.txt

```bash
pip freeze > requirements.txt
```

**Explanation**

Stores all project dependencies.

Verify

```bash
cat requirements.txt
```

---

# Step 6: Verify MongoDB Installation

Check MongoDB Server

```bash
mongod --version
```

Check MongoDB Shell

```bash
mongosh --version
```

Check MongoDB Service

```bash
sudo systemctl status mongod
```

Expected

```text
Active: active (running)
```
# Case 1 – MongoDB Service Not Running

## Step 1: Check MongoDB Service Status

Run:

```bash
sudo systemctl status mongod
```

Example Output:

```text
inactive (dead)
```

### Meaning

The MongoDB Server is installed, but the service is **not currently running**.

---

## Step 2: Start MongoDB Service

```bash
sudo systemctl start mongod
```

---

## Step 3: Enable MongoDB to Start Automatically at Boot

```bash
sudo systemctl enable mongod
```

---

## Step 4: Verify the Service

```bash
sudo systemctl status mongod
```

Expected Output:

```text
Active: active (running)
```

---

# Case 2 – Port 27017 Already in Use

MongoDB listens on **port 27017** by default.

## Step 1: Check Whether MongoDB is Listening

Run:

```bash
ss -tln | grep 27017
```

Expected Output:

```text
LISTEN ... 127.0.0.1:27017
```

### Meaning

- If you see the above output, MongoDB is already listening on port **27017**.
- If no output appears, the MongoDB service is not running.

---

## Step 2: Start MongoDB Service

```bash
sudo systemctl start mongod
```

---

## Step 3: Verify Again

```bash
ss -tln | grep 27017
```

---

# Case 3 – Connection Refused

If running:

```bash
mongosh
```

produces an error similar to:

```text
connection refused
```

### Meaning

The MongoDB Shell is installed, but it cannot connect because the MongoDB Server is **not running**.

---

## Step 1: Check MongoDB Service

```bash
sudo systemctl status mongod
```

---

## Step 2: If the Service is Stopped, Start It

```bash
sudo systemctl start mongod
```

---

## Step 3: Connect Again

```bash
mongosh
```

If the MongoDB prompt appears, the issue has been resolved.
---

# Step 7: Verify MongoDB Connection

Open MongoDB Shell

```bash
mongosh
```

Exit

```javascript
exit
```

Verify MongoDB Port

```bash
ss -tln | grep 27017
```

Expected

```text
127.0.0.1:27017
```

---

# Step 8: Install Elasticsearch

## Add Elastic Repository

```bash
sudo apt update
sudo apt install curl wget gnupg apt-transport-https -y
```

Import GPG Key

```bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
```

Add Repository

```bash
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/9.x/apt stable main" | \
sudo tee /etc/apt/sources.list.d/elastic-9.x.list
```

Update Repository

```bash
sudo apt update
```

Install Elasticsearch

```bash
sudo apt install elasticsearch -y
```

---

# Step 9: Start Elasticsearch

Reload Services

```bash
sudo systemctl daemon-reload
```

Enable Service

```bash
sudo systemctl enable elasticsearch
```

Start Service

```bash
sudo systemctl start elasticsearch
```

Check Status

```bash
sudo systemctl status elasticsearch
```

Expected

```text
Active: active (running)
```

---

# Step 10: Configure Elasticsearch

Open Configuration File

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add

```yaml
network.host: localhost
http.port: 9200

xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
xpack.security.transport.ssl.enabled: false
```

Restart Elasticsearch

```bash
sudo systemctl restart elasticsearch
```

Verify

```bash
curl http://localhost:9200
```

Expected

```json
{
  "name":"...",
  "cluster_name":"elasticsearch"
}
```

---

# Step 11: Create Project Files

```bash
touch app.py database.py elastic.py models.py
```

Verify

```bash
ls
```

Expected

```text
app.py
database.py
elastic.py
models.py
requirements.txt
```

---

# Step 12: Create MongoDB Connection

Open

```bash
nano database.py
```

Paste

```python
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")

db = client["college"]

students = db["students"]

print("Connected to MongoDB Successfully")
```

Run

```bash
python database.py
```

Expected

```text
Connected to MongoDB Successfully
```

---

# Step 13: Create Student Model

Open

```bash
nano models.py
```

Paste

```python
from pydantic import BaseModel

class Student(BaseModel):
    roll: int
    name: str
    branch: str
    marks: float
```

---

# Step 14: Create Elasticsearch Connection

Open

```bash
nano elastic.py
```

Paste

```python
from elasticsearch import Elasticsearch

es = Elasticsearch("http://localhost:9200")

if es.ping():
    print("Connected to Elasticsearch Successfully")
else:
    print("Failed to connect to Elasticsearch")
```

Run

```bash
python elastic.py
```

---

# Step 15: Create FastAPI Application

Open

```bash
nano app.py
```
```python
from fastapi import FastAPI
from models import Student
from database import students
from elastic import es.py
 1029  nano database.py
app = FastAPI()els.py
 1031  nano app.py
 1032  uvicorn app:app --reload
@app.get("/")astic.py
def home(): elastic.py
    return {"message": "REST API Server Running"}
 1036  sudo systemctl status elasticsearch
 1037  uvicorn app:app --reload
@app.post("/students")
def add_student(student: Student):students/_search?pretty
 1040  nano elastic.py
    data = student.model_dump()
 1042  uvicorn app:app --reload
    # Insert into MongoDB
    mongo_result = students.insert_one(data)
 1045  history
    print("MongoDB Inserted ID:", mongo_result.inserted_id)

    # Insert into Elasticsearch
    es_result = es.index(
        index="students",
        document=data
    )

    print("Elasticsearch Response:", es_result)

    return {
        "message": "Inserted Successfully",
        "mongo_id": str(mongo_result.inserted_id),
        "es_result": es_result["result"]
    }


@app.get("/students")
def get_students():

    result = []

    for s in students.find({}, {"_id": 0}):
        result.append(s)

    return result


@app.get("/search/{name}")
def search(name: str):

    query = {
        "query": {
            "match": {
                "name": name
            }
        }
    }

    res = es.search(index="students", body=query)

    return res["hits"]["hits"]

```


Paste the FastAPI application code provided in the experiment.

---

# Step 16: Run FastAPI Server

```bash
uvicorn app:app --reload
```

Expected

```text
INFO: Uvicorn running on http://127.0.0.1:8000
```

---

# Step 17: Open Swagger UI

Open Browser

```text
http://127.0.0.1:8000/docs
```

Test the APIs

- GET /
- POST /students
- GET /students
- GET /search/{name}

---

# Step 18: Verify MongoDB Data

Open MongoDB Shell

```bash
mongosh
```

Select Database

```javascript
use college
```

Display Data

```javascript
db.students.find().pretty()
```

---

# Step 19: Verify Elasticsearch Data

List Indices

```bash
curl http://localhost:9200/_cat/indices?v
```

Search Documents

```bash
curl http://localhost:9200/students/_search?pretty
```

---

# Common Errors

### MongoDB not installed

```text
mongod: command not found
```

Install MongoDB Community Server.

---

### Elasticsearch not installed

```text
Unable to locate package elasticsearch
```

Add the Elastic repository before installing.

---

### Elasticsearch connection failed

```text
Failed to connect to Elasticsearch
```

Ensure Elasticsearch service is running.

```bash
sudo systemctl status elasticsearch
```

---

### Python code entered in Terminal

Incorrect

```bash
from pymongo import MongoClient
```

Correct

Write Python code inside `.py` files and execute using

```bash
python filename.py
```
#################################

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
