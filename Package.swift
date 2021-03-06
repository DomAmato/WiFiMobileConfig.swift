// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WiFiMobileConfig",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "WiFiMobileConfig",
            targets: ["WiFiMobileConfig"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.4.6")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "WiFiMobileConfig",
            dependencies: ["Swifter"]),
        .testTarget(
            name: "WiFiMobileConfigTests",
            dependencies: ["WiFiMobileConfig"]),
    ]
)
