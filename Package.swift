// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Anchorman",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "Anchorman",
            targets: ["Anchorman"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Anchorman",
            dependencies: [])
    ]
)
