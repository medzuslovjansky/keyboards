.PHONY: all test package-deb package-rpm dependencies unit-test dist check-deps install-build-deps install-runtime-deps

# `override` is needed because the CI passes VERSION= (empty) on
# pull_request events, and command-line assignments normally win
# over `:=` — without override, the default never kicks in.
override VERSION := $(if $(strip $(VERSION)),$(VERSION),1.0)
DIST_NAME = isv-keyboard-$(VERSION)

# Package manager detection
PKG_MGR := $(shell (command -v apt-get || command -v dnf) 2>/dev/null)
PKG_TYPE := $(shell if [ -n "$$(command -v apt-get 2>/dev/null)" ]; then echo "deb"; else echo "rpm"; fi)

# Dependencies by type
ifeq ($(PKG_TYPE),deb)
    # GitHub Actions' ubuntu-latest image does not expose `xkbcomp` as
    # an installable apt package, but ships the binary pre-installed.
    # `x11-xkb-utils` is always installable and enough for runtime deps.
    RUNTIME_DEPS := xmlstarlet x11-xkb-utils xkb-data
    # In clean containers, dpkg-checkbuilddeps needs the xkbcomp package
    # explicitly (debian/control's Build-Depends lists it by name).
    BUILD_DEPS := debhelper devscripts gnupg2 xkbcomp $(RUNTIME_DEPS)
else
    RUNTIME_DEPS := xmlstarlet xkbcomp xkeyboard-config
    BUILD_DEPS := rpm-build rpm-sign gnupg2 make $(RUNTIME_DEPS)
endif

all: test

check-deps:
	@if ! command -v xmlstarlet >/dev/null; then \
		echo "Error: xmlstarlet is required but not installed" >&2; \
		exit 1; \
	fi
	@if ! command -v xkbcomp >/dev/null; then \
		echo "Error: xkbcomp is required but not installed" >&2; \
		exit 1; \
	fi

install-runtime-deps:
	@if [ -z "$(PKG_MGR)" ]; then \
		echo "Error: No supported package manager found" >&2; \
		exit 1; \
	fi
	@echo "Installing runtime dependencies..."
	@if [ "$(PKG_TYPE)" = "deb" ]; then \
		apt-get update && apt-get install -y $(RUNTIME_DEPS); \
	else \
		dnf install -y $(RUNTIME_DEPS); \
	fi

install-build-deps:
	@if [ -z "$(PKG_MGR)" ]; then \
		echo "Error: No supported package manager found" >&2; \
		exit 1; \
	fi
	@echo "Installing build dependencies..."
	@if [ "$(PKG_TYPE)" = "deb" ]; then \
		apt-get update && apt-get install -y $(BUILD_DEPS); \
	else \
		dnf install -y $(BUILD_DEPS); \
	fi

# For backward compatibility
dependencies: install-runtime-deps

test: check-deps unit-test
	./tests/test_xkbcomp.sh
	xmlstarlet val src/isv.xml

unit-test: check-deps
	chmod +x tests/test-patch-evdev.sh
	./tests/test-patch-evdev.sh

dist:
	mkdir -p $(DIST_NAME)
	cp -r src tests rpm debian Makefile $(DIST_NAME)/
	tar czf $(DIST_NAME).tar.gz $(DIST_NAME)
	rm -rf $(DIST_NAME)

package-deb: test
	dpkg-buildpackage -us -uc
	mkdir -p packages
	mv ../isv-keyboard_*.deb packages/

package-rpm: test dist
	mkdir -p rpmbuild/SOURCES
	cp $(DIST_NAME).tar.gz rpmbuild/SOURCES/
	rpmbuild -ba \
		--define "_topdir $(CURDIR)/rpmbuild" \
		--define "build_version $(VERSION)" \
		rpm/isv-keyboard.spec
	mkdir -p packages
	cp rpmbuild/RPMS/noarch/*.rpm packages/
