#!/bin/bash
source venv/bin/activate
pip install fastapi uvicorn pymongo elasticsearch requests python-dotenv
pip freeze > requirements.txt
