#!/bin/bash
#
# zombies.sh - Zombie Process Cleaner
#

# Load setup (config, logging, notify, messages)
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils/setup.sh"

detect_zombies() {
    header "Zombie Process Detection"
    info_message "Scanning for zombie processes..."

    zombies=$(ps -eo pid,ppid,stat,cmd --no-headers | awk '$3 ~ /Z/')

    if [[ -z "$zombies" ]]; then
        info_message "No zombie processes found."
        pm_info "zombies" "No zombie processes detected"
    else
        echo "$zombies"
        pm_warn "zombies" "Zombie processes detected"
    fi

    footer
}

clean_zombies() {
    header "Zombie Process Cleanup"

    zombies=$(ps -eo pid,ppid,stat,cmd --no-headers | awk '$3 ~ /Z/ {print $1":"$2":"substr($0, index($0,$4))}')

    if [[ -z "$zombies" ]]; then
        info_message "No zombie processes found to clean."
        pm_info "zombies" "No zombie processes detected"
        footer
        return
    fi

    info_message "Found zombie processes:"

    while IFS=":" read -r pid ppid cmd; do
        echo "Zombie PID: $pid | Parent PID: $ppid | CMD: $cmd"
        pm_warn "zombies" "Zombie detected PID=$pid (Parent=$ppid, CMD=$cmd)"

        if kill -s SIGCHLD "$ppid" 2>/dev/null; then
            info_message "Sent SIGCHLD to parent $ppid to clean zombie PID $pid"
            pm_info "zombies" "Sent SIGCHLD to parent $ppid for zombie $pid"
        else
            error_message "Failed to signal parent $ppid. Manual cleanup may be required."
            pm_error "zombies" "Failed to signal parent $ppid for zombie $pid"
        fi
    done <<< "$zombies"

    footer
}

main_menu() {
    while true; do
        header "Zombie Process Cleaner"
        menu "Detect zombies" "Clean zombies" "Exit"
        choice=$(prompt "Choose an option: ")

        case "$choice" in
            1) detect_zombies ;;
            2) clean_zombies ;;
            3)
                info_message "Exiting Zombie Process Cleaner."
                break
                ;;
            *)
                warning_message "Invalid choice. Please select 1, 2, or 3."
                ;;
        esac
    done
}

main_menu

