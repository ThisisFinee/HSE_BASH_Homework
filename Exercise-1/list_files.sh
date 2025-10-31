#!/usr/bin/env bash

set -eu

echo "Список в текущей директории ($(pwd)):"
printf "%-60s %s\n" "Имя" "Тип"

for entry in .* *; do
  if [[ "$entry" == "." || "$entry" == ".." ]]; then
    continue
  fi

  if [[ ! -e "$entry" ]]; then
    continue
  fi

  if command -v file >/dev/null 2>&1; then
    type_desc=$(file -b --mime-type "$entry")
  else
    if [[ -d "$entry" ]]; then
      type_desc="directory"
    elif [[ -L "$entry" ]]; then
      type_desc="symlink"
    elif [[ -f "$entry" ]]; then
      type_desc="regular file"
    else
      type_desc="other"
    fi
  fi

  printf "%-60s %s\n" "$entry" "$type_desc"
done

echo
if [[ $# -ge 1 ]]; then
  target="$1"
  if [[ -e "$target" ]]; then
    printf 'Файл/ресурс "%s" найден (%s).\n' "$target" "$(ls -ld "$target" 2>/dev/null | awk '{print $1, $3, $4, $9}' || echo '')"
  else
    printf 'Файл/ресурс "%s" НЕ найден в текущей директории.\n' "$target"
  fi
else
  echo "Аргумент (имя файла для проверки) не передан. Пропускаем проверку."
fi

echo
echo "Информация о каждом файле/директории (имя — права):"
for f in .* *; do
  if [[ "$f" == "." || "$f" == ".." ]]; then
    continue
  fi
  if [[ ! -e "$f" ]]; then
    continue
  fi
  if stat --version >/dev/null 2>&1; then
    perms=$(stat -c "%A" "$f")
  else
    perms=$(stat -f "%Sp" "$f" 2>/dev/null || echo "unknown")
  fi
  printf "%-60s %s\n" "$f" "$perms"
done
