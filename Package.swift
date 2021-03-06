// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIGen",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "swiftuigen", targets: ["SwiftUIGen"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .target(name: "SwiftUIGen", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "SwiftUIGenKit"
        ]),
        .target(name: "SwiftUIGenKit", dependencies: []),
        .testTarget(name: "SwiftUIGenTests", dependencies: ["SwiftUIGen"]),
    ]
)
