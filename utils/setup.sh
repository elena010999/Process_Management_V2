#!/bin/bash
#
# utils/setup.sh
#
# Centralized setup for Proc Master scripts
# - Sets SCRIPT_DIR and PROJECT_ROOT
# - Sources config, logging, notify, and messages
#

# -------------------------------
# Resolve script and project directories
# -------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# -------------------------------
# Source utilities
# -------------------------------
source "$PROJECT_ROOT/utils/config.sh"
source "$PROJECT_ROOT/utils/logging.sh"
source "$PROJECT_ROOT/utils/notify.sh"
source "$PROJECT_ROOT/utils/messages.sh"

# -------------------------------
# Initialize logging and notifications
# -------------------------------
pm_log_init "$LOG_DIR"
pm_notify_init

