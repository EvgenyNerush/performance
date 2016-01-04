#!/usr/bin/env bash

echo "=== Rust ===" > report
rustc --version >> report
echo "-----" >> report
cargo build --release
cargo run --release >> report
