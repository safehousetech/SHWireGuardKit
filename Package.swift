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
               checksum: "9b62a98d95402dba492c7c7dd81c1314cfb7b3729a39bf6ca5e614136f86c844"

           )
       ]
   )
//https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip
