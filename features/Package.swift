// swift-tools-version: 6.0

import PackageDescription

let tca = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let str = Target.Dependency.product(name: "XCStringsToolPlugin", package: "xcstrings-tool-plugin")
let ext = Target.Dependency.product(name: "Extensions", package: "extensions")
let comps = Target.Dependency.product(name: "SwiftUIComponents", package: "library")
let types = Target.Dependency.product(name: "Types", package: "library")
let words = Target.Dependency.product(name: "Words", package: "library")
let database = Target.Dependency.product(name: "Database", package: "library")

let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "App", dependencies: [tca, str, database, "Game", "Preferences"], plugins: [lint]),
  .target(name: "Game", dependencies: [tca, str, comps, words, types], plugins: [lint]),
  .target(name: "Preferences", dependencies: [tca, str, comps, types], plugins: [lint]),
]

let package = Package(
  name: "Features",
  defaultLocalization: "en",
  platforms: [.iOS(.v18), .macOS(.v15)],
  products: libs.map { .library(name: $0.name, targets: [$0.name]) },
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
    .package(url: "https://github.com/liamnichols/xcstrings-tool-plugin.git", from: "0.1.0"),
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
    .package(path: "../library"),
//    .package(path: "../extensions"),
  ],
  targets: libs + [
    .testTarget(name: "FeaturesTest", dependencies: libs.map { .byName(name: $0.name) }, path: "Test", plugins: [lint])
  ]
)

