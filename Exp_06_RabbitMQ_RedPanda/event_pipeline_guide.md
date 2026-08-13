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

---

## 🔷 Phase 3: Add Code (Checklist)

Paste code into files (from previous response)

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
