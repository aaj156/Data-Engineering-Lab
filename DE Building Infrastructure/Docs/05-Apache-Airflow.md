# 🌬️ Module 05 – Apache Airflow Installation & Configuration

> **Experiment No. 2**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

Apache Airflow is one of the most widely used **workflow orchestration platforms** for designing, scheduling, monitoring, and managing Data Engineering pipelines. It allows engineers to define workflows as **Directed Acyclic Graphs (DAGs)** using Python code.

Unlike Apache NiFi, which provides a drag-and-drop interface, Apache Airflow follows an **Infrastructure as Code (IaC)** approach, where workflows are written programmatically. Airflow is extensively used in organizations to automate ETL/ELT pipelines, machine learning workflows, cloud data processing, and scheduled data integration tasks.

In this module, students will install Apache Airflow, configure the required Python environment, initialize the metadata database, start the Airflow services, create an administrator account, and verify successful installation using the Airflow Web UI.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Understand the purpose of Apache Airflow.
- Install Apache Airflow using Python Virtual Environment.
- Initialize the Airflow Metadata Database.
- Configure Airflow Home Directory.
- Create an Administrator User.
- Start Airflow Webserver and Scheduler.
- Access the Airflow Web Interface.
- Understand DAGs, Tasks, Operators, and Scheduling.
- Verify successful Airflow installation.

---

# 🧠 Why Apache Airflow?

Apache Airflow is used for:

- Workflow Scheduling
- ETL Pipeline Automation
- Data Pipeline Orchestration
- Job Dependency Management
- Workflow Monitoring
- Cloud Data Engineering
- Machine Learning Pipelines

---

# 🏗️ Apache Airflow Architecture

```text
                Python DAG
                     │
                     ▼
              Airflow Scheduler
                     │
                     ▼
            Metadata Database
               (PostgreSQL)
                     │
                     ▼
             Airflow Executor
                     │
                     ▼
             Worker Processes
                     │
                     ▼
              Task Execution
                     │
                     ▼
              Airflow Web UI
```

---

# 🔑 Core Components

| Component | Description |
|------------|-------------|
| DAG | Directed Acyclic Graph (Workflow) |
| Task | Individual Unit of Work |
| Operator | Executes a Task |
| Scheduler | Schedules Workflow Execution |
| Executor | Executes Tasks |
| Metadata Database | Stores Workflow Metadata |
| Webserver | Provides Airflow GUI |
| Worker | Executes Assigned Tasks |

---

# ⚙️ Software Requirements

- Ubuntu 24.04 LTS
- Python 3.12
- PostgreSQL 17 (Recommended)
- Python Virtual Environment
- Internet Connection

---

# 📦 Step 1 – Activate Python Virtual Environment

```bash
cd ~/DataEngineeringLab
source venv/bin/activate
```

Expected Output

```text
(venv)
```

---

# 📦 Step 2 – Upgrade pip

```bash
pip install --upgrade pip
```

---

# 📦 Step 3 – Install Apache Airflow

```bash
pip install apache-airflow
```

Verify Installation

```bash
airflow version
```

Expected Output

```text
Apache Airflow 3.x.x
```

---

# 📦 Step 4 – Configure AIRFLOW_HOME

```bash
echo 'export AIRFLOW_HOME=$HOME/airflow' >> ~/.bashrc

source ~/.bashrc
```

Verify

```bash
echo $AIRFLOW_HOME
```

Expected Output

```text
/home/<username>/airflow
```

---

# 📦 Step 5 – Initialize Metadata Database

```bash
airflow db migrate
```

This creates the metadata database required by Airflow.

---

# 📦 Step 6 – Create Administrator User

```bash
airflow users create \
    --username admin \
    --firstname Data \
    --lastname Engineer \
    --role Admin \
    --email admin@example.com
```

Enter password when prompted.

---

# 📦 Step 7 – Start Airflow Scheduler

Open a new terminal.

Activate Virtual Environment

```bash
source ~/DataEngineeringLab/venv/bin/activate
```

Run

```bash
airflow scheduler
```

Leave this terminal running.

---

# 📦 Step 8 – Start Airflow Webserver

Open another terminal.

Activate Virtual Environment

```bash
source ~/DataEngineeringLab/venv/bin/activate
```

Run

```bash
airflow api-server
```

---

# 📦 Step 9 – Access Airflow Web UI

Open Browser

```text
http://localhost:8080
```

Login using

Username

```text
admin
```

Password

```text
********
```

---

# 🖥️ Understanding the Airflow Interface

The Web UI contains:

- Dashboard
- DAG List
- Graph View
- Grid View
- Task Logs
- Task Instances
- Admin Panel
- Security
- Browse Menu

---

# 🔄 Step 10 – Verify Example DAGs

Navigate to

```text
DAGs
```

Example DAGs should be visible.

Examples include

- example_bash_operator
- example_python_operator
- tutorial

---

# ▶️ Step 11 – Trigger a DAG

Select

```text
example_bash_operator
```

Click

```text
▶ Trigger DAG
```

Observe

- Running
- Success
- Failed

Task Status

---

# 📁 Airflow Directory Structure

```text
~/airflow/

├── dags/
├── logs/
├── plugins/
├── airflow.cfg
└── airflow.db
```

---

# ⚡ Important Commands

| Command | Description |
|----------|-------------|
| airflow version | Check Version |
| airflow db migrate | Initialize Database |
| airflow users create | Create User |
| airflow scheduler | Start Scheduler |
| airflow api-server | Start Web Server |
| airflow dags list | List DAGs |
| airflow tasks list | List Tasks |

---

# ⚠️ Common Errors

## airflow Command Not Found

```bash
source venv/bin/activate
```

or

```bash
pip install apache-airflow
```

---

## Port 8080 Already Used

```bash
sudo ss -tulpn | grep 8080
```

Kill the conflicting process or use another port.

---

## Scheduler Not Running

```bash
airflow scheduler
```

---

## Database Initialization Error

```bash
airflow db migrate
```

---

# 💡 Best Practices

- Always use a Python Virtual Environment.
- Store DAGs inside the `dags/` directory.
- Use PostgreSQL instead of SQLite for production.
- Keep DAGs modular and readable.
- Use meaningful task names.
- Monitor Scheduler logs regularly.

---

# 📝 Observation Table

| Activity | Status | Remarks |
|-----------|--------|---------|
| Airflow Installed | | |
| Database Initialized | | |
| Admin User Created | | |
| Scheduler Running | | |
| Webserver Running | | |
| Web UI Accessible | | |
| DAG Executed | | |

---

# 🎯 Result

Apache Airflow was successfully installed and configured. The metadata database was initialized, an administrator account was created, the Scheduler and Webserver were started successfully, and the Airflow Web UI was accessed. A sample DAG was executed successfully, confirming that the workflow orchestration environment is ready for future Data Engineering experiments.

---

# 📖 Summary

Apache Airflow is a powerful workflow orchestration platform used to automate and monitor data pipelines. In this module, students installed Airflow, configured the runtime environment, initialized the metadata database, created an administrator account, started the Scheduler and Webserver, and successfully executed a sample DAG. Airflow is now ready to orchestrate ETL pipelines and integrate with PostgreSQL, Apache NiFi, and other Data Engineering tools.

---

# 📚 References

1. Apache Airflow Documentation  
   https://airflow.apache.org/docs/

2. Apache Airflow Installation Guide  
   https://airflow.apache.org/docs/apache-airflow/stable/installation/

3. Data Engineering with Python – Paul Crickard

---

# 📚 Next Module

➡ **06-Elasticsearch.md**  
Installing and Configuring Elasticsearch for Data Storage and Search
