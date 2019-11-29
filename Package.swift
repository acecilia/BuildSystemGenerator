// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftBuildSystemGenerator",
    platforms: [.macOS(.v10_14)],
    products: [
        .executable(name: "swiftbuildsystemgenerator", targets: ["SwiftBuildSystemGenerator"]),
        .library(name: "SwiftBuildSystemGeneratorKit", targets: ["SwiftBuildSystemGeneratorKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/stencilproject/Stencil.git",
            .revision("a229b59d3d888cd6bed2d372bdce627d71ea5e66") // Latest on master at the time of writing
        ),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMajor(from: "1.0.0-alpha.3")),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "5.3.3")),
        // The version of xcodeproj is tight with the one used by XcodeGen
        .package(url: "https://github.com/tuist/xcodeproj.git", .exact("7.1.0")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .upToNextMajor(from: "2.10.1")),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .upToNextMajor(from: "0.2.3")),
        .package(
            url: "https://github.com/acecilia/Version.git",
            .revision("d367727b03253687ff911f3fa90b62b3dca475aa") // Latest on master at the time of writing
            // Using a fork until https://github.com/mxcl/Version/pull/9 is merged and released
        ),
        .package(
            url: "https://github.com/acecilia/Carthage.git",
            .revision("68316f0019dfe0fbd7ade19f02fef792d9c7cddd") // Latest on master at the time of writing
            // Using a fork until https://github.com/Carthage/Carthage/pull/2910 is merged and released
        ),
    ],
    targets: [
        .target(
            name: "SwiftBuildSystemGenerator",
            dependencies: ["SwiftBuildSystemGeneratorCLI"]
        ),
        .target(
            name: "SwiftBuildSystemGeneratorCLI",
            dependencies: [
                "SwiftBuildSystemGeneratorKit",
                "SwiftCLI",
            ]
        ),
        .target(
            name: "SwiftBuildSystemGeneratorKit",
            dependencies: [
                "Stencil",
                "Yams",
                "Path",
                "XcodeProj",
                "XcodeGenKit",
                "AnyCodable",
                "Version",
                "CarthageKit",
                "XCDBLD",
            ]
        ),
        .testTarget(
            name: "SwiftBuildSystemGeneratorTests",
            dependencies: [
                "SwiftBuildSystemGeneratorCLI",
            ]
        )
    ]
)
