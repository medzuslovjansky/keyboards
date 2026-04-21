#!/bin/bash
set -e

# Colors for better visibility in CI logs
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Log function for consistent output
log() {
    echo -e "${2:-$NC}$1${NC}"
}

# Create a temporary directory for the test compilation
TMPDIR=$(mktemp -d)
log "Created temporary directory: $TMPDIR"

# Ensure cleanup on script exit, even on failure
cleanup() {
    local exit_code=$?
    log "Cleaning up temporary directory..."
    rm -rf "$TMPDIR"
    if [ $exit_code -ne 0 ]; then
        log "Test script failed with exit code: $exit_code" "$RED"
    fi
    exit $exit_code
}
trap cleanup EXIT

# Verify source directory exists
if [ ! -d "./src" ]; then
    log "Error: src directory not found!" "$RED"
    exit 1
fi

compile_variant() {
    local variant="$1"
    local keymap="$TMPDIR/test-$variant.xkb"

    cat > "$keymap" <<EOF
xkb_keymap {
    xkb_keycodes  { include "evdev+aliases(qwerty)" };
    xkb_types     { include "complete" };
    xkb_compat    { include "complete" };
    xkb_symbols   { include "pc+isv($variant)" };
    xkb_geometry  { include "pc(pc105)" };
};
EOF

    log "Testing $variant variant integration..."
    if xkbcomp -I./src -w 0 "$keymap" "$TMPDIR/test-$variant.xkm"; then
        log "Test passed: $variant variant compiles successfully." "$GREEN"
    else
        log "Test failed: $variant variant compilation failed." "$RED"
        exit 1
    fi
}

compile_variant latin
compile_variant cyrillic

log "All XKB syntax tests passed!" "$GREEN"
exit 0
