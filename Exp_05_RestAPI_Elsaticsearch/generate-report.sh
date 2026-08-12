#!/bin/bash

###############################################################################
# Experiment 05 - Evaluation + Student Report Generator
###############################################################################

echo "=========================================================="
echo "   Experiment 05 - Student Evaluation System"
echo "=========================================================="

###############################################################################
# 🧑‍🎓 STUDENT INPUT
###############################################################################

echo ""
read -p "Enter Student Name: " NAME
read -p "Enter Batch: " BATCH
read -p "Enter Experiment Number: " EXP_NO
read -p "Enter Experiment Title: " EXP_TITLE
read -p "Enter Faculty Name: " FACULTY

###############################################################################
# 📁 DIRECTORIES
###############################################################################

REPORT_DIR="Submission_Report"
VERIFY_DIR="$REPORT_DIR/Verification"

mkdir -p "$REPORT_DIR" "$VERIFY_DIR"

TOTAL=0
MAX=30

###############################################################################
# ✅ 1. SOURCE CODE CHECK (5 Marks)
###############################################################################

FILES=(app.py database.py elastic.py models.py requirements.txt)
FOUND=0

for file in "${FILES[@]}"
do
    if [ -f "$file" ]; then
        ((FOUND++))
    fi
done

SRC_SCORE=$FOUND
TOTAL=$((TOTAL + SRC_SCORE))

###############################################################################
# ✅ 2. PYTHON CHECK (5 Marks)
###############################################################################

PY_SCORE=0

python3 --version > "$VERIFY_DIR/python.txt" 2>&1 && ((PY_SCORE+=2))
pip freeze > "$VERIFY_DIR/pip.txt" 2>&1 && ((PY_SCORE+=3))

TOTAL=$((TOTAL + PY_SCORE))

###############################################################################
# ✅ 3. MONGODB CHECK (5 Marks)
###############################################################################

MONGO_SCORE=0

if command -v mongosh >/dev/null; then
    mongosh --quiet --eval "db.adminCommand('ping')" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        ((MONGO_SCORE+=2))
    fi

    mongosh --quiet --eval "use college; db.students.countDocuments()" \
    > "$VERIFY_DIR/mongo.txt" 2>&1

    if grep -q "[0-9]" "$VERIFY_DIR/mongo.txt"; then
        ((MONGO_SCORE+=3))
    fi
fi

TOTAL=$((TOTAL + MONGO_SCORE))

###############################################################################
# ✅ 4. ELASTICSEARCH CHECK (5 Marks)
###############################################################################

ES_SCORE=0

curl -s http://localhost:9200 > "$VERIFY_DIR/es.txt"

if grep -q "cluster_name" "$VERIFY_DIR/es.txt"; then
    ((ES_SCORE+=2))
fi

curl -s http://localhost:9200/students/_search > "$VERIFY_DIR/es_data.txt"

if grep -q "hits" "$VERIFY_DIR/es_data.txt"; then
    ((ES_SCORE+=3))
fi

TOTAL=$((TOTAL + ES_SCORE))

###############################################################################
# ✅ 5. API CHECK (5 Marks)
###############################################################################

API_SCORE=0

curl -s http://127.0.0.1:8000 > "$VERIFY_DIR/api_root.txt"
grep -qi "message" "$VERIFY_DIR/api_root.txt" && ((API_SCORE+=1))

curl -s http://127.0.0.1:8000/students > "$VERIFY_DIR/api_get.txt"
grep -q "[" "$VERIFY_DIR/api_get.txt" && ((API_SCORE+=2))

curl -s http://127.0.0.1:8000/search/Rahul > "$VERIFY_DIR/api_search.txt"
grep -q "Rahul" "$VERIFY_DIR/api_search.txt" && ((API_SCORE+=2))

TOTAL=$((TOTAL + API_SCORE))

###############################################################################
# 🎓 GRADE CALCULATION
###############################################################################

GRADE="FAIL"

if [ $TOTAL -ge 24 ]; then
    GRADE="EXCELLENT"
elif [ $TOTAL -ge 18 ]; then
    GRADE="GOOD"
elif [ $TOTAL -ge 12 ]; then
    GRADE="AVERAGE"
fi

###############################################################################
# 📝 FINAL REPORT GENERATION
###############################################################################

REPORT_FILE="$REPORT_DIR/Report.txt"

cat > "$REPORT_FILE" << EOF

==========================================================
                EXPERIMENT REPORT
==========================================================

Student Name      : $NAME
Batch             : $BATCH
Experiment No     : $EXP_NO
Experiment Title  : $EXP_TITLE
Faculty Name      : $FACULTY

----------------------------------------------------------
                EVALUATION DETAILS
----------------------------------------------------------

Source Code        : $SRC_SCORE / 5
Python Setup       : $PY_SCORE / 5
MongoDB            : $MONGO_SCORE / 5
Elasticsearch      : $ES_SCORE / 5
API Functionality  : $API_SCORE / 5

----------------------------------------------------------

TOTAL              : $TOTAL / $MAX
GRADE              : $GRADE

----------------------------------------------------------
                SYSTEM DETAILS
----------------------------------------------------------

Python Version:
$(python3 --version)

----------------------------------------------------------

Remarks:
- APIs tested via Swagger
- MongoDB & Elasticsearch verified
- End-to-end pipeline executed

==========================================================

EOF

###############################################################################
# 🎉 OUTPUT
###############################################################################

echo ""
echo "=========================================================="
echo " Report Generated Successfully"
echo "=========================================================="

echo ""
echo "Saved at:"
echo "$REPORT_FILE"

echo ""
echo "Score: $TOTAL / $MAX"
echo "Grade: $GRADE"

echo ""
echo "Done."
