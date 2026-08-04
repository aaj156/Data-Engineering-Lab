#!/bin/bash
source venv/bin/activate
python - <<'PY'
mods=["fastapi","uvicorn","pymongo","elasticsearch","requests","dotenv"]
for m in mods:
    try:
        __import__(m if m!="dotenv" else "dotenv")
        print("OK",m)
    except Exception as e:
        print("FAIL",m,e)
PY
