import PackageDescription

let package = Package(
    name: "Hackathon",
    targets: [
        Target(
            name: "Hackathon",
            dependencies: [
                .Target(name: "HackathonApp")
            ]
        ),
        Target(name: "HackathonApp")
    ],
    dependencies: [
        .Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/WebSocket.git", majorVersion: 0, minor: 3),
        .Package(url: "https://github.com/Zewo/Mustache.git", majorVersion: 0, minor: 2),
    ]
)
