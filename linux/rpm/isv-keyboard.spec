Name:           isv-keyboard
Version:        1.0
Release:        1%{?dist}
Summary:        Interslavic keyboard layout for Linux

License:        MIT
URL:            https://github.com/medzuslovjansky/keyboards
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
# Different distributions package xmlstarlet differently
%if 0%{?fedora} || 0%{?rhel}
Requires:       xkeyboard-config, xml, xkbcomp
BuildRequires:  xkeyboard-config
%else
Requires:       xkeyboard-config, xmlstarlet, xkbcomp
BuildRequires:  xkeyboard-config
%endif

%description
This package provides the Interslavic keyboard layout (Latin and Cyrillic)
for Linux systems. The layout file is installed into
/usr/share/X11/xkb/symbols/ for integration with the system xkeyboard configuration.

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}/usr/share/X11/xkb/symbols
install -m 644 src/isv %{buildroot}/usr/share/X11/xkb/symbols/isv
mkdir -p %{buildroot}/usr/share/X11/xkb/rules
install -m 644 src/isv.xml %{buildroot}/usr/share/X11/xkb/rules/isv.xml
install -m 755 src/patch-evdev.sh %{buildroot}/usr/share/X11/xkb/rules/patch-evdev.sh

%files
/usr/share/X11/xkb/symbols/isv
/usr/share/X11/xkb/rules/isv.xml
/usr/share/X11/xkb/rules/patch-evdev.sh

%post
# Check for xmlstarlet command under different possible names
if command -v xmlstarlet >/dev/null 2>&1; then
    XML_CMD=xmlstarlet
elif command -v xml >/dev/null 2>&1; then
    XML_CMD=xml
else
    echo "Warning: XML processing tool not found. Layout may not be properly configured."
    exit 0
fi
/usr/share/X11/xkb/rules/patch-evdev.sh add

%preun
if [ $1 = 0 ]; then
    # Check for xmlstarlet command under different possible names
    if command -v xmlstarlet >/dev/null 2>&1; then
        XML_CMD=xmlstarlet
    elif command -v xml >/dev/null 2>&1; then
        XML_CMD=xml
    else
        echo "Warning: XML processing tool not found. Layout may not be properly removed."
        exit 0
    fi
    /usr/share/X11/xkb/rules/patch-evdev.sh remove
fi

%changelog
* Wed Feb 13 2025 Interslavic OSS <oss@interslavic.fun> - 1.0-1
- Initial release.
