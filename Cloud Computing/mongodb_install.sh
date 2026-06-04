#!/bin/bash

set -e
sudo apt-get update
sudo apt-get install -y gnupg curl lsb-release

# get gpg 
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg --yes --dearmor -o /usr/share/keyrings/mongodb-server-8.0.gpg

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod
