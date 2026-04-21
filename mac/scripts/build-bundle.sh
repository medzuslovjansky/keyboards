#!/usr/bin/env bash
#
# Assemble a macOS keyboard layout .bundle from src/*.keylayout + templates.
#
# Usage: build-bundle.sh [--out DIR] [--version X.Y.Z]
#
# Environment overrides (also settable via flags):
#   VERSION              default: 1.0
#   OUT_DIR              default: build
#   BUNDLE_ID            default: org.interslavic.keyboards.abc
#   BUNDLE_NAME          default: interslavic-keyboards-abc
#   BUNDLE_FOLDER        default: "Interslavic (ABC).bundle"
#   LAYOUT_NAME          default: "Interslavic (ABC)"
#   TIS_INPUT_SOURCE_ID  default: org.interslavic.keyboards.abc.latin
#   TIS_INTENDED_LANGUAGE default: sla-Latn

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MAC_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

: "${VERSION:=1.0}"
: "${OUT_DIR:=build}"
: "${BUNDLE_ID:=org.interslavic.keyboards.abc}"
: "${BUNDLE_NAME:=interslavic-keyboards-abc}"
: "${BUNDLE_FOLDER:=Interslavic (ABC).bundle}"
: "${LAYOUT_NAME:=Interslavic (ABC)}"
: "${TIS_INPUT_SOURCE_ID:=org.interslavic.keyboards.abc.latin}"
: "${TIS_INTENDED_LANGUAGE:=sla-Latn}"

while [ $# -gt 0 ]; do
    case "$1" in
        --out) OUT_DIR="$2"; shift 2 ;;
        --version) VERSION="$2"; shift 2 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done

cd "$MAC_DIR"

SRC_KEYLAYOUT="src/${LAYOUT_NAME}.keylayout"
if [ ! -f "$SRC_KEYLAYOUT" ]; then
    echo "Error: source keylayout not found at $SRC_KEYLAYOUT" >&2
    exit 1
fi

BUNDLE_PATH="${OUT_DIR}/${BUNDLE_FOLDER}"
CONTENTS="${BUNDLE_PATH}/Contents"
RESOURCES="${CONTENTS}/Resources"
LPROJ="${RESOURCES}/en.lproj"

echo "==> Building ${BUNDLE_FOLDER} (version ${VERSION})"

rm -rf "$BUNDLE_PATH"
mkdir -p "$RESOURCES" "$LPROJ"

cp "$SRC_KEYLAYOUT" "${RESOURCES}/${LAYOUT_NAME}.keylayout"

render() {
    local template="$1"
    local output="$2"
    sed \
        -e "s|@VERSION@|${VERSION}|g" \
        -e "s|@BUNDLE_ID@|${BUNDLE_ID}|g" \
        -e "s|@BUNDLE_NAME@|${BUNDLE_NAME}|g" \
        -e "s|@LAYOUT_NAME@|${LAYOUT_NAME}|g" \
        -e "s|@TIS_INPUT_SOURCE_ID@|${TIS_INPUT_SOURCE_ID}|g" \
        -e "s|@TIS_INTENDED_LANGUAGE@|${TIS_INTENDED_LANGUAGE}|g" \
        "$template" > "$output"
}

render templates/Info.plist.in       "${CONTENTS}/Info.plist"
render templates/version.plist.in    "${CONTENTS}/version.plist"
render templates/InfoPlist.strings.in "${LPROJ}/InfoPlist.strings"

if command -v plutil >/dev/null 2>&1; then
    plutil -lint "${CONTENTS}/Info.plist" >/dev/null
    plutil -lint "${CONTENTS}/version.plist" >/dev/null
fi

echo "==> Bundle ready: $BUNDLE_PATH"
