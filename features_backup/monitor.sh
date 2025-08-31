#!/bin/bash
#
# monitor.sh - Process Monitor & Resource Tracker
#

source "$(dirname "$0")/../utils/setup.sh"

ALERT_CPU=${ALERT_CPU:-80}  # Default CPU alert threshold (%)
ALERT_MEM=${ALERT_MEM:-80}  # Default MEM alert threshold (%)

monitor_process() {
    local target pid stats cpu mem timestamp log_line

    target=$(prompt "Enter PID or process name (or 'q' to quit): ")
    [[ "$target" == "q" ]] && return 1

    # Resolve PID
    if [[ "$target" =~ ^[0-9]+$ ]]; then
        pid="$target"
    else
        pid=$(pgrep -n "$target")
    fi

    if [[ -z "$pid" ]]; then
        error_message "No such process found: $target"
        pm_error "monitor" "No such process: $target"
        return 0
    fi

    stats=$(ps -p "$pid" -o pid,%cpu,%mem --no-headers)
    if [[ -z "$stats" ]]; then
        error_message "Process $pid not running."
        pm_error "monitor" "Process $pid not running."
        return 0
    fi

    read -r pid cpu mem <<< "$stats"
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    log_line="[$timestamp] PID: $pid | CPU: $cpu% | MEM: $mem%"

    pm_info "monitor" "$log_line"
    info_message "$log_line"

    # Alerts
    if (( $(echo "$cpu > $ALERT_CPU" | bc -l) )); then
        warning_message "CPU usage high: $cpu%"
        pm_warn "monitor" "CPU usage $cpu% exceeds threshold $ALERT_CPU%"
        pm_notify "WARN" "Proc Master Alert" "CPU $cpu% > $ALERT_CPU% for PID $pid"
    fi

    if (( $(echo "$mem > $ALERT_MEM" | bc -l) )); then
        warning_message "Memory usage high: $mem%"
        pm_warn "monitor" "Memory usage $mem% exceeds threshold $ALERT_MEM%"
        pm_notify "WARN" "Proc Master Alert" "Memory $mem% > $ALERT_MEM% for PID $pid"
    fi
}

main_menu() {
    while true; do
        header "Process Monitor & Resource Tracker"
        menu "Monitor process" "Exit"
        choice=$(prompt "Choose an option: ")

        case "$choice" in
            1)
                if ! monitor_process; then
                    info_message "Exiting monitor."
                    footer
                    break
                fi
                ;;
            2)
                info_message "Exiting monitor."
                footer
                break
                ;;
            *)
                warning_message "Invalid option. Please select 1 or 2."
                ;;
        esac
        footer
    done
}

main_menu
footer

