// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MVVMKit",
    platforms: [.iOS(.v11) ],
    products: [
        .library(name: "MVVMKit", targets: ["MVVMKit"])
    ],
    targets: [
        .target(name: "MVVMKit", dependencies: [], path: "MVVMKit")
    ]
)
