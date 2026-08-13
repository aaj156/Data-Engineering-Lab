# 🧪 test_n_observe.md

# 🔷 TESTING STRATEGY OVERVIEW

You will test **5 scenarios**:

| Scenario | Purpose |
|---------|--------|
| 1 | Normal flow |
| 2 | High temperature alert |
| 3 | Multi-device streaming |
| 4 | Failure → DLQ |
| 5 | System stress / throughput |

---

# 🔷 BEFORE START (IMPORTANT)

## ✅ Run system

```bash
docker-compose down -v
docker-compose up --build
```

---

## ✅ Open dashboards

- Redpanda UI → http://localhost:8080  
- Streamlit → http://localhost:8501  
- Grafana → http://localhost:3000  

👉 Keep all open side-by-side

---

# 🔷 SCENARIO 1: NORMAL FLOW

## Goal
Verify pipeline working

## Observe

### Redpanda
- Messages flowing
- Topic: sensor-topic
- Lag ≈ 0

### Dashboard
- Graph updating
- Metrics increasing
- Gauge mostly green

### Grafana
- Smooth graph

✔ Conclusion: Pipeline working

---

# 🔷 SCENARIO 2: HIGH TEMPERATURE ALERT

## Modify producer
```python
temperature = random.choice([36, 38, 40, 42])
```

## Restart
```bash
docker-compose down
docker-compose up --build
```

## Observe

### Dashboard
- Gauge turns red
- Alert banner + toast

### Grafana
- Alert count increases

### Notifications
- Email + SMS received

✔ Conclusion: Alert system working

---

# 🔷 SCENARIO 3: MULTI-DEVICE

```python
random.choice(["sensor_1","sensor_2","sensor_3"])
```

## Observe

- Dashboard → multi-device chart
- Redpanda → mixed devices
- Grafana → variation

✔ Conclusion: Multi-source supported

---

# 🔷 SCENARIO 4: FAILURE → DLQ

## Modify producer
```python
"temperature": "INVALID"
```

## Restart

```bash
docker-compose down
docker-compose up --build
```

## Observe

### Redpanda
- sensor-dlq topic

### Logs
```
❌ Error
📤 Sent to DLQ
```

✔ Conclusion: Fault tolerance working

---

# 🔷 SCENARIO 5: STRESS TEST

## Modify
```python
time.sleep(0.1)
```

## Observe

- Redpanda → high throughput
- Grafana → dense graph
- Dashboard → rapid updates

✔ Conclusion: Performance tested

---

# 🔷 CROSS VALIDATION

Example:
```json
{"temperature": 40}
```

Trace:

- Redpanda → message
- Consumer → log
- DB → insert
- Dashboard → graph
- Grafana → metric
- Notification → alert

✔ Event traceability confirmed

---

# 🔷 DEBUG CHECKS

| Issue | Check |
|------|------|
| No data | Producer logs |
| Lag high | Consumer |
| No alerts | Threshold |
| No email | API keys |
| Dashboard blank | DB |

