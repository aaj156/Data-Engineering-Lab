# HOW TO RUN YOUR PYTHON EVALUATION SCRIPT IN WSL (UBUNTU)

---

# 🔷 🔹 STEP 1: Open WSL Terminal

You already did this during your pipeline work.

```bash
wsl

👉 You should see something like:

user@DESKTOP:~$
🔷 🔹 STEP 2: Go to Your Project Folder

Navigate to your pipeline project:

cd ~/IndustryGrade_event-driven_streaming_pipeline

👉 Check files:

ls

You should see:

producer  consumer  dashboard  db  report  docker-compose.yml
🔷 🔹 STEP 3: Create Script File (if not already)
nano evaluation_report.py

👉 Paste your full Python script
👉 Save:

Press CTRL + X
Press Y
Press ENTER
🔷 🔹 STEP 4: Check Python Installation
python3 --version

👉 Expected:

Python 3.x.x

If not installed:

sudo apt update
sudo apt install python3 python3-pip -y
🔷 🔹 STEP 5: Run the Script
python3 evaluation_report.py
🔷 🔹 STEP 6: Provide Inputs (Interactive)

You will see:

Student Name:
Roll No:
Experiment No:
...

👉 Enter values like:

Akshay Jadhav
BE-AI-101
Exp-05
Industry Grade Event Pipeline
Prof. XYZ
2026-08-14
2026-08-15
🔷 🔹 STEP 7: Enter Performance (y/n)

Example:

Environment Setup Completed (y/n): y
Pipeline Execution Successful (y/n): y
...
🔷 🔹 STEP 8: Output Generated

You will see:

📊 STUDENT EVALUATION REPORT
...
🎯 TOTAL SCORE: 46 / 50
🏆 GRADE: A+
🔷 🔹 STEP 9: Verify Report File

Go to report folder:

ls report

👉 Output:

BE-AI-101_Industry_Grade_Testing_Pipeline_report.txt
🔷 🔹 STEP 10: Open Report
cat report/BE-AI-101_Industry_Grade_Testing_Pipeline_report.txt

OR (better view):

nano report/BE-AI-101_Industry_Grade_Testing_Pipeline_report.txt
🔷 🎯 FINAL RESULT

✔ Script executed successfully
✔ Report generated and saved
✔ Ready for submission


---

# 🔷 📥 HOW TO USE

1. Create file:
```bash
nano run_evaluation_script_wsl.md
Paste above content
Save (CTRL + X → Y → ENTER)
