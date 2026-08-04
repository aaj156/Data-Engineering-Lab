# TROUBLESHOOTING.md
# Data Engineering Laboratory
## Experiment 05 – Troubleshooting Guide

---

# Purpose

This guide helps students identify, diagnose, and resolve common issues encountered while performing the REST API experiment using FastAPI, MongoDB, and Elasticsearch.

---

# Quick Verification Checklist

| Component | Verification Command / Action | Expected |
|-----------|-------------------------------|----------|
| Python | `python --version` | Version displayed |
| pip | `pip --version` | Version displayed |
| Virtual Environment | Prompt starts with `(venv)` | Active |
| FastAPI | `pip show fastapi` | Package found |
| Uvicorn | `pip show uvicorn` | Package found |
| MongoDB | `mongod --version` | Version displayed |
| Elasticsearch | Visit `http://localhost:9200` | JSON response |
| Swagger | Visit `http://127.0.0.1:8000/docs` | Swagger UI opens |

---

# Python Issues

## Error: 'python' is not recognized

**Possible Cause**
- Python is not installed.
- Python PATH not configured.

**Solution**
1. Install Python.
2. Select **Add Python to PATH** during installation.
3. Restart the terminal.

---

## Error: pip is not recognized

**Solution**
- Reinstall Python with pip enabled.
- Verify PATH settings.

---

# Virtual Environment Issues

## Virtual environment not activated

**Windows**

```bash
venv\Scripts\activate
```

**Linux**

```bash
source venv/bin/activate
```

Expected prompt:

```
(venv)
```

---

# Package Installation Issues

## ModuleNotFoundError

Example

```
No module named 'fastapi'
```

**Solution**

```bash
pip install fastapi
```

Repeat for missing packages.

---

# VS Code Issues

## Wrong Python Interpreter

Symptoms:
- Imports underlined.
- Packages appear missing.

**Solution**

- Ctrl + Shift + P
- Python: Select Interpreter
- Choose project virtual environment.

---

# FastAPI Issues

## uvicorn not recognized

Install:

```bash
pip install uvicorn
```

Run:

```bash
uvicorn app:app --reload
```

---

## Swagger not opening

Check:

- Server is running.
- URL:

```
http://127.0.0.1:8000/docs
```

---

## Port 8000 already in use

**Solution**

Stop the previous server or use:

```bash
uvicorn app:app --reload --port 8001
```

---

# MongoDB Issues

## MongoDB Connection Refused

Check:

- MongoDB service running.
- Connection string:

```
mongodb://localhost:27017
```

---

## Database not visible

This is normal.

MongoDB creates the database after the first successful insert.

---

## Collection missing

Insert one document first.

---

# MongoDB Compass Issues

## Unable to connect

Verify:

- Service running
- Port 27017
- Correct connection string

---

# Elasticsearch Issues

## localhost:9200 unavailable

Check:

- Elasticsearch started.
- Firewall not blocking.

Start:

Windows

```bash
bin\elasticsearch.bat
```

Linux

```bash
./bin/elasticsearch
```

---

## Search returns no results

Possible causes:

- Document not indexed.
- Wrong index name.
- Query mismatch.

Verify index:

```
http://localhost:9200/students/_search?pretty
```

---

# API Issues

## 422 Validation Error

Cause:

JSON fields do not match Pydantic model.

Verify:

- Field names
- Data types

---

## 404 Not Found

Cause:

Wrong endpoint URL.

Verify:

```
/students

/search/{name}
```

---

## 500 Internal Server Error

Possible causes:

- MongoDB unavailable.
- Elasticsearch unavailable.
- Python exception.

Read the terminal log carefully.

---

# JSON Issues

## Invalid JSON

Incorrect

```json
{
"name":"Rahul",
}
```

Correct

```json
{
"name":"Rahul"
}
```

---

# Common Student Mistakes

| Mistake | Fix |
|----------|-----|
| Forgot to activate venv | Activate before installing packages |
| Forgot to save file | Save and rerun |
| Wrong localhost URL | Verify ports |
| MongoDB stopped | Start service |
| Elasticsearch stopped | Restart service |
| Incorrect JSON | Validate payload |
| Wrong imports | Verify filenames |

---

# Verification Flow

1. Python
2. Virtual Environment
3. Packages
4. MongoDB
5. Elasticsearch
6. FastAPI
7. Swagger
8. POST API
9. MongoDB Verification
10. Elasticsearch Verification
11. GET API
12. Search API

---

# Frequently Asked Questions

**Q. Why is the database not created immediately?**

MongoDB creates it after the first insert.

**Q. Why is Elasticsearch empty?**

No document has been indexed yet.

**Q. Why does Swagger not show my endpoint?**

Restart the FastAPI server after saving changes.

---

# Best Practices

- Activate the virtual environment first.
- Save files frequently.
- Test one endpoint at a time.
- Verify MongoDB after every insert.
- Verify Elasticsearch after indexing.
- Keep terminal output visible while testing.

---

# Faculty Tips

- Ask students to explain the error before fixing it.
- Encourage reading terminal logs.
- Verify each step before moving to the next.

---

# Conclusion

Troubleshooting is an essential part of Data Engineering. By following a systematic verification process, students can quickly isolate configuration, coding, and runtime issues and successfully complete the experiment.
