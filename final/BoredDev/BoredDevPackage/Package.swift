// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BoredDevPackage",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "DesignerFeature", targets: ["DesignerFeature"]),
        .library(name: "GalleryFeature", targets: ["GalleryFeature"]),
        .library(name: "Models", targets: ["Models"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppFeature",
            dependencies: [
                "DesignerFeature",
                "GalleryFeature",
                "Models"
            ]
        ),
        .target(
            name: "DesignerFeature",
            dependencies: [
                "Models"
            ]
        ),
        .target(
            name: "GalleryFeature",
            dependencies: [
                "DesignerFeature",
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                "Models",
            ]
        ),
        .target(
            name: "Models",
            dependencies: []),
    ]
)
