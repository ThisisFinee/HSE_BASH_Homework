#!/usr/bin/env bash

set -eu

WATCH="${1:-.}"
LOG="${2:-./sorter.log}"
TIMESTAMP_FMT='%F %T'

IMAGES_DIR="$WATCH/Images"
DOCS_DIR="$WATCH/Documents"

mkdir -p "$IMAGES_DIR" "$DOCS_DIR"

move_file() {
  src="$1"
  dest_dir="$2"
  fname=$(basename "$src")
  if [[ -e "$dest_dir/$fname" ]]; then
    base="${fname%.*}"
    ext="${fname##*.}"
    if [[ "$fname" == "$ext" ]]; then
      ext=""
      newname="${base}_$(date +%s)"
    else
      newname="${base}_$(date +%s).${ext}"
    fi
    dest="$dest_dir/$newname"
  else
    dest="$dest_dir/$fname"
  fi
  mv -- "$src" "$dest"
  echo "$(date +"$TIMESTAMP_FMT") MOVED $src -> $dest" >> "$LOG"
}

shopt -s nullglob
for f in "$WATCH"/*; do
  if [[ -d "$f" ]]; then
    continue
  fi
  ext="${f##*.}"
  lc_ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
  case "$lc_ext" in
    jpg|jpeg|png|gif)
      move_file "$f" "$IMAGES_DIR"
      ;;
    txt|pdf|docx|doc|odt)
      move_file "$f" "$DOCS_DIR"
      ;;
    *)
      ;;
  esac
done
shopt -u nullglob
