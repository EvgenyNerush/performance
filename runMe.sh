#!/usr/bin/env bash

date > report
uname -romn >> report
cat /proc/cpuinfo | grep 'model name' | head -n 1 >> report
echo "-----" >> report
echo "C"
cd C/
./run.sh
echo "C++"
cd ../C++/
./run.sh && ./runClang.sh
echo "C#"
cd ../C#/
./run.sh
echo "Rust"
cd ../Rust/
./run.sh
echo "Julia"
cd ../Julia/
./run.sh
echo "Pypy"
cd ../Pypy/
./run.sh
echo "Python"
cd ../Python/
./run.sh
echo "Haskell"
cd ../Haskell/
./run.sh
echo "R"
cd ../R/
./run.sh
