import PackageDescription

let package = Package(
    name: "Backend",
    targets: [Target(name: "Backend", dependencies: [])],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0),
        .Package(url: "https://github.com/qutheory/fluent.git", Version(0,1,0)),
        .Package(url: "https://github.com/qutheory/fluent-sqlite.git", Version(0,1,1)),
    ]
)
