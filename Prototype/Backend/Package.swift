import PackageDescription

let package = Package(
    name: "Backend",
    targets: [Target(name: "Backend", dependencies: [])],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0),
//        .Package(url: "https://github.com/qutheory/Fluent.git", majorVersion: 0),
        .Package(url: "https://github.com/qutheory/fluent-postgresql.git", majorVersion: 0),
        .Package(url: "https://github.com/qutheory/fluent-sqlite.git", majorVersion: 0),
    ]
)
