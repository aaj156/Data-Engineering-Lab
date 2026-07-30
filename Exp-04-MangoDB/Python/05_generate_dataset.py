
from faker import Faker
import json, random

fake=Faker()

records=[]
for i in range(100):
    records.append({
        "productId":20000+i,
        "name":fake.word().title(),
        "price":random.randint(100,5000)
    })

with open("../datasets/generated_products.json","w") as f:
    json.dump(records,f,indent=2)

print("generated_products.json created.")
