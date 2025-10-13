%define _name xrayhexgenerator
%define _version 1.0.3
%define _release 4
%define debug_package %{nil}

Name: %{_name}
Version: %{_version}
Release: %{_release}
Summary: Simple HEX Generator for Linux
License: MIT
Group: Applications/Utilities
BuildArch: x86_64

Source0: %{_name}-%{_version}.tar.gz
Source1: app.rayadams.xrayhexgenerator.desktop
Source2: app.rayadams.xrayhexgenerator.png

Requires: gtk3, libstdc++

%description
Simple HEX Generator for Linux.

%prep
%setup -q -n bundle

%build
# This section is intentionally left blank as we are packaging a pre-compiled Flutter application.

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/bin
mkdir -p %{buildroot}/usr/share/applications
mkdir -p %{buildroot}/usr/share/icons/hicolor/256x256/apps

# Copy the application binary
install -m 755 %{_name} %{buildroot}/usr/bin/%{_name}

# Copy the desktop file
install -m 644 %{SOURCE1} %{buildroot}/usr/share/applications/%{_name}.desktop

# Copy the application icon
install -m 644 %{SOURCE2} %{buildroot}/usr/share/icons/hicolor/256x256/apps/%{_name}.png

# Copy the lib and data directories
cp -r lib %{buildroot}/usr/bin/
cp -r data %{buildroot}/usr/bin/

%files
/usr/bin/%{_name}
/usr/bin/lib
/usr/bin/data
/usr/share/applications/%{_name}.desktop
/usr/share/icons/hicolor/256x256/apps/%{_name}.png

%changelog
* Sun Oct 12 2025 John Doe <johndoe@example.com> - 1.0.3-4
- Initial RPM release