#!/usr/bin/env bash

echo "=== Haskell ===" > report
ghc -V | head -n 1 >> report
echo "-----" >> report
ghc -O2 --make -o a.out io.hs
./a.out --time-limit 90 >> report

