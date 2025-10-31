#!/usr/bin/env bash

set -eu

echo "Запускаю 3 фоновых команды: sleep 10, sleep 20, sleep 30"
sleep 10 &
pid1=$!
sleep 20 &
pid2=$!
sleep 30 &
pid3=$!

echo "PIDs: $pid1 $pid2 $pid3"
echo
echo "Список фоновых заданий (jobs):"
jobs -l

cat <<'EOF'

Демонстрация управления:
 - Список задач: jobs
 - Перенос задачи в foreground: fg %3
 - Если нажать Ctrl+Z во время выполнения fg, задача остановится
 - Отправить остановленную задачу в background: bg %3
 - Убить задачу: kill <PID> или kill %3

EOF
