#!/usr/bin/env bash

echo "=== Python ===" > report
python3 -V >> report
echo "-----" >> report
python3 io.py >> report
