#!/bin/bash
#
# sandbox.sh - Process Sandbox Launcher
#

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../utils/setup.sh"

SANDBOX_DIR="/tmp/proc_sandbox.$$"   # Unique tmp dir per run

cleanup() {
    rm -rf "$SANDBOX_DIR"
    pm_info "sandbox" "Cleaned up sandbox directory $SANDBOX_DIR"
}
trap cleanup EXIT

header "Process Sandbox Launcher"

# Get command to run
cmd=$(prompt "Enter command to run in sandbox: ")
if [[ -z "$cmd" ]]; then
    error_message "No command provided!"
    pm_error "sandbox" "No command provided by user"
    footer
    exit 1
fi

# Get resource limits
cpu_limit=$(prompt "Enter CPU time limit in seconds (0 for no limit): ")
mem_limit=$(prompt "Enter memory limit in KB (0 for no limit): ")

# Get optional run-as user
run_user=$(prompt "Run as specific user? (leave blank for current user): ")

mkdir -p "$SANDBOX_DIR"
pm_info "sandbox" "Created sandbox directory $SANDBOX_DIR"

# Apply limits if specified
if [[ "$cpu_limit" =~ ^[0-9]+$ ]] && (( cpu_limit > 0 )); then
    ulimit -t "$cpu_limit"
    pm_info "sandbox" "Applied CPU time limit: $cpu_limit seconds"
fi

if [[ "$mem_limit" =~ ^[0-9]+$ ]] && (( mem_limit > 0 )); then
    ulimit -v "$mem_limit"
    pm_info "sandbox" "Applied memory limit: $mem_limit KB"
fi

# Run the command under optional user context
if [[ -n "$run_user" ]]; then
    sudo -u "$run_user" bash -c "$cmd" >"$SANDBOX_DIR/output.log" 2>&1
else
    bash -c "$cmd" >"$SANDBOX_DIR/output.log" 2>&1
fi

EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    pm_info "sandbox" "Command '$cmd' completed successfully"
else
    pm_error "sandbox" "Command '$cmd' failed with exit code $EXIT_CODE"
fi

info_message "Sandbox execution complete. Logs available at $SANDBOX_DIR/output.log"

footer

