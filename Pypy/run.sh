#!/usr/bin/env bash

echo "=== Pypy ===" > report
pypy3 -V 2>> report
echo "-----" >> report
pypy3 io.py >> report
