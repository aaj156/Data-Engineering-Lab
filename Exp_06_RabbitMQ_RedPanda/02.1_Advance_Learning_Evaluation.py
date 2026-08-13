from datetime import datetime
import os

# -------------------------------
# INPUT SECTION (FILL THIS)
# -------------------------------

student = {
    "name": "Akshay Jadhav",
    "roll_no": "BE-AI-101",
    "exp_no": "Exp-05",
    "exp_title": "Industry Grade Event-Driven Streaming Pipeline",
    "faculty": "Prof. XYZ",
    "date_of_performance": "2026-08-14",
    "date_of_submission": "2026-08-15"
}

# -------------------------------
# PERFORMANCE CHECKLIST
# -------------------------------

performance = {
    "environment_setup": True,
    "pipeline_execution": True,
    "db_integration": True,
    "scenario_normal_flow": True,
    "scenario_alert": True,
    "scenario_multi_device": True,
    "scenario_dlq": True,
    "scenario_stress": False,
    "dashboard_analysis": True,
    "grafana_monitoring": True,
    "notifications_working": True,
    "debugging_attempted": True
}

# -------------------------------
# MARKING SCHEME
# -------------------------------

marks_distribution = {
    "environment_setup": 5,
    "pipeline_execution": 5,
    "db_integration": 5,
    "scenarios": 15,
    "visualization": 10,
    "debugging": 5,
    "understanding": 5
}

TOTAL = 50

# -------------------------------
# EVALUATION LOGIC
# -------------------------------

score = 0
remarks = []

# Setup
if performance["environment_setup"]:
    score += marks_distribution["environment_setup"]
else:
    remarks.append("Environment setup incomplete")

# Execution
if performance["pipeline_execution"]:
    score += marks_distribution["pipeline_execution"]
else:
    remarks.append("Pipeline execution failed")

# DB
if performance["db_integration"]:
    score += marks_distribution["db_integration"]
else:
    remarks.append("Database integration issue")

# Scenarios
scenario_count = sum([
    performance["scenario_normal_flow"],
    performance["scenario_alert"],
    performance["scenario_multi_device"],
    performance["scenario_dlq"],
    performance["scenario_stress"]
])

scenario_score = (scenario_count / 5) * marks_distribution["scenarios"]
score += scenario_score

if scenario_count < 5:
    remarks.append(f"Only {scenario_count}/5 scenarios tested")

# Visualization
if performance["dashboard_analysis"] and performance["grafana_monitoring"]:
    score += marks_distribution["visualization"]
else:
    remarks.append("Visualization/Monitoring incomplete")

# Debugging
if performance["debugging_attempted"]:
    score += marks_distribution["debugging"]
else:
    remarks.append("Debugging not demonstrated")

# Understanding
if performance["notifications_working"]:
    score += marks_distribution["understanding"]
else:
    remarks.append("Alert system not verified")

# -------------------------------
# GRADE CALCULATION
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
# BUILD REPORT STRING
# -------------------------------

report = "\n" + "="*60 + "\n"
report += "📊 STUDENT EVALUATION REPORT\n"
report += "="*60 + "\n\n"

report += f"Student Name        : {student['name']}\n"
report += f"Roll No             : {student['roll_no']}\n"
report += f"Experiment No       : {student['exp_no']}\n"
report += f"Experiment Title    : {student['exp_title']}\n"
report += f"Faculty             : {student['faculty']}\n"
report += f"Date of Performance : {student['date_of_performance']}\n"
report += f"Date of Submission  : {student['date_of_submission']}\n"

report += "\n" + "-"*60 + "\n"
report += "📌 PERFORMANCE SUMMARY\n"
report += "-"*60 + "\n"

for key, value in performance.items():
    status = "✔" if value else "✘"
    report += f"{key.replace('_',' ').title():35} : {status}\n"

report += "\n" + "-"*60 + "\n"
report += f"🎯 TOTAL SCORE: {round(score,2)} / {TOTAL}\n"
report += f"🏆 GRADE      : {grade}\n"

report += "\n📌 REMARKS:\n"
if remarks:
    for r in remarks:
        report += f"- {r}\n"
else:
    report += "Excellent Performance\n"

report += "\n" + "="*60 + "\n"
report += "Report Generated On: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "\n"
report += "="*60 + "\n"

# -------------------------------
# SAVE REPORT TO FILE
# -------------------------------

# Create report folder if not exists
report_dir = "report"
os.makedirs(report_dir, exist_ok=True)

# File name format
filename = f"{student['roll_no']}_Advance_Learning_Pipeline_report.txt"
filepath = os.path.join(report_dir, filename)

# Write file
with open(filepath, "w", encoding="utf-8") as f:
    f.write(report)

# -------------------------------
# PRINT OUTPUT
# -------------------------------

print(report)
print(f"\n📁 Report saved at: {filepath}")
