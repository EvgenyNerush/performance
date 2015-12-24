#!/usr/bin/env bash

echo "=== Julia ===" > report
julia -v >> report
echo "-----" >> report
julia io.jl >> report
