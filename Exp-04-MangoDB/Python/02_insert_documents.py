
"""Step 2: Insert sample documents."""
from common import get_db

db=get_db()
products=db.products

doc={
    "productId":99999,
    "name":"Python Demo Product",
    "brand":"SIES",
    "category":"Demo",
    "price":999
}

print("Document to Insert")
print(doc)
input("\nPress ENTER after reviewing the document...")
products.insert_one(doc)
print("Inserted successfully.")
print("Verify manually using: db.products.find({productId:99999})")
