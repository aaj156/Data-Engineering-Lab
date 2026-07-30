#!/usr/bin/env bash

# =====================================================
# Data Engineering Laboratory
# Experiment 04 - MongoDB CRUD & Indexing
# Interactive Guide (Instructor Mode)
# =====================================================

clear

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[0;31m"
NC="\033[0m"

pause() {
    echo
    read -rp "Press ENTER to continue..."
}

header() {
    clear
    echo -e "${BLUE}"
    echo "======================================================"
    echo "        DATA ENGINEERING LABORATORY"
    echo "        Experiment 04 : MongoDB"
    echo "      CRUD & Indexing in MongoDB"
    echo "======================================================"
    echo -e "${NC}"
}

show_intro() {
    header
    cat <<EOF

Welcome!

This interactive guide will help you perform the experiment.

You will manually execute most commands yourself.
The guide will explain each step, display commands,
and ask you to verify your progress.

Learning Path

  ✓ MongoDB Installation
  ✓ Verify Installation
  ✓ Start MongoDB Server
  ✓ Create Database
  ✓ CRUD Operations
  ✓ Indexing
  ✓ Aggregation
  ✓ Python Integration

EOF
    pause
}

installation_step() {
    header
    cat <<'EOF'
STEP 1 : Install MongoDB

Objective
---------
Install MongoDB Community Edition.

Action Required
---------------
Open another terminal (or use this one after exiting),
and type the installation commands from:

guide/01_installation.md

Do NOT copy blindly.
Read each instruction and understand it.

After completing the installation,
return here.

EOF
    pause

    header
    cat <<'EOF'
CHECKPOINT 1

Type the following command in your terminal:

    mongod --version

Expected Result

    MongoDB Server Version 8.x

Did you get the version information?

1) Yes
2) No

EOF
    read -rp "Enter your choice: " ans

    if [[ "$ans" == "1" ]]; then
        echo -e "${GREEN}Great! Installation looks successful.${NC}"
    else
        echo -e "${RED}Please revisit the installation guide before continuing.${NC}"
    fi
    pause
}

server_step() {
    header
    cat <<'EOF'
STEP 2 : Start MongoDB Server

Type the appropriate command according to your setup.

Example:

    sudo systemctl start mongod

OR

    mongod --dbpath /data/db

Verify using:

    sudo systemctl status mongod

or

    pgrep mongod

EOF
    pause
}

database_step() {
    header
    cat <<'EOF'
STEP 3 : Create Database

Open Mongo Shell

    mongosh

Then type

    use ecommerce_db

Verify using

    db

Expected Output

    ecommerce_db

EOF
    pause
}

crud_step() {
    header
    cat <<'EOF'
STEP 4 : CRUD Operations

Open the following file:

    mongodb/insert_products.js

Read the commands.

Type them manually in Mongo Shell.

After insertion verify using

    db.products.find()

EOF
    pause
}

index_step() {
    header
    cat <<'EOF'
STEP 5 : Indexing

Open

    mongodb/indexing.js

Type the index creation commands manually.

Verify

    db.products.getIndexes()

EOF
    pause
}

python_step() {
    header
    cat <<'EOF'
STEP 6 : Python Integration

Navigate to

    python/

Open

    mongo_connection.py

Run

    python3 mongo_connection.py

Expected

    Connected Successfully

EOF
    pause
}

finish() {
    header
    echo -e "${GREEN}"
    echo "Congratulations!"
    echo
    echo "You have completed the guided workflow."
    echo
    echo "Before submitting:"
    echo "  ✓ Complete checkpoints"
    echo "  ✓ Capture screenshots"
    echo "  ✓ Complete the report"
    echo -e "${NC}"
}

while true; do
    header
    cat <<EOF
1. Introduction
2. MongoDB Installation
3. Start MongoDB Server
4. Create Database
5. CRUD Operations
6. Indexing
7. Python Integration
8. Finish Experiment
0. Exit

EOF

    read -rp "Select an option: " choice

    case "$choice" in
        1) show_intro ;;
        2) installation_step ;;
        3) server_step ;;
        4) database_step ;;
        5) crud_step ;;
        6) index_step ;;
        7) python_step ;;
        8) finish; pause ;;
        0) echo "Thank you."; exit 0 ;;
        *) echo "Invalid option."; pause ;;
    esac
done
