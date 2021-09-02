// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "DependencyInjection",
    products: [
        .library(name: "DependencyInjectionStatic", type: .static, targets: ["DependencyInjection"]),
        .library(name: "DependencyInjection", type: .dynamic, targets: ["DependencyInjection"]),
    ],
    targets: [
        .target(name: "DependencyInjection", path: "Sources"),
        .testTarget(name: "DependencyInjectionTests", dependencies: ["DependencyInjection"], path: "Tests")
    ]
)
