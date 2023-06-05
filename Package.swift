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
		.iOS(.v12)
	],
	products: [
		.library(name: "SHWireGuardKit", targets: ["SHWireGuardKit"])
	],
	targets: [
		.binaryTarget(
			name: "SHWireGuardKit",
			url: "https://api.github.com/repos/safehousetech/SHWireGuard/releases/assets/122590693.zip",
			checksum: "7998cb0081ce065aa0bad43a7f34128e2e9470e2ef87a4f717a3a4f4c4f5a461"
		)
	]
)
