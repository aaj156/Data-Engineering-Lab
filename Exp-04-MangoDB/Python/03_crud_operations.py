
from common import get_db

db=get_db()

print("CRUD Demonstration")
input("Press ENTER to READ all Demo products...")
for d in db.products.find({"brand":"SIES"},{"_id":0}):
    print(d)

input("\nPress ENTER to UPDATE the price...")
db.products.update_many({"brand":"SIES"},{"$set":{"price":1099}})
print("Updated.")

input("\nPress ENTER to DELETE demo products...")
db.products.delete_many({"brand":"SIES"})
print("Deleted.")
