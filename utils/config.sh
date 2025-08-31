#!/bin/bash
#
# utils/config.sh
#
# Simple configuration loader for Proc Master
# - Loads user config file (proc_master.conf)
# - Makes variables available to all feature scripts
# - No arrays, just plain shell variables
#

# -------------------------------
# 1. Define default config file path
# -------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$PROJECT_ROOT/config/proc_master.conf"

# -------------------------------
# 2. Check if config file exists
# -------------------------------
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[ERROR] Config file not found: $CONFIG_FILE"
    echo "Please make sure proc_master.conf exists in ../config/"
    exit 1
fi

# -------------------------------
# 3. Load configuration file
# -------------------------------
# Variables in proc_master.conf will become available directly
source "$CONFIG_FILE"

# -------------------------------
# 4. Optional: Validate required variables
# -------------------------------
# Exit if critical variables are missing
[[ -z "$LOG_DIR" ]] && echo "[ERROR] LOG_DIR not defined in config!" && exit 1
[[ -z "$LOG_LEVEL" ]] && echo "[ERROR] LOG_LEVEL not defined in config!" && exit 1
[[ -z "$ALERT_CPU" ]] && echo "[ERROR] ALERT_CPU not defined in config!" && exit 1
[[ -z "$ALERT_MEM" ]] && echo "[ERROR] ALERT_MEM not defined in config!" && exit 1
[[ -z "$NOTIFY_METHOD" ]] && echo "[ERROR] NOTIFY_METHOD not defined in config!" && exit 1

# -------------------------------
# 5. Optional: Debug output
# -------------------------------
 echo "Configuration loaded:"
 echo "LOG_DIR=$LOG_DIR"
 echo "LOG_LEVEL=$LOG_LEVEL"
 echo "ALERT_CPU=$ALERT_CPU"
 echo "ALERT_MEM=$ALERT_MEM"
 echo "NOTIFY_METHOD=$NOTIFY_METHOD"

