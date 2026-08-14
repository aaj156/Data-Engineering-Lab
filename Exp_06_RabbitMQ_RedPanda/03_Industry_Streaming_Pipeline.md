# 🟩 🚀 IndustryGrade Event-Driven Streaming Pipeline

## 📌 Overview
This document provides a complete **industry-grade implementation guide** for building an event-driven streaming pipeline using:
- Redpanda (Kafka API)
- Python Producer & Consumer
- PostgreSQL
- Streamlit Dashboard
- Grafana Monitoring
- Email/SMS Alerts

---

# 🔷 PHASE 0: PROJECT SETUP

## Create Project
```bash
mkdir IndustryGrade_event-driven_streaming_pipeline
cd IndustryGrade_event-driven_streaming_pipeline
```

## Create Structure
```bash
mkdir producer consumer dashboard db
touch docker-compose.yml .env
touch db/init.sql
touch producer/producer.py producer/requirements.txt producer/Dockerfile
touch consumer/consumer.py consumer/alerts.py consumer/requirements.txt consumer/Dockerfile
touch dashboard/app.py dashboard/requirements.txt dashboard/Dockerfile
```

# 🔷 🔧 PHASE 1: DOCKER SETUP (CORE INFRA)

## 📄 `docker-compose.yml`

```yaml
version: '3.8'

services:

  redpanda:
    image: docker.redpanda.com/redpandadata/redpanda:v23.3.5
    command:
      - redpanda start
      - --overprovisioned
      - --smp 1
      - --memory 1G
      - --reserve-memory 0M
      - --node-id 0
      - --check=false
    ports:
      - "9092:9092"
      - "9644:9644"

  console:
    image: docker.redpanda.com/redpandadata/console:v2.4.5
    ports:
      - "8080:8080"
    environment:
      KAFKA_BROKERS: redpanda:9092
    depends_on:
      - redpanda

  postgres:
    image: postgres:14
    container_name: postgres
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: streaming_db
    ports:
      - "5432:5432"
    volumes:
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql

  producer:
    build: ./producer
    depends_on:
      - redpanda

  consumer:
    build: ./consumer
    env_file:
      - .env
    depends_on:
      - redpanda
      - postgres

  dashboard:
    build: ./dashboard
    ports:
      - "8501:8501"
    depends_on:
      - postgres

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
```

---

# 🔷 🔧 PHASE 2: DATABASE

## 📄 `db/init.sql`

```sql
CREATE TABLE sensor_data (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(50),
    temperature FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alerts (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(50),
    temperature FLOAT,
    alert_msg TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

# 🔷 🔧 PHASE 3: ENV VARIABLES

## 📄 `.env`

```env
MAILGUN_API_KEY=your_key
MAILGUN_DOMAIN=your_domain

TWILIO_SID=your_sid
TWILIO_AUTH=your_auth
TWILIO_PHONE=+1415xxxxxxx
USER_PHONE=+91xxxxxxxxxx

EMAIL_TO=your@email.com
```

---

# 🔷 🔧 PHASE 4: PRODUCER

## 📄 `producer/requirements.txt`

```txt
confluent-kafka
```

## 📄 `producer/Dockerfile`

```dockerfile
FROM python:3.10

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY producer.py .

CMD ["python", "producer.py"]
```

## 📄 `producer/producer.py`

```python
from confluent_kafka import Producer
import json, time, random

producer = Producer({'bootstrap.servers': 'redpanda:9092'})
topic = "sensor-topic"

print("🚀 Producer Started")

while True:
    data = {
        "device_id": random.choice(["sensor_1", "sensor_2", "sensor_3"]),
        "temperature": round(random.uniform(20, 45), 2)
    }

    producer.produce(topic, json.dumps(data).encode())
    producer.flush()

    print("📤 Sent:", data)
    time.sleep(2)
```

---

# 🔷 🔧 PHASE 5: ALERT ENGINE

## 📄 `consumer/alerts.py`

```python
import requests, os, time

def retry(func, name):
    for i in range(3):
        try:
            res = func()
            if res.status_code in [200, 202]:
                print(f"✅ {name} sent")
                return
        except Exception as e:
            print(f"❌ {name} error:", e)
        time.sleep(2)
    print(f"🚨 {name} FAILED")

def send_email(msg):
    def req():
        return requests.post(
            f"https://api.mailgun.net/v3/{os.getenv('MAILGUN_DOMAIN')}/messages",
            auth=("api", os.getenv("MAILGUN_API_KEY")),
            data={
                "from": "alert@sys.com",
                "to": [os.getenv("EMAIL_TO")],
                "subject": "Alert",
                "text": msg
            }
        )
    retry(req, "Email")

def send_sms(msg):
    def req():
        return requests.post(
            f"https://api.twilio.com/2010-04-01/Accounts/{os.getenv('TWILIO_SID')}/Messages.json",
            auth=(os.getenv("TWILIO_SID"), os.getenv("TWILIO_AUTH")),
            data={
                "From": os.getenv("TWILIO_PHONE"),
                "To": os.getenv("USER_PHONE"),
                "Body": msg
            }
        )
    retry(req, "SMS")
```

---

# 🔷 🔧 PHASE 6: CONSUMER

## 📄 `consumer/requirements.txt`

```txt
confluent-kafka
psycopg2-binary
requests
```

## 📄 `consumer/Dockerfile`

```dockerfile
FROM python:3.10

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "consumer.py"]
```

## 📄 `consumer/consumer.py`

```python
from confluent_kafka import Consumer, Producer
import psycopg2, json
from alerts import send_email, send_sms

THRESHOLD = 35

conn = psycopg2.connect(
    host="postgres",
    database="streaming_db",
    user="admin",
    password="admin"
)
cursor = conn.cursor()

consumer = Consumer({
    'bootstrap.servers': 'redpanda:9092',
    'group.id': 'group1',
    'auto.offset.reset': 'earliest'
})

consumer.subscribe(['sensor-topic'])

dlq = Producer({'bootstrap.servers': 'redpanda:9092'})
DLQ_TOPIC = "sensor-dlq"

print("🚀 Consumer Started")

while True:
    msg = consumer.poll(1.0)

    if msg is None:
        continue

    data = json.loads(msg.value().decode())
    temp = data["temperature"]

    try:
        cursor.execute(
            "INSERT INTO sensor_data (device_id, temperature) VALUES (%s,%s)",
            (data["device_id"], temp)
        )
        conn.commit()

        print("📥 Stored:", data)

        if temp > THRESHOLD:
            alert = f"🚨 High Temp: {temp}"
            print(alert)

            cursor.execute(
                "INSERT INTO alerts (device_id, temperature, alert_msg) VALUES (%s,%s,%s)",
                (data["device_id"], temp, alert)
            )
            conn.commit()

            send_email(alert)
            send_sms(alert)

    except Exception as e:
        print("❌ Error:", e)

        dlq.produce(DLQ_TOPIC, json.dumps(data).encode())
        dlq.flush()

        print("📤 Sent to DLQ")
```

---

# 🔷 🔧 PHASE 7: DASHBOARD

## 📄 `dashboard/requirements.txt`

```txt
streamlit
psycopg2-binary
pandas
plotly
```

## 📄 `dashboard/Dockerfile`

```dockerfile
FROM python:3.10

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
```

## 📄 `dashboard/app.py`

```python
import streamlit as st
import psycopg2
import pandas as pd
from datetime import datetime
import plotly.graph_objects as go

# -------------------------------
# PAGE CONFIG
# -------------------------------
st.set_page_config(
    page_title="Streaming Dashboard",
    layout="wide",
    page_icon="📊"
)

# -------------------------------
# CUSTOM CSS (Metric Styling)
# -------------------------------
st.markdown("""
    <style>
    .stMetric {
        background-color: #111;
        padding: 12px;
        border-radius: 12px;
        text-align: center;
    }
    </style>
""", unsafe_allow_html=True)

st.title("📊 Real-Time Streaming Dashboard")

# -------------------------------
# AUTO REFRESH
# -------------------------------
st.markdown("<meta http-equiv='refresh' content='2'>", unsafe_allow_html=True)

# -------------------------------
# DB CONNECTION
# -------------------------------
@st.cache_resource
def get_connection():
    return psycopg2.connect(
        host="postgres",
        database="streaming_db",
        user="admin",
        password="admin"
    )

conn = get_connection()

# -------------------------------
# LOAD DATA
# -------------------------------
@st.cache_data(ttl=2)
def load_data():
    df = pd.read_sql("SELECT * FROM sensor_data ORDER BY id DESC LIMIT 200", conn)
    alerts = pd.read_sql("SELECT * FROM alerts ORDER BY id DESC LIMIT 10", conn)
    return df, alerts

df, alerts = load_data()

# -------------------------------
# SIDEBAR
# -------------------------------
st.sidebar.header("⚙️ Controls")
threshold = st.sidebar.slider("Alert Threshold", 30, 50, 35)

# -------------------------------
# METRICS
# -------------------------------
st.subheader("📈 Key Metrics")

col1, col2, col3, col4 = st.columns(4)

if not df.empty:
    latest_temp = df.iloc[0]['temperature']
    avg_temp = df['temperature'].mean()

    col1.metric("Total Records", len(df))
    col2.metric("Latest Temp", round(latest_temp, 2))
    col3.metric("Avg Temp", round(avg_temp, 2))
    col4.metric("Max Temp", round(df['temperature'].max(), 2))

# -------------------------------
# 🔥 GAUGE CHART
# -------------------------------
st.subheader("🌡️ Live Temperature Gauge")

if not df.empty:
    gauge = go.Figure(go.Indicator(
        mode="gauge+number",
        value=latest_temp,
        title={'text': "Current Temperature"},
        gauge={
            'axis': {'range': [0, 50]},
            'bar': {'color': "red" if latest_temp > threshold else "green"},
            'steps': [
                {'range': [0, threshold], 'color': "#00cc96"},
                {'range': [threshold, 50], 'color': "#ff4b4b"}
            ],
        }
    ))

    st.plotly_chart(gauge, use_container_width=True)

# -------------------------------
# 📊 TIME SERIES CHART
# -------------------------------
st.subheader("📊 Temperature Trend")

if not df.empty:
    df_sorted = df.sort_values(by="created_at")
    st.line_chart(df_sorted.set_index("created_at")["temperature"])

# -------------------------------
# 🔥 MULTI-DEVICE COMPARISON
# -------------------------------
st.subheader("🖥️ Multi-Device Comparison")

if not df.empty:
    multi_df = pd.read_sql("""
        SELECT device_id, AVG(temperature) as avg_temp
        FROM sensor_data
        GROUP BY device_id
    """, conn)

    st.bar_chart(multi_df.set_index("device_id"))

# -------------------------------
# 🚨 LIVE ALERT NOTIFICATIONS
# -------------------------------
st.subheader("🚨 Live Alerts")

if not alerts.empty:

    latest_alert = alerts.iloc[0]

    # 🔥 Toast Notification
    st.toast(f"🚨 ALERT: {latest_alert['temperature']}°C", icon="🚨")

    # 🔥 Banner Alert
    st.error(f"🚨 High Temperature Detected: {latest_alert['temperature']}°C")

    # Table with highlight
    def highlight(row):
        if row["temperature"] > threshold:
            return ['background-color: #ff4b4b'] * len(row)
        return [''] * len(row)

    st.dataframe(alerts.style.apply(highlight, axis=1), use_container_width=True)

else:
    st.success("✅ No active alerts")

# -------------------------------
# FOOTER
# -------------------------------
st.markdown("---")
st.caption(f"Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
```

---

# 🔷 🔧 PHASE 8: RUN SYSTEM

## ✅ Terminal Commands

```bash
docker-compose down -v
docker-compose up --build
```

---

# 🔷 🔍 PHASE 9: VERIFY SYSTEM

## 🔹 1. Redpanda UI

http://localhost:8080
✔ Topics visible
✔ Messages increasing

---

## 🔹 2. Streamlit Dashboard

http://localhost:8501
✔ Live charts updating
✔ Alerts visible

---

## 🔹 3. Grafana

http://localhost:3000
Login: admin / admin

✔ Add PostgreSQL datasource
✔ Create dashboards

---

## 🔹 4. Notifications

✔ Email received
✔ SMS received

---

# ✅ FINAL OUTPUT

After execution, you will have:

* Real-time streaming pipeline
* Automated alert system
* Live dashboard
* Monitoring system
* Fault-tolerant architecture (DLQ)

---

# 🏁 CONCLUSION

This is a **complete industry-grade streaming system** covering:

* Data ingestion
* Stream processing
* Storage
* Visualization
* Monitoring
* Alerting

---

## 📥 Save File As

```bash
streaming_pipeline_complete.md
```

---


---

# 🔷 PHASE 1: RUN SYSTEM

```bash
docker-compose down -v
docker-compose up --build
```

---

# 🔷 PHASE 2: VERIFY SYSTEM (IMPORTANT)

---

## 🔴 1. REDPANDA UI

Open: http://localhost:8080

### ✅ Check:
- Topics: `sensor-topic`, `sensor-dlq`
- Messages increasing
- Throughput non-zero

### ✅ Inspect Messages:
```json
{"device_id": "sensor_1", "temperature": 32.5}
```

### ✅ Consumer Lag:
- Should be near **0**

---

## 🟢 2. STREAMLIT DASHBOARD

Open: http://localhost:8501

### ✅ Verify:
- Live graph updating every 2 sec
- Gauge color changes:
  - Green (< threshold)
  - Red (> threshold)
- Metrics updating:
  - Total Records ↑
  - Avg Temp changes
- Multi-device chart visible

### 🚨 Alerts:
- Red banner appears
- Toast notification
- Table updated

---

## 🔵 3. GRAFANA

Open: http://localhost:3000

Login:
- admin / admin

### Add Data Source:
- Host: postgres:5432
- DB: streaming_db
- User: admin
- Password: admin

### Create Panels:

#### Temperature Trend
```sql
SELECT created_at, temperature FROM sensor_data;
```

#### Alert Count
```sql
SELECT COUNT(*) FROM alerts;
```

### ✅ Verify:
- Graph updates continuously
- Alerts count increases

---

## 🟣 4. NOTIFICATIONS

### 📧 Email:
- Received in inbox
- Matches alert log

### 📱 SMS:
- Received on phone
- Contains temperature

### 💬 WhatsApp:
- Instant alert message

---

# 🔷 FINAL CHECKLIST

- Producer sending data
- Redpanda receiving messages
- Consumer processing data
- PostgreSQL storing data
- Alerts triggered
- Dashboard updating
- Grafana monitoring
- Email/SMS working

---

# 🔷 FINAL VIVA LINE

> We implemented an industry-grade event-driven streaming pipeline with real-time ingestion, alerting, monitoring dashboards, and fault-tolerant processing using DLQ.

