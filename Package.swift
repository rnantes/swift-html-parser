// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "swift-html-parser",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftHTMLParser",
            targets: ["SwiftHTMLParser"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftHTMLParser",
            dependencies: []),
        .target(
            name: "TestFiles",
            dependencies: [],
            path: "Tests/TestFiles",
            resources: [.copy("Mock"),.copy("RealWorld")]
        ),
        .testTarget(
            name: "SwiftHTMLParserTests",
            dependencies: ["SwiftHTMLParser", "TestFiles"]),
    ]
)
