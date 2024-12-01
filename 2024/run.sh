#!/usr/bin/env bash

set -e

# check for exactly 1-2 arguments
if [[ $# -ne 1 && $# -ne 2 ]]; then
  echo "Usage: $0 [-s] <day>"
  exit 1
fi

if [[ "$1" = "-s" ]]; then
    echo "Running in sample mode: $1"
    day=$2
    input_file=inputs/$day.sample.txt
else
    day=$1
    input_file=inputs/$day.txt
fi

echo "Running $day.hs with input file $(basename "$input_file")"
runhaskell "$day".hs < "$input_file"
