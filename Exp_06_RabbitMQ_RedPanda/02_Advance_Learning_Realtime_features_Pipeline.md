# Event-Driven Pipeline: Real-Time Features (Alerts + Moving Average)

## ✅ Features Implemented

### 🔹 Feature 1: Threshold Alert
- If `temperature > 35` → trigger alert

### 🔹 Feature 2: Moving Average
- Compute moving average of last N values (window size = 5)

### 🔹 Feature 3: Logging Alerts
- Store alert events in PostgreSQL

---

# 🔷 STEP 1: Update Database

### 📄 Edit `db/init.sql`

```sql
CREATE TABLE IF NOT EXISTS sensor_data (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(50),
    temperature FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Alerts table
CREATE TABLE IF NOT EXISTS alerts (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(50),
    temperature FLOAT,
    alert_msg TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### ⚠️ IMPORTANT

Recreate containers:

```bash
docker-compose down -v
docker-compose up --build
```

---

# 🔷 STEP 2: Modify Consumer

### 📄 `consumer/consumer.py`

```python
# (Full consumer code with alert + moving average)
<PASTE YOUR CONSUMER CODE HERE>
```

---

# 🔷 STEP 3: Restart Pipeline

### Terminal 1

```bash
docker-compose down
docker-compose up --build
```

---

# 🔷 STEP 4: Observe Output

### Terminal 1

```
Received: {'temperature': 36.5}
🚨 ALERT: High Temperature Alert! Value=36.5
📊 Moving Avg (last 5): 32.4
```

---

# 🔷 STEP 5: Verify in PostgreSQL

### Terminal 2

```bash
docker exec -it postgres psql -U admin -d streaming_db
```

### Check Data

```sql
SELECT * FROM sensor_data;
SELECT * FROM alerts;
```

---

# 🔷 STEP 6: Test Scenarios

## 🧪 Scenario 1: Normal Flow
- Temp between 20–34  
✔ No alerts  
✔ Only data stored  

---

## 🧪 Scenario 2: High Temperature

### 📄 `producer/producer.py`

```python
# (Full producer code with FORCE_HIGH_TEMP)
<PASTE YOUR PRODUCER CODE HERE>
```

✔ Alerts triggered  
✔ Alerts stored in DB  

---

## 🧪 Scenario 3: Moving Average

- Wait for 5 messages  
✔ Moving average printed  

---

# 🔷 STEP 7: RabbitMQ Verification

Check:
- Messages flowing  
- Consumer = 1  
- Ready = low  
- No backlog  

---

# 🔷 STEP 8: Learning Outcome

✔ Stream processing  
✔ Real-time alerts  
✔ Window analytics  
✔ Event-driven system
