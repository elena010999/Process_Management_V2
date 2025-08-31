#!/bin/bash
#
# tree.sh - Process Tree Visualizer
#

# Load setup (includes config, logging, notify, messages)
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils/setup.sh"

DOT_FILE="$LOG_DIR/proc_tree.dot"

show_tree() {
    header "Process Tree (with stats)"

    ps -eo pid,ppid,user,pcpu,pmem,comm --sort=ppid | awk '
    BEGIN {
        printf("%-6s %-6s %-10s %-5s %-5s %s\n", "PID", "PPID", "USER", "CPU%", "MEM%", "COMMAND");
        print "------------------------------------------------------------------";
    }
    {
        printf("%-6s %-6s %-10s %-5s %-5s %s\n", $1, $2, $3, $4, $5, $6);
    }'

    pm_info "tree" "Displayed ASCII process tree"
    footer
}

export_dot() {
    mkdir -p "$LOG_DIR"

    {
        echo "digraph proc_tree {"
        echo "  node [shape=box, style=rounded];"
        
        ps -eo pid,ppid,comm --no-headers | while read -r pid ppid comm; do
            comm_escaped=$(echo "$comm" | sed 's/"/\\"/g')
            echo "  \"$pid\" [label=\"$comm_escaped\\nPID: $pid\"];"
            if [[ "$ppid" -ne 0 ]]; then
                echo "  \"$ppid\" -> \"$pid\";"
            fi
        done
        
        echo "}"
    } > "$DOT_FILE"

    pm_info "tree" "Exported process tree to $DOT_FILE"
    info_message "DOT file exported to $DOT_FILE. Use 'dot -Tpng $DOT_FILE -o proc_tree.png' to generate an image."
}

main_menu() {
    while true; do
        header "Proc Master Process Tree Visualizer"

        menu "Show ASCII process tree" "Export process tree to DOT file" "Quit"
        choice=$(prompt "Enter choice (1-3): ")

        case "$choice" in
            1) show_tree ;;
            2) export_dot ;;
            3)
                info_message "Exiting process tree visualizer."
                footer
                break
                ;;
            *)
                warning_message "Invalid choice."
                ;;
        esac
    done
}

main_menu

