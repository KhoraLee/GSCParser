// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "GSCParser",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "GSCParser",
            targets: ["GSCParser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", .upToNextMajor(from: "0.8.0")),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", .upToNextMajor(from: "2.0.0")),
    ],
    targets: [
        .target(
            name: "GSCParser",
            dependencies: ["Alamofire", "SwiftCSV", "SwiftSoup"]),
        .testTarget(
            name: "GSCParserTests",
            dependencies: ["GSCParser"]),
    ])
