#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.env"
source "$SCRIPT_DIR/../_lib.sh"

LOG_FILE="$LOG_DIR/logmon.log"
ALERT_FILE="$LOG_DIR/logmon-alerts.log"
mkdir -p "$LOG_DIR"

IFS=',' read -r -a patterns <<< "$LOG_PATTERNS"

log_ok "Starting log monitor... (Press Ctrl+C to stop)"
tail -Fn0 ${LOG_FILES} | while read -r line; do
  for p in "${patterns[@]}"; do
    if echo "$line" | grep -qi "$p"; then
      echo "$(date): $line" >> "$ALERT_FILE"
      log_warn "Alert matched pattern '$p'"
    fi
  done
done

