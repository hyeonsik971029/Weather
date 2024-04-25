import ProjectDescription

public extension TargetDependency.SPM {
    static let ComposableArchitecture = TargetDependency.package(product: "ComposableArchitecture")
}

public extension Package {
    static let TCA = Package.remote(
        url: "https://github.com/pointfreeco/swift-composable-architecture",
        requirement: .upToNextMajor(from: "1.9.0")
    )
}
