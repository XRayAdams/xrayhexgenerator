#!/bin/bash

# Exit on error
set -e

# App details from pubspec.yaml
APP_NAME=$(grep 'name:' pubspec.yaml | awk '{print $2}')
APP_VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
APP_BUILD=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d'+' -f2)

# RPM build setup
RPM_BUILD_ROOT="$(pwd)/rpmbuild"

# Clean up previous builds
flutter clean
rm -rf "$RPM_BUILD_ROOT"

# Build the Flutter app
flutter build linux --release

# Create RPM build directories
mkdir -p "$RPM_BUILD_ROOT/BUILD"
mkdir -p "$RPM_BUILD_ROOT/RPMS"
mkdir -p "$RPM_BUILD_ROOT/SOURCES"
mkdir -p "$RPM_BUILD_ROOT/SPECS"
mkdir -p "$RPM_BUILD_ROOT/SRPMS"

# Copy the spec file
cp xrayhexgenerator.spec "$RPM_BUILD_ROOT/SPECS/"

# Copy desktop and icon files
sed 's/Icon=app.rayadams.xrayhexgenerator/Icon=xrayhexgenerator/' debian/gui/app.rayadams.xrayhexgenerator.desktop > "$RPM_BUILD_ROOT/SOURCES/app.rayadams.xrayhexgenerator.desktop"
cp debian/gui/app.rayadams.xrayhexgenerator.png "$RPM_BUILD_ROOT/SOURCES/"

# Package the application files into a tarball
pushd build/linux/x64/release
tar -czvf "$RPM_BUILD_ROOT/SOURCES/$APP_NAME-$APP_VERSION.tar.gz" bundle
popd

# Update version
sed -i "s/^\(\s*%define _version \s*\).*\$/\1$APP_VERSION/" "xrayhexgenerator.spec"
sed -i "s/^\(\s*%define _release \s*\).*\$/\1$APP_BUILD/" "xrayhexgenerator.spec"

# Build the RPM
rpmbuild -bb \
    --define "_topdir $RPM_BUILD_ROOT" \
    --define "_name $APP_NAME" \
    --define "_version $APP_VERSION" \
    --define "_release $APP_BUILD" \
    "$RPM_BUILD_ROOT/SPECS/xrayhexgenerator.spec"

# Move the RPM to the dist directory
mkdir -p dist
find "$RPM_BUILD_ROOT/RPMS" -name "*.rpm" -exec mv {} dist/ \;

# Clean up
rm -rf "$RPM_BUILD_ROOT"

echo "RPM package created in dist/"
