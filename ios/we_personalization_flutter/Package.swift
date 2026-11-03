// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "we_personalization_flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "we-personalization-flutter", targets: ["we_personalization_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/WebEngage/webengage-ios-sdk.git", "1.0.0"..<"3.0.0")
    ],
    targets: [
        .target(
            name: "we_personalization_flutter",
            dependencies: [
                .product(name: "WebEngagePersonalization", package: "webengage-ios-sdk")
            ]
        )
    ]
)
