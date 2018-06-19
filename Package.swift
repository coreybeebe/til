// swift-tools-version:4.0
import PackageDescription

//  MARK: - With PostgreSQL running on local Docker container

let package = Package(
    name: "TodayILearned",
    dependencies: [
    .package(url: "https://github.com/vapor/vapor.git",
    from: "3.0.0"),
    
    .package(
    url: "https://github.com/vapor/fluent-postgresql.git",
    from: "1.0.0-rc"),
    ],
    targets: [

    .target(name: "App", dependencies: ["FluentPostgreSQL",
    "Vapor"]),
    .target(name: "Run", dependencies: ["App"]),
    .testTarget(name: "AppTests", dependencies: ["App"]),
    ]
)


//  MARK: - With in-memory SQLite Database
//let package = Package(name: "TodayILearned", dependencies: [
//
//        // 💧 A server-side Swift web framework.
//        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
//
//        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
//        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0-rc.2")
//    ],
//
//    targets: [
//        .target(name: "App", dependencies: ["FluentSQLite", "Vapor"]),
//        .target(name: "Run", dependencies: ["App"]),
//        .testTarget(name: "AppTests", dependencies: ["App"])
//    ]
//)

