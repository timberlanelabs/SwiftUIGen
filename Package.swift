// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIGen",
    platforms: [.iOS(.v14), .macOS(.v12)],
    products: [
        .executable(name: "SwiftUIGen", targets: ["SwiftUIGen"]),
        .plugin(name: "SwiftUIGenPlugin", targets: ["SwiftUIGenPlugin"]),
        .plugin(name: "SwiftUIGenPluginCommand", targets: ["SwiftUIGenPluginCommand"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.1"),
    ],
    targets: [
        .executableTarget(name: "SwiftUIGen", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            "SwiftUIGenKit"
        ]),
        .target(name: "SwiftUIGenKit", dependencies: []),
        .plugin(name: "SwiftUIGenPlugin", capability: .buildTool(), dependencies: ["SwiftUIGen"]),
        .plugin(
            name: "SwiftUIGenPluginCommand",
            capability: .command(
                intent: .custom(
                    verb: "SwiftUIGen",
                    description: "Generates SwiftUI Preview supporting code"
                ),
                permissions: [.writeToPackageDirectory(reason: "SwiftUIGen needs write permission to save the generated code")]
            ),
            dependencies: ["SwiftUIGen"]
        ),
        .testTarget(name: "SwiftUIGenTests", dependencies: ["SwiftUIGen"]),
    ]
)
