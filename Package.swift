// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SwiftBot",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "swiftbot", targets: ["SwiftBot"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git",
                 from: "1.6.1"),             // latest stable July 2025 :contentReference[oaicite:0]{index=0}
        // === Choose exactly ONE of the Google SDK options ===
        // Option A (legacy, still works):
        .package(url: "https://github.com/google-gemini/deprecated-generative-ai-swift.git",
                 from: "0.5.6"),             // marked deprecated  but simple :contentReference[oaicite:1]{index=1}
        // Option B (new unified SDK ‑ requires Firebase Gen AI):
        // .package(url: "https://github.com/giovanninibarbosa/generative-ai-sdk-swift.git",
        //          from: "0.2.0")            // early 2025 community port :contentReference[oaicite:2]{index=2}
    ],
    targets: [
        .executableTarget(
            name: "SwiftBot",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "GoogleGenerativeAI", package: "deprecated-generative-ai-swift") // or generative‑ai‑sdk‑swift
            ],
            path: "Sources/SwiftBot"
        )
    ]
)
