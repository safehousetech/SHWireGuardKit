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
            url: "https://github.com/safehousetech/safehouse-bodyguard-swift6-update/releases/download/1.0.0/Safehouse-bodyguard-swift6-update.zip",
            checksum: "708febe2a5b92147ac8ea791bded67d0db670a4e14d9a567f99ff951bf647155"
        )
    ]
)

//https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip

