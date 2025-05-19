// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AutentiseringApp",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AutentiseringApp", targets: ["AutentiseringApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "2.0.0"),
        .package(url: "https://github.com/SwiftCloudKit/CloudKit.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "AutentiseringApp", dependencies: [
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "Crypto", package: "swift-crypto"),
            .product(name: "CloudKit", package: "CloudKit")
        ]),
        .testTarget(name: "AutentiseringAppTests", dependencies: ["AutentiseringApp"])
    ]
)
