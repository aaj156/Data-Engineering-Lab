# Industry-Grade Data Pipeline using Apache Airflow (WSL)

## 🎯 Aim

Design and implement an industry-style data pipeline using:

* API ingestion
* Airflow orchestration
* RabbitMQ (queue)
* Redpanda (streaming)
* PostgreSQL (storage)
* Visualization layer
* Retry & Email alert mechanisms

---

# 🏗️ Architecture

```
API → Airflow → RabbitMQ → Redpanda → Transform → PostgreSQL → Visualization
                     ↑
               Retry + Email Alerts
```

---

# 🧠 Terminal Setup

| Terminal   | Purpose                         |
| ---------- | ------------------------------- |
| Terminal 1 | Airflow Webserver               |
| Terminal 2 | Airflow Scheduler               |
| Terminal 3 | Development (DAG, config)       |
| Terminal 4 | Services (RabbitMQ, Docker, DB) |

---

# 🟢 PHASE 0: Pre-check System Setup

## 🔹 Terminal 4

### ✅ Check RabbitMQ

```bash
sudo service rabbitmq-server status
```

If not installed:

```bash
sudo apt install rabbitmq-server -y
sudo service rabbitmq-server start
```

---

### ✅ Check Docker

```bash
docker ps
```

If not installed:

```bash
sudo apt install docker.io -y
sudo usermod -aG docker $USER
```

👉 Restart WSL

---

### ✅ Start Redpanda (if not running)

```bash
docker run -d --name redpanda \
-p 9092:9092 \
docker.redpanda.com/redpandadata/redpanda \
redpanda start --overprovisioned --smp 1 --memory 1G --reserve-memory 0M --node-id 0 --check=false
```

---

### ✅ Check PostgreSQL

```bash
sudo service postgresql status
```

If not installed:

```bash
sudo apt install postgresql -y
sudo service postgresql start
```

---

# 🟢 PHASE 1: Python Dependencies

## 🔹 Terminal 3

Activate environment:

```bash
source ~/airflowexp/airflow_env/bin/activate
```

Install required packages:

```bash
pip install requests pandas pika kafka-python sqlalchemy psycopg2-binary
```

---

# 🟢 PHASE 2: Create DAG File

## 🔹 Terminal 3

Go to DAG folder:

```bash
cd ~/airflow/dags
```

Create file:

```bash
nano industry_etl_dag.py
```

---

# 🔥 COMPLETE DAG (READY TO PASTE)

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import logging

default_args = {
    "owner": "airflow",
    "email": ["your_email@gmail.com"],
    "email_on_failure": True,
    "retries": 1,
    "retry_delay": timedelta(minutes=2),
}

with DAG(
    dag_id="industry_pipeline",
    default_args=default_args,
    description="Full Industry ETL Pipeline",
    schedule_interval=None,
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:

    def extract():
        import requests, pandas as pd
        url = "https://jsonplaceholder.typicode.com/users"
        response = requests.get(url, timeout=10)

        if response.status_code != 200:
            raise Exception("API FAILED")

        df = pd.DataFrame(response.json())
        df.to_csv("/tmp/raw_api_data.csv", index=False)

    def send_to_rabbitmq():
        import pika
        connection = pika.BlockingConnection(pika.ConnectionParameters("localhost"))
        channel = connection.channel()
        channel.queue_declare(queue="etl_queue")
        channel.basic_publish(exchange="", routing_key="etl_queue", body="Data Ready")
        connection.close()

    def transform():
        import pandas as pd
        df = pd.read_csv("/tmp/raw_api_data.csv")
        df["name_length"] = df["name"].apply(len)
        df.to_csv("/tmp/processed_data.csv", index=False)

    def send_to_redpanda():
        from kafka import KafkaProducer
        import json
        producer = KafkaProducer(
            bootstrap_servers="localhost:9092",
            value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        )
        producer.send("etl_topic", {"status": "processed"})
        producer.flush()

    def load():
        import pandas as pd
        from sqlalchemy import create_engine
        engine = create_engine("postgresql://postgres:password@localhost:5432/postgres")
        df = pd.read_csv("/tmp/processed_data.csv")
        df.to_sql("etl_table", engine, if_exists="replace", index=False)

    extract_task = PythonOperator(task_id="extract", python_callable=extract)
    rabbit_task = PythonOperator(task_id="rabbitmq", python_callable=send_to_rabbitmq)
    transform_task = PythonOperator(task_id="transform", python_callable=transform)
    redpanda_task = PythonOperator(task_id="redpanda", python_callable=send_to_redpanda)
    load_task = PythonOperator(task_id="load", python_callable=load)

    extract_task >> rabbit_task >> transform_task >> redpanda_task >> load_task
```

---

Save file:

```
CTRL + X → Y → ENTER
```

---

# 🟢 PHASE 3: Restart Airflow

## 🔹 Terminal 1

```bash
pkill -f airflow
```

---

### Start services

## Terminal 1

```bash
airflow webserver --host 0.0.0.0 --port 8080
```

## Terminal 2

```bash
airflow scheduler
```

---

# 🟢 PHASE 4: Trigger DAG

Open:

```
http://localhost:8080
```

Steps:

1. Enable DAG
2. Click ▶️ Trigger

---

# 🟢 PHASE 5: Verify Outputs

## 🔹 Terminal 3

```bash
ls /tmp
cat /tmp/processed_data.csv
```

---

## 🔹 PostgreSQL

```bash
sudo -u postgres psql
```

```sql
SELECT * FROM etl_table;
```

---

# 🟢 PHASE 6: Docker Compose (Optional Full Stack)

## 🔹 Terminal 4

```bash
nano docker-compose.yml
```

Paste:

```yaml
version: '3'

services:
  redpanda:
    image: docker.redpanda.com/redpandadata/redpanda
    command: redpanda start --overprovisioned --smp 1 --memory 1G
    ports:
      - "9092:9092"

  metabase:
    image: metabase/metabase
    ports:
      - "3000:3000"

  postgres:
    image: postgres
    environment:
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
```

Run:

```bash
docker-compose up -d
```

---

# 🧠 Key Features Implemented

* API-based ingestion
* Airflow orchestration
* Retry mechanism (2 min delay)
* Email alerts
* RabbitMQ messaging
* Redpanda streaming
* PostgreSQL storage
* Visualization-ready

---

# ⚠️ Common Errors

| Issue               | Fix                       |
| ------------------- | ------------------------- |
| airflow not found   | Activate virtual env      |
| DAG not visible     | Place in ~/airflow/dags   |
| DB connection error | Check PostgreSQL password |
| Kafka error         | Ensure Redpanda running   |
| RabbitMQ error      | Restart service           |

---

# 🎯 Result

The industry-grade ETL pipeline was successfully implemented using Apache Airflow with integrated queueing, streaming, storage, and monitoring capabilities.

---

