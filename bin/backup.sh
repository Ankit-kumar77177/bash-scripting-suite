#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.env"
source "$SCRIPT_DIR/../_lib.sh"

LOG_FILE="$LOG_DIR/backup.log"
mkdir -p "$BACKUP_DIR"

timestamp() { date +%Y%m%d-%H%M%S; }

pack_tar() {
  local ts dest excludes
  ts=$(timestamp)
  dest="$BACKUP_DIR/backup-$ts.tar.gz"
  IFS=' ' read -r -a ex <<< "$BACKUP_EXCLUDES"
  local ex_args=()
  for e in "${ex[@]}"; do ex_args+=(--exclude="$e"); done
  tar -czf "$dest" "${ex_args[@]}" ${BACKUP_SOURCE_DIRS}
  log_ok "Backup created: $dest"
  ls -1t "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | tail -n +$((BACKUP_RETENTION+1)) | xargs -r rm -f --
}

pack_tar

