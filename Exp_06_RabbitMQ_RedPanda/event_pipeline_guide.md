# Event-Driven Pipeline Lab Guide (RabbitMQ + Python + PostgreSQL)

## 🔷 Phase 0: Prerequisites Check

### Terminal 1
Run:
```
lsb_release -a
python3 --version
pip3 --version
docker --version
docker-compose --version
```

### If Docker NOT installed:
```
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER
```

⚠️ IMPORTANT:
- After this, CLOSE terminal and OPEN a new one
OR run:
```
newgrp docker
```

---

## 🔷 Phase 1: Environment Setup

### Terminal 1
Start Docker:
```
sudo service docker start
docker ps
```

Expected: empty container list (no error)

---

## 🔷 Phase 2: Project Structure

### Terminal 1

```
mkdir event-driven-pipeline
cd event-driven-pipeline

mkdir producer consumer db

touch docker-compose.yml
touch db/init.sql

touch producer/producer.py
touch producer/requirements.txt
touch producer/Dockerfile

touch consumer/consumer.py
touch consumer/requirements.txt
touch consumer/Dockerfile
```

## 🔷 Phase 3: Add Code (Checklist)

Paste code into files (from previous response)

### 📄 docker-compose.yml
```yaml
version: '3.8'

services:
  rabbitmq:
    image: rabbitmq:3-management
    container_name: rabbitmq
    ports:
      - "5672:5672"
      - "15672:15672"

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
      - rabbitmq
    restart: always

  consumer:
    build: ./consumer
    depends_on:
      - rabbitmq
      - postgres
    restart: always
```

---

### 📄 db/init.sql
```sql
CREATE TABLE IF NOT EXISTS sensor_data (
    id SERIAL PRIMARY KEY,
    device_id VARCHAR(50),
    temperature FLOAT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

### 📄 producer/requirements.txt
```txt
pika
```

---

### 📄 producer/Dockerfile
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY producer.py .
CMD ["python", "producer.py"]
```

---

### 📄 producer/producer.py
```python
import pika
import json
import time
import random

def connect_rabbitmq():
    while True:
        try:
            connection = pika.BlockingConnection(
                pika.ConnectionParameters(host='rabbitmq')
            )
            return connection
        except:
            print("Retrying RabbitMQ...")
            time.sleep(5)

connection = connect_rabbitmq()
channel = connection.channel()
channel.queue_declare(queue='sensor_queue', durable=True)

while True:
    data = {
        "device_id": "sensor_1",
        "temperature": round(random.uniform(20, 40), 2)
    }

    channel.basic_publish(
        exchange='',
        routing_key='sensor_queue',
        body=json.dumps(data),
        properties=pika.BasicProperties(delivery_mode=2)
    )

    print("Sent:", data)
    time.sleep(2)
```

---

### 📄 consumer/requirements.txt
```txt
pika
psycopg2-binary
```

---

### 📄 consumer/Dockerfile
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY consumer.py .
CMD ["python", "consumer.py"]
```

---

### 📄 consumer/consumer.py
```python
import pika
import json
import time
import psycopg2

def connect_postgres():
    while True:
        try:
            return psycopg2.connect(
                host="postgres",
                database="streaming_db",
                user="admin",
                password="admin"
            )
        except:
            print("Retrying Postgres...")
            time.sleep(5)

def connect_rabbitmq():
    while True:
        try:
            return pika.BlockingConnection(
                pika.ConnectionParameters(host='rabbitmq')
            )
        except:
            print("Retrying RabbitMQ...")
            time.sleep(5)

conn = connect_postgres()
cursor = conn.cursor()

connection = connect_rabbitmq()
channel = connection.channel()
channel.queue_declare(queue='sensor_queue', durable=True)

def callback(ch, method, properties, body):
    data = json.loads(body)
    print("Received:", data)

    cursor.execute(
        "INSERT INTO sensor_data (device_id, temperature) VALUES (%s, %s)",
        (data["device_id"], data["temperature"])
    )
    conn.commit()

    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_consume(queue='sensor_queue', on_message_callback=callback)
channel.start_consuming()
```

---

### ✅ Checklist
- [ ] docker-compose.yml added
- [ ] producer.py added
- [ ] consumer.py added
- [ ] init.sql added
- [ ] Dockerfiles added

---

## 🔷 Phase 4: Run Pipeline

### Terminal 1
```
docker-compose up --build
```

⛔ DO NOT close this terminal

---

## 🔷 Phase 5: Observe Output

### Terminal 1 (Running Logs)

Producer:
```
Sent: {...}
```

Consumer:
```
Received: {...}
```

---

## 🔷 Phase 6: RabbitMQ UI

### Open Browser
http://localhost:15672

Login:
- user: guest
- password: guest

### What to Observe:
- Go to **Queues**
- Queue name: sensor_queue
- Messages increasing/decreasing
- Consumers count = 1

---

## 🔷 Phase 7: PostgreSQL Verification

### Terminal 2 (NEW terminal)

Run:
```
docker exec -it postgres psql -U admin -d streaming_db
```

Then:
```
SELECT * FROM sensor_data;
```

Expected:
- Continuous rows inserted

---

## 🔷 Phase 8: Terminal Switching

- Terminal 1 → Docker pipeline running
- Terminal 2 → PostgreSQL verification
- Browser → RabbitMQ dashboard

---

---
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
<img width="1027" height="539" alt="3" src="https://github.com/user-attachments/assets/53543b6a-2120-44f6-b947-689d8579411c" />
<img width="1400" height="547" alt="2" src="https://github.com/user-attachments/assets/4557832f-eedd-474b-9c6f-aacefb133f2a" />
<img width="1400" height="1016" alt="1" src="https://github.com/user-attachments/assets/cd0a23f2-5919-4920-a5b2-475d9199bbb2" />
<img width="1560" height="1042" alt="5" src="https://github.com/user-attachments/assets/52c1c10d-3bb4-42aa-9b51-d927be31d9ce" />
<img width="1080" height="841" alt="4" src="https://github.com/user-attachments/assets/6fe76ed3-3e37-4731-9245-27beb86b4dc7" />

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
<img width="1199" height="738" alt="6" src="https://github.com/user-attachments/assets/25e540af-f2c3-4b40-92fb-a402be09ad73" />
<img width="1066" height="785" alt="9" src="https://github.com/user-attachments/assets/8016f073-fe75-46a3-8107-8cd81d1cf884" />
<img width="864" height="534" alt="8" src="https://github.com/user-attachments/assets/fe2613bf-c95b-49ec-9870-45884ab1744e" />
<img width="1132" height="489" alt="7" src="https://github.com/user-attachments/assets/cb3dbbac-a44b-4bf0-bfba-65ef2775a2ad" />


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

---

## 🔷 Phase 9: Troubleshooting

If error:
```
docker-compose down
docker-compose up --build
```

Permission issue:
```
sudo chmod -R 777 event-driven-pipeline
```

Port issue:
- Change ports in docker-compose.yml

---

## 🔷 Phase 10: Clean Stop

### Terminal 1
Press:
CTRL + C

Then run:
```
docker-compose down
```

---

## 🔷 Final Flow

1. Setup Docker
2. Create structure
3. Add code
4. Run containers
5. Observe streaming
6. Verify DB
7. Stop pipeline

---

## 🔷 Viva Line

“I implemented an event-driven pipeline using RabbitMQ where producer sends streaming data, consumer processes it, and stores in PostgreSQL staging table in real-time.”
