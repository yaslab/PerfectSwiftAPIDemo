import PackageDescription

let package = Package(
    name: "PerfectSwiftAPIDemo",
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect.git", majorVersion: 0, minor: 38),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", majorVersion: 0, minor: 3)
    ]
)
