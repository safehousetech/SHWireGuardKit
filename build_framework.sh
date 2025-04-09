#!/bin/bash

set -euo pipefail

KIT="SHWireGuardKit"
FRAMEWORK_NAME="${KIT}.framework"
XCFRAMEWORK_NAME="${KIT}.xcframework"
ZIP_NAME="${XCFRAMEWORK_NAME}.zip"
BUILD_DIR="$PWD/build"

echo "🧹 Cleaning previous builds..."
rm -rf "$BUILD_DIR" ./*.xcframework ./*.xcframework.zip

# 🏗️ Build function
build_framework() {
  local scheme=$1
  local sdk=$2
  local archs=$3

  echo "📦 Building $scheme for $sdk..."

  xcodebuild archive \
    -scheme "$scheme" \
    -sdk "$sdk" \
    -archivePath "$BUILD_DIR/$scheme-$sdk.xcarchive" \
    -configuration Release \
    -destination "generic/platform=${sdk}" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    ARCHS="$archs" \
    clean archive
}

# 🔨 Build all platforms
build_framework "${KIT}iOS" iphoneos "arm64"
build_framework "${KIT}iOS" iphonesimulator "arm64 x86_64"
build_framework "${KIT}macOS" macosx "arm64 x86_64"

# 🧰 Assemble frameworks for xcframework
echo "📦 Creating XCFramework..."

xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/${KIT}iOS-iphoneos.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -framework "$BUILD_DIR/${KIT}iOS-iphonesimulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -framework "$BUILD_DIR/${KIT}macOS-macosx.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME" \
  -output "$XCFRAMEWORK_NAME"

# 📁 Zip for SwiftPM
echo "📦 Packaging as .zip for SwiftPM..."
ditto -c -k --sequesterRsrc --keepParent "$XCFRAMEWORK_NAME" "$ZIP_NAME"

# 🔐 Checksum
echo "🔐 SwiftPM Checksum:"
swift package compute-checksum "$ZIP_NAME"

echo "✅ All done!"
open -R "$ZIP_NAME"
