#!/usr/bin/env bash
set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../config.env"
source "$SCRIPT_DIR/../_lib.sh"

LOG_FILE="$LOG_DIR/suite.log"
mkdir -p "$LOG_DIR"

menu() {
  clear
  cat <<EOF
================ System Maintenance Suite ================
1) Run Backup
2) System Update
3) Start Log Monitor
4) View Log Alerts
5) View Recent Backups
0) Exit
==========================================================
EOF
}

while true; do
  menu
  read -rp "Choose an option: " ans
  case "$ans" in
    1)
      "$SCRIPT_DIR/backup.sh"
      read -rp "Press Enter to continue..." ;;
    2)
      sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
      read -rp "Press Enter to continue..." ;;
    3)
      nohup "$SCRIPT_DIR/logmon.sh" >/dev/null 2>&1 &
      log_ok "Log monitor started in background."
      sleep 1 ;;
    4)
      echo "---- Recent Log Alerts ----"
      tail -n 20 "$LOG_DIR/logmon-alerts.log" || echo "No alerts yet."
      read -rp "Press Enter to continue..." ;;
    5)
      ls -lh "$BACKUP_DIR"
      read -rp "Press Enter to continue..." ;;
    0)
      echo "Goodbye!"
      exit 0 ;;
    *)
      echo "Invalid option!"
      read -rp "Press Enter to continue..." ;;
  esac
done

