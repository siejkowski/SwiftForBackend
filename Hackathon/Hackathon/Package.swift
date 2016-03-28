import PackageDescription

let package = Package(
    name: "Hackathon",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/Mustache.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/Zewo/WebSocket.git", majorVersion: 0, minor: 3),
    ]
)
