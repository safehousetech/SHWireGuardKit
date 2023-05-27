#!/bin/bash
set -e

KIT=SHWireGuardKit
# clear previous build folder if it exist
rm -rf build

# remove the old copy of the xcframework if it already exists
rm -rf ./*.xcframework ./*.xcframework.zip

xcodebuild -sdk iphonesimulator -target "${KIT}iOS"
xcodebuild -sdk iphoneos -target "${KIT}iOS"
xcodebuild -sdk macosx -target "${KIT}macOS"

# create variables for the path to each respective framework
ios_fwpath="$PWD/build/Release-iphoneos/${KIT}.framework"
sim_fwpath="$PWD/build/Release-iphonesimulator/${KIT}.framework"
mac_path="$PWD/build/Release/${KIT}.framework"

# create the xcframework
xcodebuild -create-xcframework -framework "$ios_fwpath" -framework "$sim_fwpath" -framework "$mac_path" -output "${KIT}.xcframework"

printf "\n\n"
printf "Proccesing SwiftPM artifacts\n"

printf "Creating .zip archive...\n"
# create .zip of the framework for SwiftPM
ditto -c -k --sequesterRsrc --keepParent "./${KIT}.xcframework" "${KIT}.xcframework.zip"

printf "\n"
printf "SwiftPM .zip checksum:\n"
# get hash checksum for SwiftPM
swift package compute-checksum "${KIT}.xcframework.zip"

open -R "${KIT}.xcframework.zip"
