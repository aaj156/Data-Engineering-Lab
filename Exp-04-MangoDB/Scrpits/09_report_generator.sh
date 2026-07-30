#!/usr/bin/env bash
mkdir -p reports
cat > reports/Experiment04_Report.md <<EOF
# Experiment 04 Report

## Student Information
- Name:
- Roll No:
- Date:

## Completion Checklist
- [ ] Installation
- [ ] Server Started
- [ ] Database Created
- [ ] CRUD Completed
- [ ] Index Created
- [ ] Aggregation Executed
- [ ] Python Connected

## Screenshots
Paste screenshots for each checkpoint.

## Reflection
1. What did you learn?
2. Why are indexes important?
3. What is the advantage of a flexible schema?

## Result
EOF
echo "Report template generated in reports/Experiment04_Report.md"
