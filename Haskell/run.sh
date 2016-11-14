#!/usr/bin/env bash

echo "=== Haskell ===" > report
ghc -V | head -n 1 >> report
echo "-----" >> report
cabal run >> report
