#!/bin/bash
# =============================================================================
# Script to configure the current terminal to be able to use all built targets
# in the installation script.
# =============================================================================

# Function to resolve the absolute path of a file
function resolve_path() {
    dirname "$(realpath "$1")"
}
# Function to add the given directory to the path if it is not present yet
function add_to_path() {
    local -r directory="$1"
    local -r old_path="$2"

    if ! [[ "$old_path" =~ .*$directory.* ]]; then
        echo "${old_path:+${old_path}:}$directory"
    else
        echo "$old_path"
    fi
}
SOLIS_WS_INSTALL_ROOT="$(resolve_path "${BASH_SOURCE[0]}")"

# Setup paths for this workspace
PATH=$(add_to_path "$SOLIS_WS_INSTALL_ROOT/bin" "$PATH")
PYTHONPATH=$(add_to_path "$SOLIS_WS_INSTALL_ROOT/lib/python3/dist-packages" "$PYTHONPATH")
LD_LIBRARY_PATH=$(add_to_path "$SOLIS_WS_INSTALL_ROOT/lib" "$LD_LIBRARY_PATH")
