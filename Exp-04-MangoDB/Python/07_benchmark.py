
from common import get_db
import time

db=get_db()

query={"brand":"Dell"}

print("Benchmark")
input("Run once BEFORE creating an index. Press ENTER...")

t=time.perf_counter()
list(db.products.find(query))
print("Execution Time:",round(time.perf_counter()-t,6),"seconds")

print("\nNow create an index in mongosh:")
print("db.products.createIndex({brand:1})")
input("Press ENTER after creating the index...")

t=time.perf_counter()
list(db.products.find(query))
print("Execution Time:",round(time.perf_counter()-t,6),"seconds")
print("\nCompare both timings.")
