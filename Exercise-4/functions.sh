#!/usr/bin/env bash

set -eu

greet() {
  local name="$1"
  printf "Hello, %s\n" "$name"
}

add() {
  local a="${1:-0}"
  local b="${2:-0}"
  echo $((a + b))
}

greet "World!"

sum=$(add 12 30)
echo "12 + 30 = $sum"
