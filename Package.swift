// swift-tools-version:5.8
//
//  Package.swift
//  SHWireGuardKit
//
//

import PackageDescription

let package = Package(
    name: "SHWireGuardKit",
       platforms: [
           .macOS(.v10_15),
           .iOS(.v12)
       ],
       products: [
           .library(name: "SHWireGuardKit", targets: ["SHWireGuardKit"])
       ],
       targets: [
           .binaryTarget(
               name: "SHWireGuardKit",
               url: "https://github.com/safehousetech/safehouse-bodyguard-swift6-update/releases/download/1.0.0/SHWireGuardKit.xcframework.zip",
               checksum: "7c4a5e6cae25c3f997f38b045570e0ed99609ecdac526623a9007db9fc138a27"

           )
       ]
   )
//https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip
