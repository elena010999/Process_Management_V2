#!/bin/bash
#
# utils/logging.sh
#
# Logging utility for proc_master
# - Three log files: info.log, warning.log, error.log
# - Each log line includes timestamp, level, script/component
# - Echoes to console as well
#

# -------------------------------
# Global variables (can be overridden by config)
# -------------------------------
LOG_DIR="./logs"
LOG_LEVEL="INFO"  # minimum level to log: INFO, WARN, ERROR

# Map log levels to numeric priority
declare -A LOG_PRIORITY=( ["ERROR"]=0 ["WARN"]=1 ["INFO"]=2 )

# -------------------------------
# Initialize logging (create log folder if missing)
# -------------------------------
log_init() {
    [[ ! -d "$LOG_DIR" ]] && mkdir -p "$LOG_DIR"
}

# -------------------------------
# Core logging function
# -------------------------------
log_message() {
    local level="$1"
    local component="$2"
    local message="${@:3}"

    # Skip if level is lower than configured
    [[ ${LOG_PRIORITY[$level]} -gt ${LOG_PRIORITY[$LOG_LEVEL]} ]] && return

    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local log_line="[$timestamp] [$level] [$component] $message"

    # Determine file based on level
    local logfile
    case "$level" in
        INFO) logfile="$LOG_DIR/info.log" ;;
        WARN) logfile="$LOG_DIR/warning.log" ;;
        ERROR) logfile="$LOG_DIR/error.log" ;;
        *) logfile="$LOG_DIR/info.log" ;; # default
    esac

    # Write to log file
    echo "$log_line" >> "$logfile"

    # Also print to console
    echo "$log_line"
}

# -------------------------------
# Convenience wrappers
# -------------------------------
log_info()  { log_message "INFO" "$@"; }
log_warn()  { log_message "WARN" "$@"; }
log_error() { log_message "ERROR" "$@"; }

