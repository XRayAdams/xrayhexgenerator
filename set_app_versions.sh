#!/bin/bash

# --- Configuration ---
PUBSPEC_FILE="pubspec.yaml"
DEBIAN_YAML_FILE="debian/debian.yaml"
DEBIAN_DESKTOP_FILE="debian/gui/app.rayadams.xrayhexgenerator.desktop"
SNAP_YAML_FILE="snap/snapcraft.yaml"
SNAP_DESKTOP_FILE="snap/gui/xrayhexgenerator.desktop"
# ---------------------


# Check if files exist
if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "Error: File not found: $PUBSPEC_FILE"
    exit 1
fi
if [ ! -f "$DEBIAN_YAML_FILE" ]; then
    echo "Error: File not found: $DEBIAN_YAML_FILE"
    exit 1
fi
if [ ! -f "$DEBIAN_DESKTOP_FILE" ]; then
    echo "Error: File not found: $DEBIAN_DESKTOP_FILE"
    exit 1
fi
if [ ! -f "$SNAP_YAML_FILE" ]; then
    echo "Error: File not found: $SNAP_YAML_FILE"
    exit 1
fi
if [ ! -f "$SNAP_DESKTOP_FILE" ]; then
    echo "Error: File not found: $SNAP_DESKTOP_FILE"
    exit 1
fi

# Read version from pubspec.yaml (extracts the line with 'version:' and gets the value after the space)
APP_VERSION=$(grep 'version:' $PUBSPEC_FILE | cut -d ' ' -f 2)

if [ -z "$APP_VERSION" ]; then
    echo "Error: Could not read version from $PUBSPEC_FILE."
    exit 1
fi

echo "Version '$APP_VERSION' found in $PUBSPEC_FILE"

# Use sed to find and replace the Version line in debian.yaml and desktop file
# This command looks for the line starting with '  Version:' and replaces the entire line.
sed -i "s/^\(\s*Version:\s*\).*\$/\1$APP_VERSION/" "$DEBIAN_YAML_FILE"
sed -i "s/^\(\s*Version=\s*\).*\$/\1$APP_VERSION/" "$DEBIAN_DESKTOP_FILE"

sed -i "s/^\(\s*version:\s*\).*\$/\1$APP_VERSION/" "$SNAP_YAML_FILE"
sed -i "s/^\(\s*Version=\s*\).*\$/\1$APP_VERSION/" "$SNAP_DESKTOP_FILE"

echo "Successfully updated version to $APP_VERSION in all relevant files."
