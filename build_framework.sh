#!/bin/bash
set -e

KIT=SHWireGuardKit

echo "Cleaning old builds..."
rm -rf build ./*.xcframework ./*.xcframework.zip

echo "Building for iOS device..."
xcodebuild -sdk iphoneos -configuration Release -target "${KIT}iOS"

echo "Building for macOS..."
xcodebuild -sdk macosx -configuration Release -target "${KIT}macOS"

ios_fwpath="$PWD/build/Release-iphoneos/${KIT}.framework"
mac_path="$PWD/build/Release/${KIT}.framework"

echo "Checking framework outputs..."
[ -d "$ios_fwpath" ] || { echo "iOS framework not found at $ios_fwpath"; exit 1; }
[ -d "$mac_path" ] || { echo "macOS framework not found at $mac_path"; exit 1; }

echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$ios_fwpath" \
  -framework "$mac_path" \
  -output "${KIT}.xcframework"

echo "Zipping XCFramework..."
ditto -c -k --sequesterRsrc --keepParent "${KIT}.xcframework" "${KIT}.xcframework.zip"

echo "SwiftPM checksum:"
swift package compute-checksum "${KIT}.xcframework.zip"

echo "Done. Opening folder..."
open -R "${KIT}.xcframework.zip"
