// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemoteImage",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "RemoteImage",
            targets: ["RemoteImage"]),
    ],
    targets: [
        .target(
            name: "RemoteImage",
            dependencies: []),
        .testTarget(
            name: "RemoteImageTests",
            dependencies: ["RemoteImage"]),
    ]
)
