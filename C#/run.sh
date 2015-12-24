#!/usr/bin/env bash

echo "=== C# ===" > report
mcs --version | head -n 1 >> report
echo "-----" >> report
mcs IOTest.cs
mono IOTest.exe >> report
