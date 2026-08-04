#!/bin/bash
curl -X POST http://127.0.0.1:8000/students \
-H "Content-Type: application/json" \
-d '{"roll":101,"name":"Rahul","branch":"Computer","marks":89}'
echo
curl http://127.0.0.1:8000/students
