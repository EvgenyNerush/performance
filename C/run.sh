#!/usr/bin/env bash

echo "=== C ===" > report
gcc --version | head -n 1 >> report
echo "-----" >> report
gcc -O3 -std=c11 io.c -lm
./a.out >> report
