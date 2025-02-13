#!/bin/bash
set -euo pipefail

# Initialize DEBUG with default value
: "${DEBUG:=false}"

# Test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(mktemp -d)"
PATCH_SCRIPT="${SCRIPT_DIR}/../src/patch-evdev.sh"
XML_CMD="xmlstarlet"

# Cleanup function
cleanup() {
    rm -rf "$TEST_DIR"
}
trap cleanup EXIT

# Test helper functions
setup_test_env() {
    # Create test directory structure
    mkdir -p "$TEST_DIR/usr/share/X11/xkb/rules"

    # Create a minimal mock evdev.xml
    cat > "$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<xkbConfigRegistry version="1.1">
  <layoutList>
    <layout>
      <configItem>
        <name>us</name>
        <shortDescription>en</shortDescription>
        <description>English (US)</description>
        <languageList><iso639Id>eng</iso639Id></languageList>
      </configItem>
    </layout>
  </layoutList>
</xkbConfigRegistry>
EOF
    chmod 644 "$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml"

    cp "${SCRIPT_DIR}/../debian/isv.xml" "$TEST_DIR/usr/share/X11/xkb/rules/" || {
        echo "Error: Could not find isv.xml template" >&2
        exit 1
    }
    chmod 644 "$TEST_DIR/usr/share/X11/xkb/rules/isv.xml"
}

run_test() {
    local test_name="$1"
    local test_fn="$2"
    echo "Running test: $test_name..."
    if $test_fn 2>&1; then
        echo "✅ Test passed: $test_name"
        return 0
    else
        if [ "$DEBUG" != "true" ]; then
            echo "❌ Test failed: $test_name"
            echo "Re-running with debug output..."
            DEBUG=true $test_fn 2>&1 || true
        fi
        return 1
    fi
}

# Test cases
test_fresh_installation() {
    setup_test_env

    # Run installation
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
    "$PATCH_SCRIPT" add

    # Verify installation
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    "$PATCH_SCRIPT" verify
}

test_update_existing() {
    setup_test_env

    # First installation
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
    "$PATCH_SCRIPT" add

    # Second installation (update)
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
    "$PATCH_SCRIPT" add

    # Verify installation
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    "$PATCH_SCRIPT" verify
}

test_remove_layout() {
    setup_test_env

    # Install first
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
    "$PATCH_SCRIPT" add

    # Remove
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    "$PATCH_SCRIPT" remove

    # Verify removal
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    "$PATCH_SCRIPT" verify-removed
}

test_malformed_xml() {
    setup_test_env

    # Corrupt evdev.xml
    echo "<?xml version='1.0'?><invalid>" > "$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml"

    # Attempt installation (should fail)
    if EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
       ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
       "$PATCH_SCRIPT" add 2>/dev/null; then
        return 1  # Should have failed
    fi
    return 0
}

test_missing_files() {
    setup_test_env

    # Remove evdev.xml
    rm "$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml"

    # Attempt installation (should fail)
    if EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
       ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
       "$PATCH_SCRIPT" add 2>/dev/null; then
        return 1  # Should have failed
    fi
    return 0
}

test_permission_issues() {
    setup_test_env

    # Make evdev.xml read-only
    chmod 444 "$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml"

    # Attempt installation (should fail)
    if EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
       ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
       "$PATCH_SCRIPT" add 2>/dev/null; then
        return 1  # Should have failed
    fi
    return 0
}

test_xml_structure() {
    setup_test_env

    # Install the layout
    EVDEV_XML="$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" \
    ISV_XML="$TEST_DIR/usr/share/X11/xkb/rules/isv.xml" \
    "$PATCH_SCRIPT" add 2>&1

    # Create temporary files for normalized XML
    local normalized_actual="$TEST_DIR/normalized_actual.xml"
    local normalized_expected="$TEST_DIR/normalized_expected.xml"
    local fixture_xml="$SCRIPT_DIR/fixtures/expected-evdev.xml"

    # Normalize both XMLs (remove whitespace differences)
    "$XML_CMD" c14n "$TEST_DIR/usr/share/X11/xkb/rules/evdev.xml" > "$normalized_actual"
    "$XML_CMD" c14n "$fixture_xml" > "$normalized_expected"

    if [ "$DEBUG" = "true" ]; then
        echo "=== Debug: Comparing against fixture ==="
        diff -u "$normalized_expected" "$normalized_actual" || true
        echo "=== End Debug ==="
    fi

    # Compare normalized XMLs
    diff -q "$normalized_expected" "$normalized_actual" || {
        echo "XML structure does not match expected fixture"
        return 1
    }

    return 0
}

# Run all tests
failed_tests=0

run_test "Fresh Installation" test_fresh_installation || ((failed_tests++))
run_test "Update Existing Layout" test_update_existing || ((failed_tests++))
run_test "Remove Layout" test_remove_layout || ((failed_tests++))
run_test "Handle Malformed XML" test_malformed_xml || ((failed_tests++))
run_test "Handle Missing Files" test_missing_files || ((failed_tests++))
run_test "Handle Permission Issues" test_permission_issues || ((failed_tests++))
run_test "XML Structure Verification" test_xml_structure || ((failed_tests++))

# Report results
echo
echo "Test Summary:"
echo "============"
echo "Total tests: 7"
echo "Failed tests: $failed_tests"

exit $((failed_tests > 0))
