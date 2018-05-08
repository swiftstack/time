// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "Time",
    products: [
        .library(name: "Time", targets: ["Time"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-stack/platform.git",
            .branch("master")),
        .package(
            url: "https://github.com/swift-stack/test.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "Time",
            dependencies: ["Platform"]),
        .testTarget(
            name: "TimeTests",
            dependencies: ["Test", "Time"])
    ]
)

#if os(Linux)
package.targets.append(.target(name: "CTime"))
package.targets[0].dependencies.append("CTime")
#endif
