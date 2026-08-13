# Event-Driven Pipeline (RabbitMQ + Python + PostgreSQL)

## 🔷 STEP 1: Open Project Folder

```bash
cd event-driven-pipeline
```

---

## 🔷 STEP 2: Add Files (Final Code)

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

## 🔷 STEP 3: Checklist

- [ ] docker-compose.yml added  
- [ ] producer files added  
- [ ] consumer files added  
- [ ] init.sql added  

---

## 🔷 STEP 4: Run

```bash
docker-compose up --build
```
