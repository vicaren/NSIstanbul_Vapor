// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "NSIstanbul_Vapor",
    products: [
        .library(name: "NSIstanbul_Vapor", targets: ["App"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.4"),

    ],
    targets: [
        .target(name: "App", dependencies: ["SwiftSoup", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)


