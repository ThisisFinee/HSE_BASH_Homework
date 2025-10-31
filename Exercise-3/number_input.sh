#!/usr/bin/env bash

set -eu

read -r -p "Введите целое число: " input

if ! [[ "$input" =~ ^-?[0-9]+$ ]]; then
  echo "Введено не целое число."
  exit 1
fi

n=$((input))

if (( n > 0 )); then
  echo "Число положительное."
elif (( n < 0 )); then
  echo "Число отрицательное."
else
  echo "Число равно нулю."
fi

if (( n > 0 )); then
  echo "Подсчёт от 1 до $n:"
  i=1
  while (( i <= n )); do
    echo "$i"
    (( i++ ))
  done
fi
