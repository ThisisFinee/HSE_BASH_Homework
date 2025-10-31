#!/usr/bin/env bash

set -u

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 SOURCE_DIR DEST_DIR [LOGFILE]"
  exit 1
fi

SRC="$1"
DST="$2"
LOG="${3:-./backup_manager.log}"
DATE=$(date +%F)

SRC="${SRC%/}"
DST="${DST%/}"

if [[ ! -d "$SRC" ]]; then
  echo "Source directory '$SRC' does not exist." | tee -a "$LOG"
  exit 1
fi

mkdir -p "$DST" || { echo "Failed to create dest dir $DST" | tee -a "$LOG"; exit 1; }

echo "Backup started at $(date '+%F %T')" | tee -a "$LOG"
count=0
errors=0

while IFS= read -r -d '' file; do
  rel_path="${file#$SRC/}"
  dir_path=$(dirname "$rel_path")
  mkdir -p "$DST/$dir_path" 2>>"$LOG" || { echo "mkdir failed for $DST/$dir_path" >> "$LOG"; ((errors++)); continue; }

  base=$(basename "$file")
  if [[ "$base" == *.* ]]; then
    name="${base%.*}"
    ext=".${base##*.}"
  else
    name="$base"
    ext=""
  fi

  dest_file="$DST/$dir_path/${name}_$DATE$ext"

  if cp -p "$file" "$dest_file" 2>>"$LOG"; then
    echo "$(date '+%F %T') COPIED $file -> $dest_file" | tee -a "$LOG"
    ((count++))
  else
    echo "$(date '+%F %T') ERROR copying $file -> $dest_file" | tee -a "$LOG"
    ((errors++))
  fi
done < <(find "$SRC" -type f -print0)

echo "Backup finished at $(date '+%F %T'). Files copied: $count. Errors: $errors" | tee -a "$LOG"
