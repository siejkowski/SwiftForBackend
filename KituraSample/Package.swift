import PackageDescription

let package = Package(
        name: "KituraSample",
        targets: [
                Target(
                name: "KituraSample",
                        dependencies: [])
        ],
        dependencies: [
                .Package(url: "https://github.com/IBM-Swift/Kitura-router.git", versions: Version(0,2,0)..<Version(0,3,0)),
                .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", versions: Version(0,2,0)..<Version(0,3,0)),
                .Package(url: "https://github.com/IBM-Swift/LoggerAPI.git", versions: Version(0,2,0)..<Version(0,3,0)),
                .Package(url: "https://github.com/IBM-Swift/Kitura-TestFramework.git", versions: Version(0,2,0)..<Version(0,3,0)),
        ]
)

#if os(OSX)
    package.dependencies.append(.Package(url: "https://github.com/IBM-Swift/GRMustache.swift.git", majorVersion: 1))
#endif