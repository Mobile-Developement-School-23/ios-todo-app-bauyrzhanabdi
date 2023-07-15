// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyLibrary",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyLibrary",
            targets: ["ListKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMinor(from: "5.4.0")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.0"),
        .package(url: "https://github.com/google/promises", .upToNextMinor(from: "2.2.0")),
        .package(url: "https://github.com/Juanpe/SkeletonView", .upToNextMinor(from: "1.30.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ListKit",
            dependencies: [
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                .product(name: "Promises", package: "promises"),
                "Alamofire",
                "SkeletonView",
                "SnapKit",
                "Swinject"
            ],
            path: "Sources/ListKit"
        )
    ]
)
