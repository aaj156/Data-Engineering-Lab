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

