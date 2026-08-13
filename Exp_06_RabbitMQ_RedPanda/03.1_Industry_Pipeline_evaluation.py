from datetime import datetime
import os

# -------------------------------
# 🔷 STUDENT DETAILS
# -------------------------------

student = {
    "name": input("Student Name: "),
    "roll_no": input("Roll No: "),
    "exp_no": input("Experiment No: "),
    "exp_title": input("Experiment Title: "),
    "faculty": input("Faculty Name: "),
    "date_of_performance": input("Date of Performance (YYYY-MM-DD): "),
    "date_of_submission": input("Date of Submission (YYYY-MM-DD): ")
}

# -------------------------------
# 🔷 PERFORMANCE INPUT
# -------------------------------

print("\nEnter Performance (y/n):")

def get_bool(prompt):
    return input(prompt + " (y/n): ").lower() == 'y'

performance = {
    "environment_setup": get_bool("Environment Setup Completed"),
    "pipeline_execution": get_bool("Pipeline Execution Successful"),
    "db_integration": get_bool("Database Integration Working"),
    "scenario_normal_flow": get_bool("Scenario 1: Normal Flow"),
    "scenario_alert": get_bool("Scenario 2: Alert Trigger"),
    "scenario_multi_device": get_bool("Scenario 3: Multi-device"),
    "scenario_dlq": get_bool("Scenario 4: DLQ Handling"),
    "scenario_stress": get_bool("Scenario 5: Stress Test"),
    "dashboard_analysis": get_bool("Dashboard Working"),
    "grafana_monitoring": get_bool("Grafana Monitoring"),
    "notifications_working": get_bool("Email/SMS Alerts"),
    "debugging_attempted": get_bool("Debugging Attempted")
}

# -------------------------------
# 🔷 MARKING SCHEME
# -------------------------------

marks = {
    "environment_setup": 5,
    "pipeline_execution": 5,
    "db_integration": 5,
    "scenarios": 15,
    "visualization": 10,
    "debugging": 5,
    "understanding": 5
}

TOTAL = 50
score = 0
remarks = []

# -------------------------------
# 🔷 EVALUATION LOGIC
# -------------------------------

if performance["environment_setup"]:
    score += marks["environment_setup"]
else:
    remarks.append("Setup incomplete")

if performance["pipeline_execution"]:
    score += marks["pipeline_execution"]
else:
    remarks.append("Pipeline execution failed")

if performance["db_integration"]:
    score += marks["db_integration"]
else:
    remarks.append("Database issue")

scenario_count = sum([
    performance["scenario_normal_flow"],
    performance["scenario_alert"],
    performance["scenario_multi_device"],
    performance["scenario_dlq"],
    performance["scenario_stress"]
])

score += (scenario_count / 5) * marks["scenarios"]

if scenario_count < 5:
    remarks.append(f"Only {scenario_count}/5 scenarios tested")

if performance["dashboard_analysis"] and performance["grafana_monitoring"]:
    score += marks["visualization"]
else:
    remarks.append("Visualization incomplete")

if performance["debugging_attempted"]:
    score += marks["debugging"]
else:
    remarks.append("Debugging not shown")

if performance["notifications_working"]:
    score += marks["understanding"]
else:
    remarks.append("Alerts not verified")

# -------------------------------
# 🔷 GRADE
# -------------------------------

if score >= 45:
    grade = "A+"
elif score >= 40:
    grade = "A"
elif score >= 30:
    grade = "B"
elif score >= 20:
    grade = "C"
else:
    grade = "D"

# -------------------------------
# 🔷 BUILD REPORT
# -------------------------------

report = f"""
============================================================
📊 STUDENT EVALUATION REPORT
============================================================

Student Name        : {student['name']}
Roll No             : {student['roll_no']}
Experiment No       : {student['exp_no']}
Experiment Title    : {student['exp_title']}
Faculty             : {student['faculty']}
Date of Performance : {student['date_of_performance']}
Date of Submission  : {student['date_of_submission']}

------------------------------------------------------------
📌 PERFORMANCE SUMMARY
------------------------------------------------------------
"""

for k, v in performance.items():
    status = "✔" if v else "✘"
    report += f"{k.replace('_',' ').title():35} : {status}\n"

report += f"""
------------------------------------------------------------
🎯 TOTAL SCORE : {round(score,2)} / {TOTAL}
🏆 GRADE       : {grade}

------------------------------------------------------------
📌 REMARKS
------------------------------------------------------------
"""

if remarks:
    for r in remarks:
        report += f"- {r}\n"
else:
    report += "Excellent Performance\n"

report += f"""
============================================================
Generated On: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
============================================================
"""

# -------------------------------
# 🔷 SAVE REPORT
# -------------------------------

os.makedirs("report", exist_ok=True)

filename = f"{student['roll_no']}_Industry_Grade_Pipeline_report.txt"
filepath = os.path.join("report", filename)

with open(filepath, "w", encoding="utf-8") as f:
    f.write(report)

# -------------------------------
# 🔷 OUTPUT
# -------------------------------

print(report)
print(f"\n📁 Report saved at: {filepath}")
