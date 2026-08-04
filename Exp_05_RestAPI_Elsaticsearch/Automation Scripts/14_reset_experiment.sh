#!/bin/bash
read -p "This will delete MongoDB collection and Elasticsearch index. Continue? (y/n): " c
if [ "$c" = "y" ]; then
mongosh --eval 'use college; db.students.drop();'
curl -X DELETE http://localhost:9200/students
echo "Reset complete."
fi
