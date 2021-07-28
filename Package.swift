// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ValidatableForm",
    platforms: [
        .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(name: "ValidatableForm",
                 targets: ["ValidatableForm"]),
    ],
    targets: [
        .target(name: "ValidatableForm",
                path: "Sources")
    ]
)
