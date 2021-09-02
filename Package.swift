// swift-tools-version:5.4
import PackageDescription

let package = Package(
    name: "DependencyInjection",
    products: [
        .library(name: "DependencyInjection", targets: ["DependencyInjection"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "DependencyInjection", path: "Sources"),
        .testTarget(name: "DependencyInjectionTests", dependencies: ["DependencyInjection"], path: "Tests")
    ]
)
