#!/bin/bash
#
# utils/messages.sh
#
# Centralized messages and headers for Proc Master
#

# --- Function: header ---
# Usage: header "Process Monitor & Resource Tracker"
header() {
    local title="$1"
    echo "==============================="
    echo "   $title"
    echo "==============================="
}

# --- Function: footer ---
footer() {
    echo "-------------------------------"
    echo
}

# --- Function: menu ---
# Usage: menu "Option1" "Option2" "Option3"
menu() {
    local title="Main Menu"
    local prompt="Choose an option:"
    local height=15
    local width=50
    local menu_height=6

    # Build the whiptail options list from arguments
    local options=()
    local i=1
    for option in "$@"; do
        options+=("$i" "$option")
        ((i++))
    done

    # Use whiptail to show the menu
    local choice=$(whiptail --title "$title" --menu "$prompt" $height $width $menu_height "${options[@]}" 3>&1 1>&2 2>&3)

    echo "$choice"
}

# --- Function: prompt ---
# Usage: prompt "Enter PID: "
prompt() {
    local text="$1"
    read -rp "$text" input
    echo "$input"
}

# --- Function: info_message ---
# Usage: info_message "Message text"
info_message() {
    local msg="$1"
    echo "ℹ️  $msg"
}

# --- Function: warning_message ---
warning_message() {
    local msg="$1"
    echo "⚠️  $msg"
}

# --- Function: error_message ---
error_message() {
    local msg="$1"
    echo "❌ $msg"
}

