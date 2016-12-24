import PackageDescription

let package = Package(
    name: "PerfectSwiftAPIDemo",
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/PerfectLib.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTP.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/SwiftORM/SQLite-StORM.git", majorVersion: 1, minor: 0)
    ]
)
