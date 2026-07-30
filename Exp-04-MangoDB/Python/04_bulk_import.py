
import json
from common import get_db

db=get_db()

path="../datasets/products.json"
print("Bulk Import Utility")
print("Dataset:",path)
input("Press ENTER after confirming the dataset exists...")

with open(path) as f:
    docs=json.load(f)

db.products.insert_many(docs)
print(f"Imported {len(docs)} documents.")
print("Verify with: db.products.countDocuments()")
