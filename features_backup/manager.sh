#!/bin/bash
#
# manager.sh - Interactive Process Manager
#

source "$(dirname "$0")/../utils/setup.sh"

print_process_line() {
    local no=$1 pid=$2 user=$3 cpu=$4 mem=$5 cmd=$6
    printf "%d) %-8s %-10s %-6s %-6s %s\n" "$no" "$pid" "$user" "$cpu" "$mem" "$cmd"
}

main_menu() {
    while true; do
        header "Interactive Process Manager"

        search_term=$(prompt "Enter process name to search (leave blank for all, 'q' to quit): ")
        [[ "$search_term" == "q" ]] && info_message "Exiting Interactive Process Manager." && break

        if [[ -z "$search_term" ]]; then
            processes=$(ps aux --sort=-%cpu)
        else
            processes=$(ps aux --sort=-%cpu | grep -i "$search_term" | grep -v grep)
        fi

        if [[ -z "$processes" ]]; then
            warning_message "No matching processes found."
            footer
            continue
        fi

        printf "%-5s %-8s %-10s %-6s %-6s %s\n" "No." "PID" "USER" "CPU%" "MEM%" "COMMAND"
        echo "--------------------------------------------------------------"

        declare -A pid_map=()
        local i=1

        while read -r user pid cpu mem rest; do
            cmd="$rest"
            print_process_line "$i" "$pid" "$user" "$cpu" "$mem" "$cmd"
            pid_map[$i]=$pid
            ((i++))
        done < <(echo "$processes" | awk '{user=$1; pid=$2; cpu=$3; mem=$4; cmd=""; for(i=11;i<=NF;i++) cmd=cmd $i " "; print user, pid, cpu, mem, cmd}')

        choice=$(prompt "Select process number to manage (or 'q' to search again): ")
        [[ "$choice" == "q" ]] && footer && continue

        selected_pid=${pid_map[$choice]}
        if [[ -z "$selected_pid" ]]; then
            error_message "Invalid selection."
            footer
            continue
        fi

        menu "Kill (SIGTERM)" "Stop (SIGSTOP)" "Continue (SIGCONT)"
        action=$(prompt "Enter choice (1-3): ")

        case "$action" in
            1) signal="SIGTERM" ;;
            2) signal="SIGSTOP" ;;
            3) signal="SIGCONT" ;;
            *) warning_message "Invalid action."; footer; continue ;;
        esac

        if kill "-$signal" "$selected_pid"; then
            pm_info "manager" "Sent $signal to PID $selected_pid"
            pm_notify "INFO" "Proc Master Alert" "$signal sent to PID $selected_pid"
            info_message "$signal sent to $selected_pid"
        else
            error_message "Failed to send $signal to $selected_pid"
            pm_error "manager" "Failed to send $signal to PID $selected_pid"
        fi

        info_message "Returning to process list..."
        footer
    done
}

main_menu
footer

