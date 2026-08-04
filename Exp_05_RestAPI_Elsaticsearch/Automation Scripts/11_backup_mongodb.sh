#!/bin/bash
mkdir -p backup
mongodump --out backup
echo "Backup completed."
