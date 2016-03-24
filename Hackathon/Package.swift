import PackageDescription

let package = Package(
    name: "KituraSample",
    targets: [Target(name: "KituraSample", dependencies: [])],
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura-router.git", majorVersion: 0),
        .Package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git", majorVersion: 0),
        .Package(url: "https://github.com/Zewo/Mustache.git", majorVersion: 0),
    ]
)
