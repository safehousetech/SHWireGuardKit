#!/bin/bash
set -e

KIT=SHWireGuardKit

echo "Cleaning old builds..."
rm -rf build ./*.xcframework ./*.xcframework.zip

# Build for iOS device with dSYM generation
echo "Building for iOS device..."
xcodebuild -sdk iphoneos -configuration Release -target "${KIT}iOS" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  DEBUG_INFORMATION_FORMAT=dwarf-with-dsym \
  SKIP_INSTALL=NO \
  ONLY_ACTIVE_ARCH=NO

# Build for macOS with dSYM generation
echo "Building for macOS..."
xcodebuild -sdk macosx -configuration Release -target "${KIT}macOS" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  DEBUG_INFORMATION_FORMAT=dwarf-with-dsym \
  SKIP_INSTALL=NO \
  ONLY_ACTIVE_ARCH=NO

ios_fwpath="$PWD/build/Release-iphoneos/${KIT}.framework"
mac_path="$PWD/build/Release/${KIT}.framework"

echo "Checking framework outputs..."
[ -d "$ios_fwpath" ] || { echo "iOS framework not found at $ios_fwpath"; exit 1; }
[ -d "$mac_path" ] || { echo "macOS framework not found at $mac_path"; exit 1; }

# Create XCFramework (combining iOS and macOS)
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$ios_fwpath" \
  -framework "$mac_path" \
  -output "${KIT}.xcframework"

# Zip the XCFramework
echo "Zipping XCFramework..."
ditto -c -k --sequesterRsrc --keepParent "${KIT}.xcframework" "${KIT}.xcframework.zip"

# Compute SwiftPM checksum
echo "SwiftPM checksum:"
swift package compute-checksum "${KIT}.xcframework.zip"

echo "Done. Opening folder..."
open -R "${KIT}.xcframework.zip"
