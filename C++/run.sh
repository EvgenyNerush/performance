#!/usr/bin/env bash

echo "=== C++ ===" > report
g++ --version | head -n 1 >> report
echo "-----" >> report
g++ -O3 -std=c++11 io.cpp
./a.out >> report
