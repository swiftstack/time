// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Time",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "Time",
            targets: ["Time"]),
    ],
    dependencies: [
        .package(name: "Platform"),
        .package(name: "Test"),
    ],
    targets: [
        .target(
            name: "Time",
            dependencies: ["Platform"]),
        .executableTarget(
            name: "Tests/Time",
            dependencies: ["Test", "Time"],
            path: "Tests/Time"),
    ]
)

#if os(Linux)
package.targets.append(.target(name: "CTime"))
package.targets[0].dependencies.append("CTime")
#endif

// MARK: - custom package source

#if canImport(ObjectiveC)
import Darwin.C
#else
import Glibc
#endif

extension Package.Dependency {
    enum Source: String {
        case local, remote, github

        static var `default`: Self { .github }

        var baseUrl: String {
            switch self {
            case .local: return "../"
            case .remote: return "https://swiftstack.io/"
            case .github: return "https://github.com/swiftstack/"
            }
        }

        func url(for name: String) -> String {
            return self == .local
                ? baseUrl + name.lowercased()
                : baseUrl + name.lowercased() + ".git"
        }
    }

    static func package(name: String) -> Package.Dependency {
        guard let pointer = getenv("SWIFTSTACK") else {
            return .package(name: name, source: .default)
        }
        guard let source = Source(rawValue: String(cString: pointer)) else {
            fatalError("Invalid source. Use local, remote or github")
        }
        return .package(name: name, source: source)
    }

    static func package(name: String, source: Source) -> Package.Dependency {
        return source == .local
            ? .package(name: name, path: source.url(for: name))
            : .package(name: name, url: source.url(for: name), .branch("dev"))
    }
}
