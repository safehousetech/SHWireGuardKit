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
               checksum: "c240e30f621077e0fda92b40304dceeb2420774e705440cd4fd993c95449f5d4"

           )
       ]
   )
//https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip
