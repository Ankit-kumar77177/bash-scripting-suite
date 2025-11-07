#!/usr/bin/env bash
set -Eeuo pipefail

# COLORS
C_RESET='\033[0m'; C_OK='\033[32m'; C_WARN='\033[33m'; C_ERR='\033[31m'; C_INFO='\033[36m'

# LOGGING FUNCTIONS
log()      { printf "%b[%(%F %T)T]%b %s\n" "$C_INFO" -1 "$C_RESET" "$*" | tee -a "${LOG_FILE:-/dev/stdout}"; }
log_ok()   { printf "%bOK%b %s\n"   "$C_OK" "$C_RESET" "$*" | tee -a "${LOG_FILE:-/dev/stdout}"; }
log_warn() { printf "%bWARN%b %s\n" "$C_WARN" "$C_RESET" "$*" | tee -a "${LOG_FILE:-/dev/stdout}"; }
log_err()  { printf "%bERR%b %s\n"  "$C_ERR" "$C_RESET" "$*" | tee -a "${LOG_FILE:-/dev/stdout}"; }

require() {
  local missing=()
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done
  if (( ${#missing[@]} )); then
    log_err "Missing dependencies: ${missing[*]}"
    exit 127
  fi
}

