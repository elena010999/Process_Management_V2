#!/bin/bash
#
# utils/notify.sh
#
# Notification utility for proc_master
# - Supports desktop notifications only
# - NOTIFY_METHOD comes from config/proc_master.conf
#

# -------------------------------
# Main notify function
# -------------------------------
notify() {
    local level="$1"
    local title="$2"
    local body="${@:3}"

    if [[ "$NOTIFY_METHOD" == "desktop" ]]; then
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "$title" "$body"
        else
            echo "[WARN] notify-send not found. Notification skipped: $title - $body"
        fi
    else
        # NOTIFY_METHOD is not desktop, do nothing
        :
    fi
}

# -------------------------------
# Convenience wrappers
# -------------------------------
notify_info()  { notify "INFO" "$@"; }
notify_warn()  { notify "WARN" "$@"; }
notify_error() { notify "ERROR" "$@"; }

