#!/usr/bin/env bash

set -eu

BASHRC="${HOME}/.bashrc"
ALIAS_LINE="alias ll='ls -la'"

if grep -Fxq "$ALIAS_LINE" "$BASHRC" 2>/dev/null; then
  echo "Alias уже присутствует в $BASHRC"
else
  echo "$ALIAS_LINE" >> "$BASHRC"
  echo "Добавлено в $BASHRC: $ALIAS_LINE"
fi

echo "Чтобы сразу применить изменения, запустите: source ~/.bashrc"
