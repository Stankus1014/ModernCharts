// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModernCharts",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ModernCharts",
            targets: ["ModernCharts"]
        ),
    ],
    targets: [
        .target(
            name: "ModernCharts"
        ),
    ]
)
