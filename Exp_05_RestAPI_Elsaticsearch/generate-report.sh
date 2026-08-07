#!/bin/bash

###############################################################################
# Experiment 05 - Report Generation Script
# Data Engineering Laboratory
# FastAPI + MongoDB + Elasticsearch
###############################################################################

echo "=========================================================="
echo "        Experiment 05 - Report Generation Utility"
echo "=========================================================="

REPORT_DIR="Submission_Report"
SRC_DIR="$REPORT_DIR/Source_Code"
VERIFY_DIR="$REPORT_DIR/Verification"
SCREEN_DIR="$REPORT_DIR/Screenshots"

echo ""
echo "Creating Report Folder Structure..."

mkdir -p "$SRC_DIR"
mkdir -p "$VERIFY_DIR"
mkdir -p "$SCREEN_DIR"

###############################################################################
# Copy Source Files
###############################################################################

echo "Copying Source Files..."

FILES=(
app.py
database.py
elastic.py
models.py
requirements.txt
README.md
)

for file in "${FILES[@]}"
do
    if [ -f "$file" ]; then
        cp "$file" "$SRC_DIR/"
    fi
done

###############################################################################
# Installed Packages
###############################################################################

echo "Saving Installed Packages..."

pip freeze > "$VERIFY_DIR/pip_packages.txt"

###############################################################################
# Python Version
###############################################################################

python3 --version > "$VERIFY_DIR/python_version.txt"

###############################################################################
# MongoDB Verification
###############################################################################

echo "Collecting MongoDB Details..."

{
echo "========== MongoDB Version =========="
mongod --version

echo ""
echo "========== MongoDB Service =========="
sudo systemctl status mongod --no-pager

echo ""
echo "========== MongoDB Databases =========="
mongosh --quiet --eval "show dbs"

echo ""
echo "========== Student Collection =========="
mongosh --quiet --eval "
use college
db.students.find().pretty()
"

} > "$VERIFY_DIR/mongodb_output.txt" 2>&1

###############################################################################
# Elasticsearch Verification
###############################################################################

echo "Collecting Elasticsearch Details..."

{
echo "========== Elasticsearch Version =========="
curl -s http://localhost:9200

echo ""
echo "========== Elasticsearch Indices =========="
curl -s http://localhost:9200/_cat/indices?v

echo ""
echo "========== Student Index =========="
curl -s http://localhost:9200/students/_search?pretty

} > "$VERIFY_DIR/elasticsearch_output.txt" 2>&1

###############################################################################
# API Information
###############################################################################

cat > "$VERIFY_DIR/api_endpoints.txt" << EOF

GET /
Returns application status.

POST /students
Adds a new student.

GET /students
Returns all students.

GET /search/{name}
Searches student by name using Elasticsearch.

Swagger URL

http://127.0.0.1:8000/docs

EOF

###############################################################################
# Report Template
###############################################################################

cat > "$REPORT_DIR/Report.md" << 'EOF'
# Experiment 05 Report

## Student Details

**Name :**

**Roll Number :**

**Class :**

**Batch :**

**Date :**

---

# Assignment Type

☐ Intermediate Assignment

☐ Challenge Assignment

---

# Assignment Title

Write your assignment title here.

---

# Problem Statement

Describe the problem statement.

---

# Objective

State the objective of your assignment.

---

# Technology Stack

- Python
- FastAPI
- Pydantic
- MongoDB
- Elasticsearch
- Swagger UI

---

# Project Structure

```
Project/
│
├── app.py
├── database.py
├── elastic.py
├── models.py
├── requirements.txt
└── README.md
```

---

# REST APIs Developed

| Method | Endpoint | Purpose |
|---------|----------|---------|
| GET | / | Home |
| POST | /students | Insert Record |
| GET | /students | View Records |
| GET | /search/{name} | Search Record |

---

# Sample JSON

```json
{
    "roll":101,
    "name":"Rahul",
    "branch":"Computer",
    "marks":89
}
```

---

# MongoDB Verification

Refer to

Verification/mongodb_output.txt

---

# Elasticsearch Verification

Refer to

Verification/elasticsearch_output.txt

---

# Swagger API Testing

Paste screenshots inside the Screenshots folder.

Suggested screenshots

- Home API
- POST API
- GET API
- Search API

---

# Output

Describe the obtained output.

---

# Challenges Faced

Mention difficulties faced while completing the assignment.

---

# Conclusion

Write the conclusion.

EOF

###############################################################################
# Screenshot Instructions
###############################################################################

cat > "$SCREEN_DIR/README.txt" << EOF

Place the following screenshots here.

1. Swagger Home API

2. POST API

3. GET API

4. Search API

5. MongoDB Compass

6. Elasticsearch Search Output

7. Terminal Output

EOF

###############################################################################
# Completion Message
###############################################################################

echo ""
echo "=========================================================="
echo " Report Generated Successfully"
echo "=========================================================="
echo ""
echo "Report Folder:"
echo ""
echo "Submission_Report/"
echo "│"
echo "├── Report.md"
echo "├── Source_Code/"
echo "├── Verification/"
echo "└── Screenshots/"
echo ""
echo "Now:"
echo "1. Copy API screenshots into Screenshots/"
echo "2. Complete Report.md"
echo "3. Compress Submission_Report/"
echo "4. Submit the ZIP file"
echo ""
echo "Done."
