# Mini ETL Laboratory – Step-by-Step Execution Guide

## Prerequisites
Run in order:

```bash
./01_environment_setup.sh
./02_postgresql_setup.sh
./03_pgadmin_setup_v4.sh   # Optional
./04_nifi_setup_v5.sh
./05_workspace_setup.sh
./06_verify_environment_v2.sh
```

## 1. Verify Environment
```bash
java --version
psql --version
python3 --version
```

## 2. Start PostgreSQL
```bash
sudo systemctl start postgresql
sudo systemctl status postgresql
sudo -u postgres psql -d etl_lab
```

Inside psql:
```sql
\dt
SELECT COUNT(*) FROM products;
\q
```

## 3. Start NiFi
```bash
cd ~/Mini-ETL-NiFi-PostgreSQL/software/nifi/bin
./nifi.sh start
./nifi.sh status
```
Status should be **UP**.

Open:
`https://localhost:8443/nifi/`

## 4. Build NiFi Flow
Create processors in this order:

1. InvokeHTTP
2. SplitJson
3. JoltTransformJSON
4. UpdateRecord
5. PutDatabaseRecord

Connect them sequentially.

## 5. Configure Processors

### InvokeHTTP
- GET
- URL: https://fakestoreapi.com/products
- Always Output Response = true

### SplitJson
JsonPath:
`$.*`

### JoltTransformJSON
Paste the provided JOLT specification.

### UpdateRecord
Reader = JsonTreeReader

Writer = JsonRecordSetWriter

### PutDatabaseRecord
- JDBC: jdbc:postgresql://localhost:5432/etl_lab
- Driver: org.postgresql.Driver
- Database: etl_lab
- Table: products
- Username: etluser
- Password: etl@123

## 6. Enable Controller Services
Enable:
- DBCPConnectionPool
- JsonTreeReader
- JsonRecordSetWriter

## 7. Run Pipeline
Start in this order:
1. PutDatabaseRecord
2. UpdateRecord
3. JoltTransformJSON
4. SplitJson
5. InvokeHTTP

Wait until all queues become zero.

## 8. Validate
```bash
sudo -u postgres psql -d etl_lab
```

```sql
SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 10;
SELECT category,COUNT(*) FROM products GROUP BY category;
\q
```

## 9. Export Flow
Export the flow as `MiniETL.json`.

## 10. Generate Reports
```bash
./generate_student_report_V2.sh
./assignment_grading_v2.sh
./pipeline_validation_report.sh
./final_lab_report.sh
```

## Submission Checklist
- Environment verified
- PostgreSQL running
- NiFi running
- Flow created
- Controller services enabled
- Pipeline executed
- Data loaded
- SQL verified
- MiniETL.json exported
- Reports generated
