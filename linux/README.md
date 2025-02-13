# Interslavic Keyboard Layout for Linux

This project provides a professional, maintainable Interslavic keyboard layout package for Linux. The layout is split into two variants – Latin and Cyrillic – and is designed to be integrated into system xkeyboard configuration.

## Repository Structure

- **src/**: Contains the source XKB layout file (`isv`).
- **debian/**: Contains packaging metadata for Debian-based systems.
- **rpm/**: Contains the RPM spec file for RPM-based distributions.
- **tests/**: Contains basic tests (using `xkbcomp` to check syntax).
- **Makefile**: Provides targets for testing and packaging.
- **README.md**: Project documentation.

## Building and Testing

To run the tests:
```
make test
```

### Debian Package

To build a `.deb` package:
```
make package-deb
```

### RPM Package

To build an `.rpm` package:
```
make package-rpm
```

## Installation

### From Source

1. Copy the layout file to the system directory:
```bash
sudo cp src/isv /usr/share/X11/xkb/symbols/
```

2. Add the layout to your system:
```bash
sudo dpkg-reconfigure xkb-data  # For Debian/Ubuntu
# or
sudo dnf reinstall xkeyboard-config  # For Fedora/RHEL
```

### From Package

#### Debian/Ubuntu
```bash
sudo dpkg -i isv-keyboard_1.0-1_all.deb
```

#### Fedora/RHEL
```bash
sudo rpm -i isv-keyboard-1.0-1.noarch.rpm
```

## Usage

After installation, you can select the Interslavic keyboard layout through your system's keyboard settings:

- **Latin variant**: Select "Interslavic (Latin)"
- **Cyrillic variant**: Select "Interslavic (Cyrillic)"

The layout uses the Right Alt key (AltGr) as a modifier for accessing additional characters. If the Right Alt key (Third Layer) doesn't work correctly, you may need to reassign it using:
```bash
setxkbmap -option lv3:ralt_switch
```

## Contributing

Contributions are welcome! Please submit pull requests or open issues for any improvements or bug fixes.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
