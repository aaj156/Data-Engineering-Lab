
from common import get_db

db=get_db()

print("Aggregation Demo")
pipeline=[
    {"$group":{"_id":"$category","AveragePrice":{"$avg":"$price"}}}
]

for row in db.products.aggregate(pipeline):
    print(row)

print("\nReflection:")
print("Which category has the highest average price?")
