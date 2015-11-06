#!/usr/bin/bash

echo "=== C ===" > report
gcc --version | head -n 1 >> report
echo "-----" >> report
gcc -O3 -std=c11 -lm io.c
./a.out >> report
