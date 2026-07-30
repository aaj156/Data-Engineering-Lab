#!/usr/bin/env bash

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[0;31m"
NC="\033[0m"

banner(){
clear
echo -e "${BLUE}"
echo "=============================================================="
echo "        DATA ENGINEERING LABORATORY - EXPERIMENT 04"
echo "          NoSQL Basics: CRUD & Indexing in MongoDB"
echo "=============================================================="
echo -e "${NC}"
}

pause_step(){
echo
read -rp "Press ENTER to continue..."
}

open_guide(){
FILE="$1"
if command -v less >/dev/null 2>&1; then
    echo "Suggested reading: guide/$FILE"
fi
}


banner
echo -e "${GREEN}Step 1 of 7${NC}"
echo
echo "Topic : MongoDB Installation"
echo
echo "Learning Objective"
echo "------------------"
echo "Install MongoDB Community Edition using the official repository."
echo
echo "Why are we doing this?"
echo "-----------------------"
echo "This activity develops practical MongoDB skills by having you execute the commands yourself."
echo
echo "Related Guide"
echo "-------------"
echo "guide/01_installation.md"
open_guide "$(basename guide/01_installation.md)"
echo
echo "Student Activity"
echo "----------------"
echo "Type each installation command manually from the guide."
echo
echo "Expected Output"
echo "---------------"
echo "MongoDB Server v8.x"
echo
echo "Checkpoint"
echo "----------"
echo "Please type the following command yourself:"
echo
echo "    mongod --version"
echo
read -rp "Did you get the expected output? (yes/no): " ans
if [[ "$ans" == "yes" ]]; then
    echo -e "${GREEN}✓ Excellent! You may continue.${NC}"
else
    echo -e "${YELLOW}Please review guide/01_installation.md and repeat this step.${NC}"
fi

echo
echo "Common Mistakes"
echo "---------------"
echo "- Typing commands incorrectly."
echo "- Skipping verification."
echo "- Ignoring terminal error messages."
echo
echo "Before You Continue"
echo "-------------------"
echo "[ ] I completed this step."
echo "[ ] I verified the output."
echo "[ ] I understand why this step is required."

pause_step
