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
               checksum: "0d645fe28ae3dba7bdd78d6086392c3ec772f8cbdb82365ad7418de03cfe3b99"

           )
       ]
   )
//https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip
