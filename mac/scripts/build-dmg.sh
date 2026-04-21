#!/usr/bin/env bash
#
# Pack a built .bundle into a distributable .dmg installer.
# The DMG contains the bundle plus a symlink to ~/Library/Keyboard Layouts/
# so the user drags the bundle onto the symlink to install.
#
# Usage: build-dmg.sh [--version X.Y.Z] [--out DIR]

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MAC_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

: "${VERSION:=1.0}"
: "${OUT_DIR:=build}"
: "${BUNDLE_FOLDER:=Interslavic (ABC).bundle}"
: "${DMG_NAME:=interslavic-abc}"
: "${DMG_VOLUME_NAME:=Interslavic (ABC)}"

while [ $# -gt 0 ]; do
    case "$1" in
        --out) OUT_DIR="$2"; shift 2 ;;
        --version) VERSION="$2"; shift 2 ;;
        *) echo "Unknown argument: $1" >&2; exit 2 ;;
    esac
done

cd "$MAC_DIR"

BUNDLE_PATH="${OUT_DIR}/${BUNDLE_FOLDER}"
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "Error: bundle not found at $BUNDLE_PATH — run build-bundle.sh first" >&2
    exit 1
fi

STAGE_DIR="$(mktemp -d -t isv-dmg-stage-XXXXXX)"
trap 'rm -rf "$STAGE_DIR"' EXIT

cp -R "$BUNDLE_PATH" "$STAGE_DIR/"
ln -s "/Library/Keyboard Layouts" "$STAGE_DIR/Keyboard Layouts"
cat > "$STAGE_DIR/README.txt" <<EOF
Interslavic (ABC) keyboard layout for macOS — v${VERSION}

Install (current user):
  Drag "${BUNDLE_FOLDER}" to ~/Library/Keyboard Layouts/

Install (all users):
  Drag "${BUNDLE_FOLDER}" to the "Keyboard Layouts" shortcut in this window
  (writes to /Library/Keyboard Layouts/ — requires admin).

Then log out and back in, and add the layout via:
  System Settings > Keyboard > Text Input > Input Sources > + > Other
EOF

mkdir -p packages
DMG_PATH="packages/${DMG_NAME}-${VERSION}.dmg"
rm -f "$DMG_PATH"

echo "==> Creating $DMG_PATH"
hdiutil create \
    -volname "${DMG_VOLUME_NAME}" \
    -srcfolder "$STAGE_DIR" \
    -ov \
    -format UDZO \
    -fs HFS+ \
    "$DMG_PATH" >/dev/null

echo "==> DMG ready: ${DMG_PATH} ($(du -h "$DMG_PATH" | cut -f1))"
