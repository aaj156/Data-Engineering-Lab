```python
#!/usr/bin/env python3

"""
Industry Airflow Pipeline Evaluation Script
Total Marks: 50
"""

from datetime import datetime

print("\n===== Industry Pipeline Evaluation =====\n")

# -------------------------------
# Student Details
# -------------------------------

name = input("Enter Student Name: ")
roll = input("Enter Roll No: ")
batch = input("Enter Batch: ")
exp = input("Enter Experiment No & Title: ")
faculty = input("Enter Faculty Name: ")

date_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# -------------------------------
# Evaluation Function
# -------------------------------

def evaluate(question, marks):
    while True:
        ans = input(f"{question} (y/n): ").lower()
        if ans == 'y':
            return marks, "✔"
        elif ans == 'n':
            return 0, "✘"
        else:
            print("Enter 'y' or 'n' only")

score = 0
report_lines = []

def add_eval(question, marks):
    global score
    m, status = evaluate(question, marks)
    score += m
    report_lines.append(f"{question:70} [{status}] ({m}/{marks})")

# -------------------------------
# Evaluation Criteria (50 Marks)
# -------------------------------

print("\n===== Evaluation Criteria =====\n")

# PHASE 0: Infrastructure (10 Marks)
add_eval("RabbitMQ installed & running", 3)
add_eval("Docker installed & working", 3)
add_eval("Redpanda container running", 2)
add_eval("PostgreSQL installed & running", 2)

# PHASE 1: Environment & Dependencies (5 Marks)
add_eval("Required Python packages installed", 3)
add_eval("Virtual environment activated properly", 2)

# PHASE 2: DAG Design (10 Marks)
add_eval("DAG created with correct structure", 3)
add_eval("Task dependencies correctly defined", 3)
add_eval("Retry mechanism implemented", 2)
add_eval("Email alert configured", 2)

# PHASE 3: ETL + Messaging (10 Marks)
add_eval("API data extraction working", 2)
add_eval("RabbitMQ message sent successfully", 2)
add_eval("Data transformation logic correct", 3)
add_eval("Redpanda/Kafka integration working", 3)

# PHASE 4: Storage & Execution (10 Marks)
add_eval("Data loaded into PostgreSQL", 4)
add_eval("DAG executed successfully via UI", 3)
add_eval("Intermediate files generated (/tmp)", 3)

# PHASE 5: Verification & Logs (5 Marks)
add_eval("Logs verified in Airflow", 2)
add_eval("Data validated in PostgreSQL", 3)

# -------------------------------
# Grade Calculation
# -------------------------------

if score >= 45:
    grade = "Excellent"
elif score >= 35:
    grade = "Good"
elif score >= 25:
    grade = "Average"
else:
    grade = "Needs Improvement"

# -------------------------------
# Generate TXT Report
# -------------------------------

filename = f"Industry_Airflow_Eval_{roll}.txt"

with open(filename, "w") as f:
    f.write("====================================================\n")
    f.write("   INDUSTRY AIRFLOW PIPELINE EVALUATION REPORT      \n")
    f.write("====================================================\n\n")

    f.write(f"Name       : {name}\n")
    f.write(f"Roll No    : {roll}\n")
    f.write(f"Batch      : {batch}\n")
    f.write(f"Experiment : {exp}\n")
    f.write(f"Faculty    : {faculty}\n")
    f.write(f"Date & Time: {date_time}\n")

    f.write("\n----------------------------------------------------\n")
    f.write("Evaluation Details:\n")
    f.write("----------------------------------------------------\n")

    for line in report_lines:
        f.write(line + "\n")

    f.write("\n----------------------------------------------------\n")
    f.write(f"Total Score : {score} / 50\n")
    f.write(f"Grade       : {grade}\n")
    f.write("----------------------------------------------------\n")

    f.write("\nInstructor Remarks:\n")
    f.write("____________________________________________________\n\n")

    f.write("Signature:\n")
    f.write("____________________________________________________\n")

# -------------------------------
# Console Output
# -------------------------------

print("\n===== Evaluation Completed =====")
print(f"Score: {score}/50")
print(f"Grade: {grade}")
print(f"\nReport Generated: {filename}")
```
