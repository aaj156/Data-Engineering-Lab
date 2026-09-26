# 🌐 **Real-Time Data Injection from Open API**

This section demonstrates how to build a **basic ETL (Extract → Transform → Load) pipeline** and integrate it with PostgreSQL for OLAP analysis.

---

## 🔧 **Step 1: Check curl Installation**

```bash
curl --version
```

### ✔ Expected Output

```
curl 7.x.x (x86_64-pc-linux-gnu)
```

### ❌ If Not Installed

```bash
sudo apt install curl -y
```

---

## 📡 **Step 2: Fetch Data from Open API**

Example API (Bitcoin price data):

```bash
curl https://api.coindesk.com/v1/bpi/currentprice.json
```

### ✔ Expected Output (JSON)

```json
{
  "time": {...},
  "bpi": {
    "USD": {
      "rate_float": 60000.12
    }
  }
}
```

---

## 🐍 **Step 3: Check Python Installation**

```bash
python3 --version
```

### ✔ Expected Output

```
Python 3.x.x
```

### ❌ If Not Installed

```bash
sudo apt install python3 python3-pip -y
```

---

## 📦 **Step 4: Install Required Python Libraries**

```bash
pip3 install requests psycopg2 pandas
```

---

## 🧠 **Step 5: Create Python ETL Script**

Create a file:

```bash
nano script.py
```

Paste the following code:

```python
import requests
import psycopg2

# Step 1: Extract (API Call)
url = "https://api.coindesk.com/v1/bpi/currentprice.json"
data = requests.get(url).json()

# Step 2: Transform
usd_rate = data['bpi']['USD']['rate_float']

# Step 3: Load into PostgreSQL
conn = psycopg2.connect(
    dbname="olap_lab",
    user="postgres",
    password="your_password",
    host="localhost"
)

cur = conn.cursor()

# Create table if not exists
cur.execute("""
CREATE TABLE IF NOT EXISTS bitcoin_price (
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price FLOAT
);
""")

# Insert data
cur.execute("INSERT INTO bitcoin_price(price) VALUES (%s);", (usd_rate,))

conn.commit()
cur.close()
conn.close()

print("Data inserted successfully:", usd_rate)
```

Save and exit:

```
CTRL + X → Y → Enter
```

---

## ▶️ **Step 6: Run the Script**

```bash
python3 script.py
```

### ✔ Expected Output

```
Data inserted successfully: 60000.12
```

---

## 📊 **Step 7: Perform OLAP Analysis**

Open PostgreSQL:

```bash
sudo -i -u postgres
psql
\c olap_lab
```

Run:

```sql
SELECT 
    DATE(timestamp) AS date,
    AVG(price) AS avg_price,
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM bitcoin_price
GROUP BY DATE(timestamp);
```

---

## 🔄 **Optional: Automate Data Collection (Cron Job)**

Open cron editor:

```bash
crontab -e
```

Add the following line:

```bash
*/5 * * * * python3 /home/yourpath/script.py
```

### ✔ Meaning

* Runs script every **5 minutes**
* Simulates **real-time data ingestion**

---

## ⚠️ **Important Notes**

* Replace `"your_password"` with your PostgreSQL password
* Ensure PostgreSQL service is running:

  ```bash
  sudo service postgresql start
  ```
* If connection fails, check:

  ```bash
  sudo nano /etc/postgresql/*/main/pg_hba.conf
  ```

---

## 🎯 **Outcome**

✔ Built a simple **ETL pipeline**
✔ Integrated **API → PostgreSQL**
✔ Performed **OLAP analysis on real-time data**
✔ Simulated streaming using **cron jobs**

---

## 🧠 **Concept Mapping**

| Stage     | Tool Used             |
| --------- | --------------------- |
| Extract   | API (curl / requests) |
| Transform | Python                |
| Load      | PostgreSQL            |
| Analyze   | SQL (OLAP queries)    |

---
