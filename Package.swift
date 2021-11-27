// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "StackScrollView",  
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(name: "StackScrollView", targets: ["StackScrollView"]),   
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "StackScrollView", dependencies: [], path: "StackScrollView"),
  ],
  swiftLanguageVersions: [.v5]
)
