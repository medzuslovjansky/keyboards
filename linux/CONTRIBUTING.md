# Contributing to Linux Keyboard Layout

This guide provides specific instructions for contributing to the Linux keyboard layout implementation.

## Development Environment Setup

### Prerequisites

- **Build Dependencies:**
  - `xmlstarlet` or `xml-utils` (for XML processing)
  - `xkbcomp` (for keyboard layout compilation)
  - `make` (for build automation)
  - `dpkg-dev` (for Debian packaging)
  - `rpm-build` (for RPM packaging)

### Setting Up Your Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/medzuslovjansky/keyboards.git
   cd keyboards
   ```

2. Install dependencies:
   - For Debian/Ubuntu:
     ```bash
     sudo apt-get update
     sudo apt-get install xmlstarlet xkbcomp make dpkg-dev
     ```
   - For Fedora/RHEL:
     ```bash
     sudo dnf install xml-common xkbcomp make rpm-build
     ```

3. Run tests:
   ```bash
   cd linux
   make test
   ```

## Development Workflow

1. **Making Layout Changes**
   - Edit `src/isv` for keyboard mapping changes
   - Edit `src/isv.xml` for layout metadata
   - Run `make test` to verify syntax

2. **Testing Your Changes**
   - The `test_xkbcomp.sh` script verifies layout syntax
   - Run integration tests with `make test`
   - Test package building with `make package-deb` or `make package-rpm`

3. **Building Packages**
   - For Debian: `make package-deb`
   - For RPM: `make package-rpm`
   - Packages will be created in the parent directory

4. **Manual Testing**
   - Install the generated package
   - Verify layout appears in system settings
   - Test all key combinations
   - Verify uninstallation works correctly

## Code Style Guidelines

### Shell Scripts
- Use `#!/bin/bash` shebang
- Enable error checking with `set -e`
- Use meaningful variable names in UPPER_CASE for globals
- Add error handling and cleanup using `trap`
- Include helpful debug messages

### XML Files
- Use 2-space indentation
- Include XML declaration
- Follow XKB layout conventions

### Makefiles
- Use `.PHONY` for non-file targets
- Document complex targets with comments
- Keep dependencies minimal and explicit

## Testing Guidelines

1. **Unit Tests:**
   - Add tests for new features
   - Update tests for modified functionality
   - Ensure proper cleanup in test scripts

2. **Integration Tests:**
   - Test installation and uninstallation
   - Verify XML modifications
   - Check system integration

3. **Manual Testing:**
   - Test keyboard layout functionality
   - Verify across different distributions
   - Check for X11 compatibility

## Troubleshooting

### Common Issues

1. **XKB Compilation Errors**
   - Check syntax in `src/isv`
   - Verify XKB symbol names are valid
   - Run `xkbcomp` manually for detailed errors

2. **Package Building Issues**
   - Ensure all dependencies are installed
   - Check version numbers in changelog
   - Verify file permissions

3. **Integration Issues**
   - Check system logs for errors
   - Verify XML patch application
   - Test with clean system configuration

## Directory Structure

```
linux/
├── src/            # Source files
│   ├── isv         # Main keyboard layout
│   ├── isv.xml     # Layout manifest
│   └── patch-evdev.sh  # System integration
├── debian/         # Debian packaging
├── rpm/            # RPM packaging
├── tests/          # Test scripts
└── Makefile        # Build automation
```
