// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "GenerativeAIUIComponents",

    platforms: [
        .iOS(.v26)
    ],

    products: [
        .library(
            name: "GenerativeAIUIComponents",
            targets: ["GenerativeAIUIComponents"]
        ),
        .library(
            name: "GenerativeAICore",
            targets: ["GenerativeAICore"]
        ),
        .executable(
            name: "DemoApp",
            targets: ["DemoApp"]
        )
    ],

    dependencies: [
        // Google Gemini (Swift SDK)
        .package(
            url: "https://github.com/google-gemini/generative-ai-swift.git",
            from: "0.5.6"
        ),
        // Optional: Lottie for delightful AI “thinking” animations
        .package(
            url: "https://github.com/airbnb/lottie-ios.git",
            from: "4.5.0"
        )
    ],

    targets: [
        // Thin wrapper around the SDK (handles auth, chat/session, logging)
        .target(
            name: "GenerativeAICore",
            dependencies: [
                .product(name: "GoogleGenerativeAI", package: "generative-ai-swift")
            ],
            path: "Sources/Core"
        ),

        // SwiftUI views, modifiers & previews
        .target(
            name: "GenerativeAIUIComponents",
            dependencies: [
                "GenerativeAICore",
                .product(name: "Lottie", package: "lottie-ios")
            ],
            resources: [.process("Resources")],
            path: "Sources/UIComponents"
        ),

        // Tiny iOS demo you can run in the simulator
        .executableTarget(
            name: "DemoApp",
            dependencies: [
                "GenerativeAIUIComponents"
            ],
            path: "DemoApp"
        ),

        // Unit tests
        .testTarget(
            name: "GenerativeAIUITests",
            dependencies: ["GenerativeAIUIComponents"],
            path: "Tests"
        )
    ]
)
