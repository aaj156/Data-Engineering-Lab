
"""Step 1: Verify MongoDB connection."""
from common import get_db

print("="*55)
print("Data Engineering Lab - Python Step 1")
print("="*55)
print("Objective : Connect Python to MongoDB")
print("\nRun MongoDB before executing this script.")
input("Press ENTER after confirming MongoDB is running...")

db=get_db()
print("\nConnected Successfully")
print("Database:",db.name)
print("\nCheckpoint:")
print("Open mongosh and verify the same database exists.")
