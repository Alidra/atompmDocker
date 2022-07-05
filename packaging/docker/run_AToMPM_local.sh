#!/bin/bash
# Author: Yentl Van Tendeloo and Bentley James Oakes

set -e

echo "Running AToMPM script..."
echo "Starting node..."
node httpwsd.js &
serverpid=$!
sleep 3

echo "Starting Python model transformation engine..."
python3 mt/main.py
