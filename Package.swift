// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "XCoordinator",
    platforms: [.iOS(.v12), .tvOS(.v12)],
    products: [
        .library(
            name: "XCoordinator",
            targets: ["XCoordinator"]
		)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "XCoordinator",
            dependencies: []
		),
        .testTarget(
            name: "XCoordinatorTests",
            dependencies: ["XCoordinator"]
		)
    ],
	swiftLanguageModes: [.v5]
)
