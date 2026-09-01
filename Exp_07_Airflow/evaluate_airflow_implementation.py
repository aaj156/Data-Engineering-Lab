```python
#!/usr/bin/env python3

"""
Airflow Experiment Evaluation Script with TXT Report Generation
Total Marks: 50
"""

from datetime import datetime
import os

# -------------------------------
# Student Details Input
# -------------------------------

print("\n===== Airflow Experiment Evaluation =====\n")

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

# -------------------------------
# Evaluation Criteria
# -------------------------------

print("\n===== Evaluation Criteria =====\n")

score = 0
report_lines = []

def add_eval(question, marks):
    global score
    m, status = evaluate(question, marks)
    score += m
    report_lines.append(f"{question:65} [{status}]  ({m}/{marks})")

# PHASE-WISE EVALUATION
add_eval("System updated & required packages installed", 5)
add_eval("Virtual environment created & activated", 5)
add_eval("Environment variables configured correctly", 5)

add_eval("Airflow installed successfully", 5)
add_eval("Airflow DB initialized & folders verified", 5)

add_eval("Webserver & Scheduler running properly", 5)

add_eval("DAG file created in correct folder", 5)
add_eval("ETL pipeline implemented correctly", 5)

add_eval("DAG visible & executed successfully", 5)
add_eval("CLI task test executed", 5)

add_eval("Output files generated correctly", 3)
add_eval("Logs verified successfully", 2)

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

filename = f"Airflow_Evaluation_{roll}.txt"

with open(filename, "w") as f:
    f.write("=============================================\n")
    f.write("     AIRFLOW EXPERIMENT EVALUATION REPORT    \n")
    f.write("=============================================\n\n")

    f.write(f"Name       : {name}\n")
    f.write(f"Roll No    : {roll}\n")
    f.write(f"Batch      : {batch}\n")
    f.write(f"Experiment : {exp}\n")
    f.write(f"Faculty    : {faculty}\n")
    f.write(f"Date & Time: {date_time}\n")

    f.write("\n---------------------------------------------\n")
    f.write("Evaluation Details:\n")
    f.write("---------------------------------------------\n")

    for line in report_lines:
        f.write(line + "\n")

    f.write("\n---------------------------------------------\n")
    f.write(f"Total Score : {score} / 50\n")
    f.write(f"Grade       : {grade}\n")
    f.write("---------------------------------------------\n")

    f.write("\nInstructor Remarks:\n")
    f.write("_____________________________________________\n\n")

    f.write("Signature:\n")
    f.write("_____________________________________________\n")

# -------------------------------
# Console Output
# -------------------------------

print("\n===== Evaluation Completed =====")
print(f"Score: {score}/50")
print(f"Grade: {grade}")
print(f"\nReport Generated: {filename}")

```
