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

log "Testing raw symbols file syntax..."
if OUTPUT=$(xkbcomp -o /dev/null -I./src -xkb -a -synch './src/isv(latin)' 2>&1); then
    log "Test passed: Raw symbols file syntax is valid." "$GREEN"
else
    log "Test failed: Raw symbols file syntax check failed:" "$RED"
    log "$OUTPUT" "$RED"
    exit 1
fi

log "Testing Latin variant integration..."
cat > "$TMPDIR/test-latin.xkb" << 'EOF'
xkb_keymap {
    xkb_keycodes  { include "evdev+aliases(qwerty)" };
    xkb_types     { include "complete" };
    xkb_compat    { include "complete" };
    xkb_symbols   { include "pc+isv(latin)" };
    xkb_geometry  { include "pc(pc105)" };
};
EOF

if OUTPUT=$(xkbcomp -I./src -w 0 "$TMPDIR/test-latin.xkb" "$TMPDIR/test-latin.xkm" 2>&1); then
    log "Test passed: Latin variant compiles successfully." "$GREEN"
else
    log "Test failed: Latin variant compilation failed:" "$RED"
    log "$OUTPUT" "$RED"
    exit 1
fi

log "Testing Cyrillic variant integration..."
cat > "$TMPDIR/test-cyrillic.xkb" << 'EOF'
xkb_keymap {
    xkb_keycodes  { include "evdev+aliases(qwerty)" };
    xkb_types     { include "complete" };
    xkb_compat    { include "complete" };
    xkb_symbols   { include "pc+isv(cyrillic)" };
    xkb_geometry  { include "pc(pc105)" };
};
EOF

if OUTPUT=$(xkbcomp -I./src -w 0 "$TMPDIR/test-cyrillic.xkb" "$TMPDIR/test-cyrillic.xkm" 2>&1); then
    log "Test passed: Cyrillic variant compiles successfully." "$GREEN"
else
    log "Test failed: Cyrillic variant compilation failed:" "$RED"
    log "$OUTPUT" "$RED"
    exit 1
fi

log "All XKB syntax tests passed!" "$GREEN"
exit 0
