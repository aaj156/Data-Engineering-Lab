#!/usr/bin/env bash

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[0;31m"
NC="\033[0m"

banner(){
clear
echo -e "${BLUE}"
echo "=========================================================="
echo "      DATA ENGINEERING LABORATORY - CHECKPOINT"
echo "=========================================================="
echo -e "${NC}"
}

ask_result(){
echo
read -rp "Were you able to achieve the expected output? (yes/no): " ans
if [[ "$ans" == "yes" ]]; then
    echo -e "${GREEN}✓ Checkpoint Passed${NC}"
else
    echo -e "${RED}✗ Please revisit the corresponding guide and repeat the step.${NC}"
fi
echo
read -rp "Press ENTER to return..."
}

banner
echo -e "${GREEN}Checkpoint 4${NC}"
echo
echo "Topic"
echo "-----"
echo "CRUD Operations"
echo
echo "Objective"
echo "---------"
echo "Verify that you have successfully completed this stage."
echo
echo "Manual Verification"
echo "-------------------"
echo "Type the following command yourself:"
echo
echo "    db.products.find()"
echo
echo "Expected Output"
echo "---------------"
echo "Inserted documents are displayed"
echo
echo "Self Evaluation"
echo "---------------"
echo "Can you explain WHY this command is used?"
echo "If not, revisit the guide before moving ahead."
echo
echo "Related Files"
echo "-------------"
echo " - guide/03_crud_operations.md"
echo " - mongodb/02_insert_products.js"

echo
echo "Common Mistakes"
echo "---------------"
echo "- Skipping the verification step."
echo "- Typing commands incorrectly."
echo "- Ignoring terminal errors."
echo "- Continuing without understanding the output."

echo
echo "Before You Continue"
echo "-------------------"
echo "[ ] I executed the command manually."
echo "[ ] I obtained the expected output."
echo "[ ] I understand the purpose of this step."
echo "[ ] I am ready for the next activity."

ask_result
