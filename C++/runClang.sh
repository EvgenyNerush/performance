#!/usr/bin/env bash

echo "=== C++ ===" >> report
clang++ --version | head -n 1 >> report
echo "-----" >> report
clang++ -O3 -std=c++11 io.cpp
./a.out >> report
