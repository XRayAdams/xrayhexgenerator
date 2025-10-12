#!/bin/bash

# Check if flutter_to_debian is installed
if ! command -v flutter_to_debian &> /dev/null
then
    echo "Error: flutter_to_debian is not installed."
    echo "Please install it by running the following command:"
    echo "dart pub global activate flutter_to_debian"
    exit 1
fi

flutter clean
flutter build linux --release

./set_app_versions.sh

flutter_to_debian 
mkdir -p dist
cp -r build/linux/x64/release/debian/* dist/
