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
               url: "https://github.com/safehousetech/safehouse-bodyguard-swift6-update/releases/download/1.0.0/SHWireGuardKit.framework.zip",
               checksum: "eecff0fef4728b997bfcc561be4ec7c78c8688e2a5a7570cb566706cf845c16c"

           )
       ]
   )
//https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip
