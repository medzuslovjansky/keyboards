#!/bin/bash
set -euo pipefail

# Configuration
EVDEV_XML="${EVDEV_XML:-/usr/share/X11/xkb/rules/evdev.xml}"
BACKUP_XML="${EVDEV_XML}.isv.backup"  # Make backup name specific to our package
ISV_XML="${ISV_XML:-/usr/share/X11/xkb/rules/isv.xml}"
DEBUG="${DEBUG:-false}"

# Function to print debug messages
debug_msg() {
    if [ "$DEBUG" = "true" ]; then
        echo "=== Debug: $1 ===" >&2
        shift
        "$@" >&2
        echo "=== End Debug ===" >&2
    fi
}

# Function to find GNU grep
find_gnu_grep() {
    local grep_cmd="grep"
    if command -v ggrep &> /dev/null; then
        grep_cmd="ggrep"
    elif ! grep --version | grep -q "GNU grep"; then
        echo "Warning: GNU grep not found, some features may not work correctly" >&2
    fi
    echo "$grep_cmd"
}

# Get GNU grep command
GREP_CMD=$(find_gnu_grep)

# Function to find XML tool and verify version
find_xml_tool() {
    local tool=""
    if command -v xmlstarlet &> /dev/null; then
        # Check xmlstarlet version by trying a simple operation
        if xmlstarlet --version &> /dev/null; then
            tool="xmlstarlet"
        else
            echo "Warning: xmlstarlet not working properly, trying alternative..." >&2
        fi
    fi

    if [ -z "$tool" ] && command -v xml &> /dev/null; then
        tool="xml"
    fi

    if [ -z "$tool" ]; then
        echo "Error: No suitable XML processing tool found (tried: xmlstarlet, xml)" >&2
        echo "Please install xmlstarlet package for your system" >&2
        exit 1
    fi

    echo "$tool"
}

# Get XML tool command
XML_CMD=$(find_xml_tool)

# Function to validate XML file
validate_xml() {
    local xml_file="$1"
    if [ ! -f "$xml_file" ]; then
        echo "Error: XML file not found: $xml_file" >&2
        exit 1
    fi
    if ! "$XML_CMD" val "$xml_file" &> /dev/null; then
        echo "Error: Invalid XML file: $xml_file" >&2
        exit 1
    fi
}

# Function to check if layout already exists
layout_exists() {
    local xml_file="$1"
    "$XML_CMD" sel -t -v "count(//layout[configItem/name='isv'])" "$xml_file" 2>/dev/null | "$GREP_CMD" -q '^[1-9]'
}

# Function to verify layout installation
verify_layout() {
    if ! layout_exists "$EVDEV_XML"; then
        echo "Error: Layout not found in evdev.xml" >&2
        exit 1
    fi
    echo "Layout verified successfully"
}

# Function to verify layout removal
verify_removal() {
    if layout_exists "$EVDEV_XML"; then
        echo "Error: Layout still exists in evdev.xml" >&2
        exit 1
    fi
    echo "Layout removal verified successfully"
}

# Function to create backup
create_backup() {
    if [ ! -f "$BACKUP_XML" ]; then
        cp -p "$EVDEV_XML" "$BACKUP_XML"
        echo "Created backup at $BACKUP_XML"
    fi
}

# Function to restore backup
restore_backup() {
    if [ -f "$BACKUP_XML" ]; then
        if ! cmp -s "$EVDEV_XML" "$BACKUP_XML"; then
            cp -p "$BACKUP_XML" "$EVDEV_XML"
            echo "Restored backup from $BACKUP_XML"
        fi
    fi
}

# Function to add layout
add_layout() {
    # Validate input files
    validate_xml "$EVDEV_XML"
    validate_xml "$ISV_XML"

    # Create backup before modifications
    create_backup

    # Check if layout already exists
    if layout_exists "$EVDEV_XML"; then
        echo "Layout already exists, ensuring it's up to date..."
        remove_layout_xml
    fi

    # Create temporary directory for modifications
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT

    # Create a temporary copy of evdev.xml for modification
    TEMP_EVDEV="$TEMP_DIR/evdev.tmp.xml"
    cp "$EVDEV_XML" "$TEMP_EVDEV"

    # Insert the layout using xmlstarlet
    if ! "$XML_CMD" ed --inplace \
        -a "/xkbConfigRegistry/layoutList/layout[last()]" --type elem -n "layout" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]" --type elem -n "configItem" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/configItem" --type elem -n "name" -v "isv" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/configItem" --type elem -n "shortDescription" -v "isv" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/configItem" --type elem -n "description" -v "Interslavic" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/configItem" --type elem -n "languageList" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/configItem/languageList" --type elem -n "iso639Id" -v "isv" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]" --type elem -n "variantList" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList" --type elem -n "variant" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList/variant" --type elem -n "configItem" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList/variant/configItem" --type elem -n "name" -v "latin" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList/variant/configItem" --type elem -n "description" -v "Interslavic (Latin)" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList" --type elem -n "variant" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList/variant[last()]" --type elem -n "configItem" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList/variant[last()]/configItem" --type elem -n "name" -v "cyrillic" \
        -s "/xkbConfigRegistry/layoutList/layout[last()]/variantList/variant[last()]/configItem" --type elem -n "description" -v "Interslavic (Cyrillic)" \
        "$TEMP_EVDEV"; then
        debug_msg "Failed XML content" cat "$TEMP_EVDEV"
        echo "Error: Failed to insert layout into $EVDEV_XML" >&2
        exit 1
    fi

    # Move the modified file back
    mv "$TEMP_EVDEV" "$EVDEV_XML"

    # Show XML content in debug mode
    debug_msg "XML after modification" cat "$EVDEV_XML"

    # Validate the result
    validate_xml "$EVDEV_XML"
    echo "Layout added successfully"
}

# Function to remove layout XML without backup restoration
remove_layout_xml() {
    if ! "$XML_CMD" ed -L \
        -d "//layout[configItem/name='isv']" \
        "$EVDEV_XML"; then
        echo "Error: Failed to remove layout from $EVDEV_XML" >&2
        exit 1
    fi
}

# Function to remove layout
remove_layout() {
    # Validate XML
    validate_xml "$EVDEV_XML"

    # Check if layout exists
    if ! layout_exists "$EVDEV_XML"; then
        echo "Layout not found, nothing to remove..."
        return 0
    fi

    # Remove the layout
    remove_layout_xml

    # Validate the result
    validate_xml "$EVDEV_XML"

    # Restore backup if it exists and differs
    restore_backup

    echo "Layout removed successfully"
}

# Main script
case "${1:-}" in
    "add")
        add_layout
        ;;
    "remove")
        remove_layout
        ;;
    "verify")
        verify_layout
        ;;
    "verify-removed")
        verify_removal
        ;;
    *)
        echo "Usage: $0 {add|remove|verify|verify-removed}" >&2
        exit 1
        ;;
esac
