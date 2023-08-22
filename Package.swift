// swift-tools-version:5.8.1
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
			url: "https://api.github.com/repos/safehousetech/SHWireGuard/releases/assets/122611289.zip",
			checksum: "c0ebecc133705c0581d2404b1709b2b9f395f963921fe480aebab9567f1b3bd2"
		)
	]
)
