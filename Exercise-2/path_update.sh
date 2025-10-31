#!/usr/bin/env bash

set -eu

echo "Текущее значение PATH:"
echo "$PATH"
echo

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /path/to/add"
  exit 1
fi

newdir="$1"

if [[ ! -d "$newdir" ]]; then
  echo "Директория '$newdir' не существует."
fi

export PATH="$newdir:$PATH"

echo "Новый PATH (только для текущей сессии):"
echo "$PATH"
