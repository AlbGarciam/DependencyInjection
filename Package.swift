// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "DependencyInjection",
    platforms: [.iOS("11.0"), .macOS("10.10"), .tvOS("11.0")],
    products: [
        .library(name: "DependencyInjectionStatic", type: .static, targets: ["DependencyInjection"]),
        .library(name: "DependencyInjection", type: .dynamic, targets: ["DependencyInjection"]),
    ],
    targets: [
        .target(name: "DependencyInjection", path: "Sources"),
        .testTarget(name: "DependencyInjectionPackageTests", dependencies: ["DependencyInjection"], path: "Tests")
    ]
)
