// swift-tools-version:5.6
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
		.iOS(.v13)
	],
	products: [
		.library(name: "SHWireGuardKit", targets: ["SHWireGuardKit"])
	],
	targets: [
		.binaryTarget(
			name: "SHWireGuardKit",
			url:"https://github.com/safehousetech/SHWireGuard/releases/download/1.0.0/SHWireGuardKit.xcframework.zip",
			checksum: "049cbce11ae7062c4f1ac396a7a98a2a7ad9a175a680bb743c04f4a0c5a5a8ea"
		)
	]
)
