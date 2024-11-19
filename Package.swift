// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "StudentCourseAPI",
    platforms: [
        .macOS(.v12) // Ensure you specify the correct macOS version
    ],
    products: [
        .executable(name: "Run", targets: ["Run"]) // Define the executable
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "App", // App target contains logic and no entry point
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "Vapor", package: "vapor"),
            ],
            path: "Sources/App" // Path to the App logic
        ),
        .executableTarget(
            name: "Run", // Run target defines the entry point
            dependencies: [
                .target(name: "App")
            ],
            path: "Sources/Run" // Path to the main.swift file
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App")
            ],
            path: "Tests/AppTests"
        ),
    ]
)
