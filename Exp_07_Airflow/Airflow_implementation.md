# Experiment: Workflow Orchestration using Apache Airflow (WSL Ubuntu)

## 🎯 Aim

* Create a DAG
* Implement ETL (Extract → Transform → Load)
* Add scheduling & logging
* Execute, test, and validate

---

# 🔹 PHASE 0: System Preparation (WSL Ubuntu)

## ✅ Step 0.1: Update System (IMPORTANT)

```bash
sudo apt update
```

---

## ✅ Step 0.2: Install Required System Packages

```bash
sudo apt install -y python3-pip python3-venv build-essential libssl-dev libffi-dev python3-dev libsqlite3-dev
```

---

## ✅ Step 0.3: Install pandas (Required for ETL)

```bash
pip install pandas
```

---

# 🔹 PHASE 1: Environment Setup

## ✅ Step 1: Create Working Directory

```bash
mkdir ~/airflowexp
cd ~/airflowexp
```

---

## ✅ Step 2: Create Virtual Environment

```bash
python3 -m venv airflow_env
source airflow_env/bin/activate
```

### 🔍 Expected Output

```bash
(airflow_env) user@machine:~/airflowexp$
```

---

## ✅ Step 3: Upgrade pip

```bash
pip install --upgrade pip setuptools wheel
```

---

## ✅ Step 4: Set Environment Variables in `.bashrc`

### 🔹 Step 4.1: Open `.bashrc`

```bash
nano ~/.bashrc
```

---

### 🔹 Step 4.2: Add Variables at Bottom

```bash
# Airflow Environment Variables
export AIRFLOW_HOME=~/airflow
export AIRFLOW_VERSION=2.9.0
export PYTHON_VERSION=3.10
```

---

### 🔹 Step 4.3: Save File

* Press `CTRL + X`
* Press `Y`
* Press `Enter`

---

### 🔹 Step 4.4: Apply Changes

```bash
source ~/.bashrc
```

---

### 🔹 Step 4.5: Verify

```bash
echo $AIRFLOW_HOME
echo $AIRFLOW_VERSION
echo $PYTHON_VERSION
```

### ✅ Expected Output

```bash
/home/your-user/airflow
2.9.0
3.10
```

---

# 🔹 PHASE 2: Install Apache Airflow

## ✅ Step 5: Install Airflow

```bash
pip install "apache-airflow==${AIRFLOW_VERSION}" \
--constraint "https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
```

---

## 🔍 Step 6: Verify Installation

```bash
airflow version
```

### ✅ Expected Output

```bash
2.9.0
```

---

# 🔹 PHASE 3: Initialize Airflow

## ✅ Step 7: Initialize Database

```bash
airflow db init
```

---

## 🔍 Verify Folder Structure

```bash
ls ~/airflow
```

### ✅ Expected Output

```bash
airflow.cfg  airflow.db  dags  logs  plugins
```

---

## ✅ Step 8: Create Admin User (Run Once)

```bash
airflow users create \
--username admin \
--firstname Admin \
--lastname User \
--role Admin \
--email admin@example.com \
--password admin
```

---

## ✅ Step 9: Ensure DAG Folder Exists

```bash
mkdir -p ~/airflow/dags
```

Check config:

```bash
grep dags_folder ~/airflow/airflow.cfg
```

---

# 🔹 PHASE 4: Start Airflow Services

## ⚠️ Use Two Terminals

---

## 🖥️ Terminal 1 → Webserver

```bash
source ~/airflowexp/airflow_env/bin/activate
airflow webserver --host 0.0.0.0 --port 8087
```

---

## 🖥️ Terminal 2 → Scheduler

```bash
source ~/airflowexp/airflow_env/bin/activate
airflow scheduler
```

---

## 🌐 Step 10: Open Airflow UI

```
http://localhost:8087
```

---

# 🔹 PHASE 5: Create ETL DAG

## 🖥️ Terminal 3

```bash
cd ~/airflow/dags
nano etl_dag.py
```

---

## ✅ Step 11: Paste DAG Code

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import pandas as pd
import logging

def extract():
    data = {"name": ["A","B","C"], "marks":[50,80,90]}
    df = pd.DataFrame(data)
    df.to_csv("/tmp/raw_data.csv", index=False)
    logging.info("Data Extracted")

def transform():
    df = pd.read_csv("/tmp/raw_data.csv")
    df["result"] = df["marks"].apply(lambda x: "Pass" if x>=60 else "Fail")
    df.to_csv("/tmp/processed_data.csv", index=False)
    logging.info("Data Transformed")

def load():
    df = pd.read_csv("/tmp/processed_data.csv")
    logging.info(f"\nFinal Data:\n{df}")

with DAG(
    dag_id="etl_pipeline_wsl",
    start_date=datetime(2024,1,1),
    schedule_interval="@daily",
    catchup=False
) as dag:

    extract_task = PythonOperator(task_id="extract", python_callable=extract)
    transform_task = PythonOperator(task_id="transform", python_callable=transform)
    load_task = PythonOperator(task_id="load", python_callable=load)

    extract_task >> transform_task >> load_task
```

---

# 🔹 PHASE 6: Restart Services

```bash
pkill -f airflow
```

Restart:

```bash
airflow webserver --host 0.0.0.0 --port 8087
airflow scheduler
```

---

# 🔹 PHASE 7: Validate DAG

```bash
airflow dags list
```

### ✅ Expected Output

```bash
etl_pipeline_wsl
```

---

# 🔹 PHASE 8: Execute & Test

```bash
airflow tasks test etl_pipeline_wsl extract 2024-01-01
```

### ✅ Expected Output

```bash
Data Extracted
```

---

## ▶️ Trigger DAG via UI

* Enable DAG
* Click ▶️ Trigger

---

# 🔹 PHASE 9: Verify Outputs

## Raw Data

```bash
cat /tmp/raw_data.csv
```

```
name,marks
A,50
B,80
C,90
```

---

## Processed Data

```bash
cat /tmp/processed_data.csv
```

```
name,marks,result
A,50,Fail
B,80,Pass
C,90,Pass
```

---

# 🔹 PHASE 10: Logging

```bash
cd ~/airflow/logs/dag_id=etl_pipeline_wsl/
cd run_id=*/
cd task_id=extract/
cat *.log
```

---

# 🔹 PHASE 11: Monitoring

In Airflow UI:

* Graph View
* Tree View
* Gantt Chart

---

# 🔴 Common Errors & Fixes

### DAG Not Visible

```bash
airflow dags list
```

### Import Errors

```bash
airflow dags list-import-errors
```

### Restart Services

```bash
pkill -f airflow
```

### Port Issue

Use:

```bash
--host 0.0.0.0
```

---

# 🎯 Final DAG Flow

```
extract → transform → load
```

---

# 🎓 Learning Outcome

* Airflow setup in WSL
* DAG creation
* ETL pipeline execution
* Scheduling & logging
* Debugging using logs

---

# 🚀 Extensions

* PostgreSQL backend
* Real datasets
* Email alerts
* Docker-based Airflow
