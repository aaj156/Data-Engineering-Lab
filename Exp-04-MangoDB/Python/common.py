
from pymongo import MongoClient

URI="mongodb://localhost:27017"
DB_NAME="ecommerce_db"

def get_db():
    client=MongoClient(URI)
    return client[DB_NAME]
