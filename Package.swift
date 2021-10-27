// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Convenience",
    platforms: [
        .iOS(.v11), .macOS(.v10_11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Convenience",
            targets: ["Convenience"]),
        .library(
            name: "ConvenienceUI",
            targets: ["ConvenienceUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: "1.9.0"),
        .package(url: "https://github.com/jdg/MBProgressHUD", from: "1.2.0"),
        .package(name: "FontAwesome", url: "https://github.com/thii/FontAwesome.swift", from: "1.9.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Convenience",
            dependencies: ["SwiftyBeaver"]),
        .target(
            name: "ConvenienceUI",
            dependencies: [
                "Convenience",
                .productItem(name: "FontAwesome", package: "FontAwesome", condition: .when(platforms: [.iOS])),
                .productItem(name: "MBProgressHUD", package: "MBProgressHUD", condition: .when(platforms: [.iOS]))
            ],
            resources: [
                .process("About/SoftwareUsageViewController.xib"),
                .process("About/VersionViewController.xib")
            ]),
        .testTarget(
            name: "ConvenienceTests",
            dependencies: ["Convenience"]),
    ]
)
