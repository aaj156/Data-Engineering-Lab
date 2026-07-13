# 📦 Module 01 – Prerequisites

> **Experiment No. ___**  
> **Building Infrastructure for Data Engineering**

---

# 📖 Overview

Before installing any Data Engineering tools, it is essential to prepare the operating system with the required software dependencies. Modern data engineering platforms rely on Java, Python, Linux utilities, package managers, and networking tools to operate correctly.

This module prepares the Ubuntu system by installing and verifying all the prerequisites required for PostgreSQL, pgAdmin 4, Apache NiFi, Apache Airflow, Elasticsearch, and Kibana.

---

# 🎯 Objectives

After completing this module, students will be able to:

- Prepare Ubuntu Linux for Data Engineering software installation.
- Update and upgrade system packages.
- Install essential development utilities.
- Install and configure OpenJDK.
- Install Python and pip.
- Create Python virtual environments.
- Install Git.
- Verify all installed software.
- Configure environment variables.
- Understand the importance of each prerequisite.

---

# 🧠 Why Are Prerequisites Important?

Every Data Engineering platform depends on several software components working together.

For example,

- Apache NiFi requires Java.
- Apache Airflow requires Python.
- PostgreSQL requires Linux system services.
- Elasticsearch requires Java.
- Kibana communicates with Elasticsearch.
- Git is required for version control.
- Virtual environments isolate Python dependencies.

Without properly configuring these prerequisites, later installations may fail or behave unexpectedly.

---

# 🏗 Prerequisite Architecture

```text
                Ubuntu 24.04 LTS
                        │
      ┌─────────────────┼─────────────────┐
      │                 │                 │
      ▼                 ▼                 ▼
    Java             Python             Linux Tools
      │                 │                 │
      └─────────────────┼─────────────────┘
                        ▼
               Data Engineering Tools
      PostgreSQL • NiFi • Airflow • Elastic • Kibana
```

---

# 💻 Hardware Requirements

| Component | Recommended |
|------------|-------------|
| Processor | Intel i5 / Ryzen 5 or better |
| RAM | Minimum 8 GB (16 GB Recommended) |
| Storage | 40 GB Free Space |
| Internet | Required |

---

# 🖥 Operating System

Recommended Operating System

```
Ubuntu 24.04 LTS
64-bit
```

Verify Ubuntu version

```bash
lsb_release -a
```

Expected Output

```
Distributor ID: Ubuntu
Description: Ubuntu 24.04 LTS
```
# If SYstem is not having Ubuntu 24.0.xx LTS
# Appendix A: Upgrading Ubuntu 20.04 LTS to Ubuntu 24.04 LTS

> **Important**
>
> Ubuntu 24.04 LTS provides better support for modern Data Engineering tools such as Java 21, Apache NiFi 2.x, Apache Airflow 2.x/3.x, Docker, Kubernetes, and the latest PostgreSQL releases.
>
> Students using Ubuntu 20.04 LTS are strongly encouraged to upgrade before beginning the laboratory exercises.

---

# A.1 Check Current Ubuntu Version

Open Terminal.

```bash
lsb_release -a
```

or

```bash
cat /etc/os-release
```

Expected Output

```text
Ubuntu 20.04 LTS
```

---

# A.2 Backup Important Files

Before upgrading, back up:

- Documents
- Downloads
- Projects
- SSH Keys
- PostgreSQL Databases (if any)
- Virtual Machines
- Source Code

It is also recommended to create a system restore image.

---

# A.3 Update Existing Packages

```bash
sudo apt update
```

```bash
sudo apt upgrade -y
```

```bash
sudo apt full-upgrade -y
```

Remove unnecessary packages.

```bash
sudo apt autoremove -y
```

```bash
sudo apt autoclean
```

---

# A.4 Reboot the System

```bash
sudo reboot
```

---

# A.5 Ensure Update Manager is Installed

```bash
sudo apt install update-manager-core
```

---

# A.6 Verify Release Upgrade Configuration

Open

```bash
sudo nano /etc/update-manager/release-upgrades
```

Ensure

```text
Prompt=lts
```

Save and Exit.

---

# A.7 Start the Upgrade

Run

```bash
sudo do-release-upgrade
```

If Ubuntu reports:

```text
No new release found.
```

use

```bash
sudo do-release-upgrade -d
```

> **Note:** Ubuntu 20.04 LTS upgrades first to Ubuntu 22.04 LTS. After completing that upgrade, repeat the process to upgrade from Ubuntu 22.04 LTS to Ubuntu 24.04 LTS.

---

# A.8 During Upgrade

Ubuntu will ask several questions.

### Replace Configuration File?

Recommended

```
Keep the currently installed version
```

unless you have modified it.

---

### Restart Services?

Select

```
Yes
```

---

### Remove Obsolete Packages?

Select

```
Yes
```

---

# A.9 Reboot

After the upgrade completes,

```bash
sudo reboot
```

---

# A.10 Verify Upgrade

```bash
lsb_release -a
```

Expected Output

```text
Distributor ID: Ubuntu

Description: Ubuntu 24.04 LTS

Release: 24.04
```

---

# A.11 Verify Kernel

```bash
uname -r
```

---

# A.12 Update Again

```bash
sudo apt update
```

```bash
sudo apt upgrade -y
---

# 📦 Step 1 – Update Ubuntu

## Objective

Update package information from Ubuntu repositories.

### Command

```bash
sudo apt update
```

### Explanation

- `sudo` executes the command with administrator privileges.
- `apt` is Ubuntu's package manager.
- `update` downloads the latest package information without installing updates.

### Verification

```bash
sudo apt update
```

There should be no package manager errors.

---

# 📦 Step 2 – Upgrade Installed Packages

## Objective

Upgrade all installed software packages.

### Command

```bash
sudo apt upgrade -y
```

### Explanation

- Downloads and installs the latest security patches.
- Improves system stability.
- Prevents compatibility issues.

---

# 📦 Step 3 – Install Essential Utilities

## Objective

Install common Linux tools required throughout the laboratory.

### Command

```bash
sudo apt install -y \
curl \
wget \
git \
vim \
nano \
unzip \
zip \
tar \
net-tools \
software-properties-common \
ca-certificates \
apt-transport-https \
gnupg \
lsb-release
```

---

## Why These Utilities?

| Utility | Purpose |
|----------|----------|
| curl | Download files via URL |
| wget | Download packages |
| git | Version control |
| unzip | Extract ZIP archives |
| tar | Extract TAR archives |
| net-tools | Network diagnostics |
| vim | Terminal editor |
| nano | Simple editor |
| gnupg | Verify package signatures |

---

# 📦 Step 4 – Verify Utilities

```bash
curl --version

wget --version

git --version
```

Expected Output

```
curl 8.x

wget 1.x

git version 2.x
```

---

# ☕ Step 5 – Install Java

## Why Java?

Many enterprise data engineering applications are written in Java.

Java is required for

- Apache NiFi
- Elasticsearch
- Kafka
- Hadoop
- Spark

---

## Install OpenJDK 21

```bash
sudo apt install openjdk-21-jdk -y
```

---

## Verify Installation

```bash
java -version
```

Expected Output

```
openjdk version "21"
```

---

## Check Java Compiler

```bash
javac -version
```

---

## Locate JAVA_HOME

```bash
readlink -f $(which java)
```

Example Output

```
/usr/lib/jvm/java-21-openjdk-amd64/bin/java
```

---

## Configure JAVA_HOME

Edit

```bash
nano ~/.bashrc
```

Add

```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

Reload

```bash
source ~/.bashrc
```

Verify

```bash
echo $JAVA_HOME
```

---

# 🐍 Step 6 – Install Python

Python is required for

- Apache Airflow
- Data Analysis
- ETL Scripts
- Automation

Install

```bash
sudo apt install python3 python3-pip python3-venv -y
```

---

## Verify Python

```bash
python3 --version

pip3 --version
```

---

# 🐍 Step 7 – Create Virtual Environment

## Why?

Virtual environments isolate project dependencies.

Without virtual environments

- Package conflicts occur.
- Version mismatches occur.
- Projects interfere with one another.

---

Create Workspace

```bash
mkdir ~/DataEngineeringLab

cd ~/DataEngineeringLab
```

Create Environment

```bash
python3 -m venv venv
```

Activate

```bash
source venv/bin/activate
```

Expected

```
(venv)
```

Deactivate

```bash
deactivate
```

---

# 📂 Step 8 – Create Laboratory Folder Structure

```bash
mkdir -p ~/DataEngineeringLab/{datasets,projects,scripts,logs,temp,downloads}
```

Verify

```bash
tree ~/DataEngineeringLab
```

Expected

```text
DataEngineeringLab

datasets

projects

scripts

logs

downloads

temp
```

---

# 🌐 Step 9 – Check Network Connectivity

```bash
ping google.com
```

---

# 💾 Step 10 – Check Available Memory

```bash
free -h
```

---

# 💽 Step 11 – Check Disk Space

```bash
df -h
```

---

# 🔥 Step 12 – Verify Open Ports

```bash
sudo ss -tulpn
```

Useful later for

- PostgreSQL
- NiFi
- Airflow
- Elasticsearch
- Kibana

---

# 📋 Installation Verification Checklist

| Component | Verification Command |
|------------|----------------------|
| Ubuntu | `lsb_release -a` |
| Java | `java -version` |
| Java Compiler | `javac -version` |
| Python | `python3 --version` |
| Pip | `pip3 --version` |
| Git | `git --version` |
| Curl | `curl --version` |
| Wget | `wget --version` |

---

# ⚠ Common Errors

## JAVA_HOME Not Found

Reason

Java not installed correctly.

Solution

```bash
sudo apt install openjdk-21-jdk
```

---

## pip Command Not Found

```bash
sudo apt install python3-pip
```

---

## Permission Denied

Use

```bash
sudo
```

---

## Virtual Environment Not Activated

```bash
source venv/bin/activate
```

---

# 📝 Observation Table

| Activity | Status | Remarks |
|-----------|--------|---------|
| Ubuntu Updated | | |
| Packages Upgraded | | |
| Utilities Installed | | |
| Java Installed | | |
| JAVA_HOME Configured | | |
| Python Installed | | |
| Virtual Environment Created | | |
| Git Installed | | |
| Internet Verified | | |

---

# 🎯 Result

The Ubuntu system was successfully prepared for Data Engineering software installation. All required development utilities, Java runtime, Python environment, Git, and essential Linux tools were installed and verified successfully. The system is now ready for installing PostgreSQL, Apache NiFi, Apache Airflow, Elasticsearch, Kibana, and other Data Engineering components.

---

# 📖 Summary

In this module, students prepared a clean Ubuntu environment by updating the operating system, installing essential development utilities, configuring Java and Python, creating an isolated Python virtual environment, and verifying all prerequisite software. These foundational steps ensure a stable and consistent environment for building a complete Data Engineering infrastructure.

---

# 📚 Next Module

➡ **02-PostgreSQL.md**

Install and Configure PostgreSQL Relational Database.
