#!/bin/bash
curl -X GET "http://localhost:9200/students/_search?pretty" -o elasticsearch_export.json
echo "Exported to elasticsearch_export.json"
