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
			url: "https://github.com/safehousetech/SHWireGuardKit/releases/download/1.0.0/SHWireGuardKit.xcframework.zip",
			checksum: "74b6d10b505a4ed03a46d0b23a0a310ffe536076c455cac0146d23d00c07ef2f"
		)
	]
)
