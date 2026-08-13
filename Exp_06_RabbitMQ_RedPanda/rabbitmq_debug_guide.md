# RabbitMQ Debugging & Verification Guide (Step 1–6)

## 🔷 STEP 1: Open RabbitMQ UI

Open browser:
http://localhost:15672

Login:
- Username: guest  
- Password: guest  

---

## 🔷 STEP 2: Dashboard Overview

### ✅ Observe:

- **Connections ≥ 1**
  → Producer/Consumer connected

- **Channels > 0**
  → Communication active

- **Message Rates**
  - Publish rate → Producer sending
  - Deliver rate → Consumer receiving  
  → Should be continuously moving

---

## 🔷 STEP 3: Go to Queues

Click:
Queues → sensor_queue

---

## 🔷 STEP 4: Queue Details

### ✅ 1. Queue Name
- sensor_queue  
→ Correct routing confirmed

---

### ✅ 2. Messages Section

#### 🔹 Ready
- Messages waiting in queue  
- Should be LOW or 0  

→ If increasing → Consumer issue

---

#### 🔹 Unacked
- Sent but not acknowledged  

→ Should be LOW  

→ If increasing → Consumer stuck / DB issue

---

#### 🔹 Total
- Ready + Unacked  

---

### ✅ 3. Consumers
- Should be **1**

→ If 0 → Consumer not running

---

### ✅ 4. Message Rates Graph
- Incoming → Producer  
- Outgoing → Consumer  

→ Should be continuous

---

## 🔷 STEP 5: Live Debug Testing

### 🧪 Test 1: Stop Consumer

Expected:
- Ready ↑ increases  
- Consumers = 0  

→ Queue storing messages

---

### 🧪 Test 2: Restart Consumer

Expected:
- Ready ↓ decreases  
- Unacked briefly ↑ then ↓  

→ Consumer processing working

---

## 🔷 STEP 6: Manual Message Testing

Scroll down → Publish Message

Send:
```
{"device_id": "test", "temperature": 99}
```

Verify:
- Consumer prints message  
- Data stored in DB  

---

## 🔷 DEBUG SUMMARY

| Scenario | Observation |
|----------|------------|
| Consumer down | Consumers = 0 |
| Producer not working | No message rate |
| DB issue | Unacked increases |
| Queue overload | Ready increases |

---

## 🔷 FINAL UNDERSTANDING

RabbitMQ UI confirms:

- Data flow is active  
- Messages are processed  
- Consumer is working  
- No data loss  

