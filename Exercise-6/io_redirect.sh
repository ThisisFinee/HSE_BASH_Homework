#!/usr/bin/env bash

set -eu

INPUT="input.txt"
OUTPUT="output.txt"
ERRORLOG="error.log"

if [[ -f "$INPUT" ]]; then
  echo "Содержимое $INPUT:"
  cat "$INPUT"
  wc -l "$INPUT" > "$OUTPUT"
  echo "Результат wc -l записан в $OUTPUT"
else
  ls "$INPUT" 2> "$ERRORLOG" || true
  echo "Ошибки выполнения ls для несуществующего файла записаны в $ERRORLOG"
fi
