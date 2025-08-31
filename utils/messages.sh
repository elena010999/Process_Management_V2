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
    local i=1
    for option in "$@"; do
        echo "$i) $option"
        ((i++))
    done
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

