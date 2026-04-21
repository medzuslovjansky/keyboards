.PHONY: all test bundle package-dmg dist clean check-deps

# `override` is needed because the CI passes VERSION= (empty) on
# pull_request events, and command-line assignments normally win
# over `:=` — without override, the default never kicks in.
override VERSION := $(if $(strip $(VERSION)),$(VERSION),1.0)
DIST_NAME = isv-keyboard-mac-$(VERSION)

OUT_DIR ?= build
BUNDLE_FOLDER ?= Interslavic (ABC).bundle
LAYOUT_NAME ?= Interslavic (ABC)

SRC_KEYLAYOUT = src/$(LAYOUT_NAME).keylayout
BUNDLE_PATH = $(OUT_DIR)/$(BUNDLE_FOLDER)

all: test

check-deps:
	@if ! command -v hdiutil >/dev/null; then \
		echo "Error: hdiutil is required (macOS only)" >&2; \
		exit 1; \
	fi
	@if ! command -v plutil >/dev/null; then \
		echo "Error: plutil is required (macOS only)" >&2; \
		exit 1; \
	fi

test: check-deps
	@test -f "$(SRC_KEYLAYOUT)" || { echo "Missing $(SRC_KEYLAYOUT)" >&2; exit 1; }
	@head -1 "$(SRC_KEYLAYOUT)" | grep -q '<?xml' || { echo "Not an XML file" >&2; exit 1; }
	@grep -q '<keyboard' "$(SRC_KEYLAYOUT)" || { echo "Missing <keyboard> root" >&2; exit 1; }
	@grep -q 'name="$(LAYOUT_NAME)"' "$(SRC_KEYLAYOUT)" || { echo "Keyboard name mismatch: expected $(LAYOUT_NAME)" >&2; exit 1; }
	@echo "OK: keylayout present, templates ready"

bundle: test
	VERSION=$(VERSION) OUT_DIR=$(OUT_DIR) ./scripts/build-bundle.sh

package-dmg: bundle
	VERSION=$(VERSION) OUT_DIR=$(OUT_DIR) ./scripts/build-dmg.sh

dist:
	mkdir -p $(DIST_NAME)
	cp -R src templates scripts tests Makefile README.md $(DIST_NAME)/ 2>/dev/null || true
	tar czf $(DIST_NAME).tar.gz $(DIST_NAME)
	rm -rf $(DIST_NAME)

clean:
	rm -rf $(OUT_DIR) packages $(DIST_NAME).tar.gz
