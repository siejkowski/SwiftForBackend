import PackageDescription

let package = Package(
    name: "hello",
    dependencies: [
        .Package(url: "https://github.com/Zewo/HTTPServer.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/Router.git", majorVersion: 0, minor: 3),
    ]
)
