set -eu

LOG="${1:-./system_monitor.log}"
THRESHOLD_PERCENT=${2:-80}

timestamp() { date '+%F %T'; }

echo "=== Monitor report at $(timestamp) ===" | tee -a "$LOG"

if command -v uptime >/dev/null 2>&1; then
  echo "Load average: $(uptime | awk -F'load average:' '{print $2}')" | tee -a "$LOG"
else
  echo "Load average: (uptime not available)" | tee -a "$LOG"
fi

if command -v free >/dev/null 2>&1; then
  read -r total used free_mem shared buff_cache available < <(free -m | awk '/^Mem:/ {print $2, $3, $4, $5, $6, $7}')
  mem_pct=$(( (used * 100) / total ))
  echo "Memory: ${used}MB / ${total}MB (${mem_pct}%)" | tee -a "$LOG"
else
  echo "Memory: free command not available" | tee -a "$LOG"
  mem_pct=0
fi

echo "Disk usage (df -h /):" | tee -a "$LOG"
df -h / | tee -a "$LOG"

if (( mem_pct >= THRESHOLD_PERCENT )); then
  echo "Memory usage is ${mem_pct}% which is >= ${THRESHOLD_PERCENT}%." | tee -a "$LOG"
  echo "Top processes by memory usage:" | tee -a "$LOG"
  ps aux --sort=-%mem | awk 'NR<=11 {print NR-1, $0}' | tee -a "$LOG"
else
  echo "Memory usage below threshold (${THRESHOLD_PERCENT}%)." | tee -a "$LOG"
fi

echo "=== End of report ===" | tee -a "$LOG"