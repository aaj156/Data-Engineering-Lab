# DE_LAB_SETUP_WSL

# Part 01 - WSL, Ubuntu 24.04, Initial Configuration, Java 21 & Python Setup

---

# System Configuration

| Item                    | Value            |
| ----------------------- | ---------------- |
| Host Operating System   | Windows 11       |
| Virtualization Platform | WSL2             |
| Linux Distribution      | Ubuntu 24.04 LTS |
| Default User            | dataeng          |
| Java Version            | OpenJDK 21       |
| Python Version          | Python 3.x       |

---

# Step 1 : Verify Windows Version

## Objective

Verify Windows is supported.

### Command

```powershell
winver
```

### Expected Output

A Windows About dialog should appear showing **Windows 11**.

### Decision

✅ Continue if Windows 11 is installed.

❌ Otherwise upgrade Windows before proceeding.

---

# Step 2 : Verify WSL Installation

## Command

```powershell
wsl --version
```

## Expected Output

```text
WSL version: 2.x.x
Kernel version: x.x.x
WSLg version: x.x.x
MSRDC version: x.x.x
```

### Decision

✅ Continue if WSL Version 2 is installed.

❌ Install WSL before continuing.

---

# Step 3 : Check Existing Ubuntu Installations

## Command

```powershell
wsl -l -v
```

## Expected Output

Example

```text
NAME              STATE           VERSION
Ubuntu-24.04      Stopped         2
```

or

```text
No installed distributions.
```

### Decision

If performing a fresh installation, continue to Step 4.

---

# Step 4 : Shutdown WSL

## Command

```powershell
wsl --shutdown
```

## Expected Output

No output.

### Verification

```powershell
wsl -l -v
```

All distributions should show **Stopped**.

---

# Step 5 : Remove Existing Ubuntu (Fresh Installation Only)

## Command

```powershell
wsl --unregister Ubuntu
```

or

```powershell
wsl --unregister Ubuntu-24.04
```

## Expected Output

No output.

### Verification

```powershell
wsl -l -v
```

Ubuntu should no longer appear.

---

# Step 6 : Install Ubuntu 24.04 LTS

Install **Ubuntu 24.04 LTS** from Microsoft Store.

Launch Ubuntu.

---

# Step 7 : Create Linux User

Ubuntu will prompt:

```text
Enter new UNIX username:
```

Enter

```text
dataeng
```

Ubuntu will then prompt for a password.

Choose your preferred password.

---

# Step 8 : Verify Login

## Command

```bash
whoami
```

## Expected Output

```text
dataeng
```

### Decision

✅ Continue only if the username is **dataeng**.

---

# Step 9 : Verify Home Directory

## Command

```bash
pwd
```

## Expected Output

```text
/home/dataeng
```

---

# Step 10 : Verify Current Hostname

## Command

```bash
hostname
```

## Expected Output

```text
<your-machine-name>
```

Example

```text
DESKTOP-ABCD123
```

---

# Step 11 : Verify User Groups

## Command

```bash
groups
```

## Expected Output

Output should contain

```text
sudo
```

Example

```text
dataeng adm cdrom sudo dip plugdev
```

### Decision

✅ Continue only if **sudo** appears.

---

# Step 12 : Verify Sudo Access

## Command

```bash
sudo whoami
```

Enter your password.

## Expected Output

```text
root
```

### Decision

✅ Continue only if output is **root**.

---

# Step 13 : Verify Default User

Exit Ubuntu.

```bash
exit
```

Open Ubuntu again.

Run

```bash
whoami
```

## Expected Output

```text
dataeng
```

### Decision

If another user appears, execute from Windows PowerShell:

```powershell
ubuntu2404 config --default-user dataeng
```

If the launcher name differs, first execute:

```powershell
Get-Command *ubuntu*
```

Then use the appropriate launcher.

---

# Step 14 : Verify Ubuntu Version

## Command

```bash
lsb_release -a
```

## Expected Output

```text
Distributor ID: Ubuntu
Description: Ubuntu 24.04 LTS
Release: 24.04
```

---

# Step 15 : Verify Linux Kernel

## Command

```bash
uname -r
```

## Expected Output

Example

```text
6.x.x-microsoft-standard-WSL2
```

---

# Step 16 : Verify WSL Environment

## Command

```bash
cat /proc/version
```

## Expected Output

Output should contain

```text
Microsoft
```

and

```text
WSL2
```

---

# Step 17 : Check Available Disk Space

## Command

```bash
df -h
```

## Expected Output

Filesystem usage table.

Root filesystem should have adequate free space.

---

# Step 18 : Check Memory

## Command

```bash
free -h
```

## Expected Output

Memory summary similar to

```text
total
used
free
available
```

---

# Step 19 : Check CPU Information

## Command

```bash
lscpu
```

## Expected Output

Information including

```text
Architecture
CPU(s)
Vendor ID
Model name
```

---

# Step 20 : Update Package Repository

## Command

```bash
sudo apt update
```

## Expected Output

Ends with

```text
Reading package lists... Done
```

No errors should be displayed.

---

# Step 21 : Upgrade Installed Packages

## Command

```bash
sudo apt upgrade -y
```

## Expected Output

Ends successfully with

```text
Done
```

No package errors.

---

# Step 22 : Remove Unused Packages

## Command

```bash
sudo apt autoremove -y
```

## Expected Output

Either

```text
0 upgraded, 0 newly installed...
```

or removal of unnecessary packages.

---

# Step 23 : Clean Package Cache

## Command

```bash
sudo apt autoclean
```

## Expected Output

Command completes without errors.

---

# Step 24 : Refresh Package Repository

## Command

```bash
sudo apt update
```

## Expected Output

```text
Reading package lists... Done
```

---

# Step 25 : Install Basic Utilities

## Command

```bash
sudo apt install -y \
curl \
wget \
git \
zip \
unzip \
tree \
vim \
nano \
build-essential \
software-properties-common \
apt-transport-https \
ca-certificates \
gnupg \
net-tools
```

## Expected Output

Installation completes successfully.

Ends with

```text
Processing triggers for...
```

No errors.

---

# Step 26 : Verify Installed Utilities

## Commands

```bash
curl --version
wget --version
git --version
zip -v
unzip -v
tree --version
vim --version
nano --version
```

## Expected Output

Each command should display its respective version.

No command should return

```text
command not found
```

---

# Step 27 : Install OpenSSH Client

## Command

```bash
sudo apt install -y openssh-client
```

## Expected Output

Installation completes successfully.

---

# Step 28 : Verify SSH Client

## Command

```bash
ssh -V
```

## Expected Output

```text
OpenSSH_x.x
```

---

# Step 29 : Install OpenSSH Server

## Command

```bash
sudo apt install -y openssh-server
```

## Expected Output

Installation completes successfully.

---

# Step 30 : Verify SSH Service

## Command

```bash
systemctl status ssh
```

## Expected Output

```text
Active: active (running)
```

If systemd is not enabled under WSL, the command may report that systemd is unavailable. This is acceptable if you are not using the SSH server within WSL.

---

# Step 31 : Install Java 21

## Command

```bash
sudo apt install -y openjdk-21-jdk
```

## Expected Output

Installation completes successfully.

---

# Step 32 : Verify Java

## Command

```bash
java -version
```

## Expected Output

```text
openjdk version "21.x.x"
OpenJDK Runtime Environment
OpenJDK 64-Bit Server VM
```

---

# Step 33 : Verify Java Compiler

## Command

```bash
javac -version
```

## Expected Output

```text
javac 21.x.x
```

---

# Step 34 : Locate Java Installation

## Command

```bash
readlink -f $(which java)
```

## Expected Output

Example

```text
/usr/lib/jvm/java-21-openjdk-amd64/bin/java
```

---

# Step 35 : Configure JAVA_HOME

## Command

```bash
nano ~/.bashrc
```

Append

```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

Save and exit.

Reload

```bash
source ~/.bashrc
```

Verify

```bash
echo $JAVA_HOME
```

## Expected Output

```text
/usr/lib/jvm/java-21-openjdk-amd64
```

---

# Step 36 : Install Python 3

## Command

```bash
sudo apt install -y python3
```

## Expected Output

Installation completes successfully.

---

# Step 37 : Install pip

## Command

```bash
sudo apt install -y python3-pip
```

## Expected Output

Installation completes successfully.

---

# Step 38 : Install Python Virtual Environment

## Command

```bash
sudo apt install -y python3-venv
```

## Expected Output

Installation completes successfully.

---

# Step 39 : Verify Python

## Command

```bash
python3 --version
```

## Expected Output

```text
Python 3.x.x
```

---

# Step 40 : Verify pip

## Command

```bash
pip3 --version
```

## Expected Output

```text
pip xx.x.x
```

---

# Step 41 : Verify Virtual Environment Support

## Command

```bash
python3 -m venv --help
```

## Expected Output

Help information for the **venv** module.

---

# Step 42 : Create Standard Workspace

## Command

```bash
mkdir -p ~/projects
mkdir -p ~/datasets
mkdir -p ~/downloads
mkdir -p ~/software
mkdir -p ~/venvs
```

## Expected Output

No output.

Verify

```bash
tree ~ -L 1
```

## Expected Output

```text
datasets
downloads
projects
software
venvs
```

---

# Step 43 : Final System Verification

## Commands

```bash
whoami
hostname
pwd

java -version
javac -version

python3 --version
pip3 --version

git --version
curl --version
wget --version

lsb_release -a
```

## Expected Output

* Current user should be **dataeng**
* Ubuntu version should be **24.04 LTS**
* Java version should be **21**
* Python should be installed successfully.
* Git, Curl and Wget should display their versions.
* No command should report **command not found**.

---

# Step 44 : Install and Execute Configuration Report Utility

## Objective

Install the reusable **Configuration Report Generator** and verify the complete system configuration at the end of the experiment.

---

## Execute On

🐧 **Ubuntu Terminal (WSL)**

### Prerequisites

Ask to sir for the file **`generate_report.sh`** and place it in your Ubuntu environment.

---

## Create Reports Directory

### Command

```bash
mkdir -p ~/reports
```

### Expected Output

No output.

### Verification

```bash
ls ~
```

### Expected Output

The directory **reports** should be listed.

---

## Copy Report Script

### Command

```bash
cp generate_report.sh ~/reports/
```

### Expected Output

No output.

### Verification

```bash
ls ~/reports
```

### Expected Output

```text
generate_report.sh
```

---

## Make the Script Executable

### Command

```bash
chmod +x ~/reports/generate_report.sh
```

### Expected Output

No output.

### Verification

```bash
ls -l ~/reports
```

### Expected Output

The permission field should contain executable (`x`) bits, for example:

```text
-rwxr-xr-x
```

---

## Execute the Report Generator

### Command

```bash
~/reports/generate_report.sh
```

### Expected Output

The script will prompt for:

```text
Student/Faculty Name :
Roll Number          :
Batch                :
Experiment Number    :
Experiment Title     :
Remarks (Optional)   :
```

After entering the details, a concise **Data Engineering Lab Configuration Report** will be displayed on the terminal.

The report includes:

* Student/Faculty Information
* Experiment Details
* Ubuntu & WSL Information
* Username and Hostname
* IP Address
* CPU, Memory and Disk Information
* Environment Variables
* Installed Software Status
* Workspace Verification
* Last 20 Executed Commands
* Completion Date & Time
* Remarks

---

## Report Storage

### Expected Output

A timestamped report is automatically saved in:

```text
~/reports/
```

Example:

```text
Exp01_125A8001_20260714_224530.txt
```

---

## Part 01 Completion

If the generated report displays the required system information and is successfully saved in the **`~/reports`** directory without errors, then **Part 01 – WSL, Ubuntu 24.04, Initial Configuration, Java 21 & Python Setup** has been completed successfully and the system is ready for the next phase of the Data Engineering Infrastructure setup.
