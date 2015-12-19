#!/usr/bin/env bash

echo "=== R ===" > report
R --version | head -n 1 >> report
R --slave -f io.R >> report
