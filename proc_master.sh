#!/bin/bash
#
# Main Menu - Proc Master
# Entry point for all features
#

# Load utils and setup
source ./utils/setup.sh

while true; do
    clear
    header "🐧 Proc Master Menu"

    menu "Process Monitor & Resource Tracker" \
         "Interactive Process Manager" \
         "Zombie Process Cleaner" \
         "Process Tree Visualizer" \
         "Process Sandbox Launcher" \
         "Exit"

    choice=$(prompt "Choose an option: ")

    case $choice in
        1) ./features/monitor.sh ;;
        2) ./features/manager.sh ;;
        3) ./features/zombies.sh ;;
        4) ./features/tree.sh ;;
        5) ./features/sandbox.sh ;;
        6) echo "Exiting Proc Master. Goodbye!"; exit 0 ;;
        *) error_message "Invalid option. Try again."; sleep 1 ;;
    esac
done

