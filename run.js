import PackageDescription

let package = Package(
  name: "roda",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    .package(name: "GoogleGenerativeAI", path: "../../"),
  ],
  targets: [
    .executableTarget(
      name: "generate-content",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "GoogleGenerativeAI"// swift-tools-version:5.2
import PackageDescription

let package = Package(
name: "kubu-hai",
dependencies: [
.package(url: "https://github.com/vapor/vapor.git", from: "4.0.5"),
.package(url: "https://github.com/vapor/queues.git", from: "1.0.0")
],
targets: [
.target(name: "App", dependencies: [
.product(name: "Vapor", package: "vapor"),
.product(name: "Queues", package: "queues")
]),
.target(name: "Run", dependencies: ["App"])
]
)
, package: "roda"),
      ],
      path: "Sources"
    ),
  ]
)
