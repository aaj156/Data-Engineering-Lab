#!/bin/bash
echo "=== Experiment 04 Part 2 Setup ==="

mkdir -p data/raw
mkdir -p data/processed
mkdir -p data/exports
mkdir -p logs
mkdir -p output

touch logs/etl.log
touch output/summary.txt

echo "Project structure created."

echo
echo "Next Commands:"
echo "python3 -m venv venv"
echo "source venv/bin/activate"
echo "pip install requests pymongo pandas"
echo "pip freeze > requirements.txt"
echo "nano config.py"
echo "nano products_etl.py"
echo "python products_etl.py"
echo "mongosh"
