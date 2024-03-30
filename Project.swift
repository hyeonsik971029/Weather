import ProjectDescription

protocol ProjectFactory {
    var projectName: String { get }
    var packages: [Package] { get }
    var dependencies: [TargetDependency] { get }
    
    func target() -> [Target]
}

class BaseProjectFactory: ProjectFactory {
    
    let appName: String = "Weather"
    let targetName: String = "weather-grid"
    let projectName: String = "weather-ios"
    
    let infoPlist: [String: ProjectDescription.Plist.Value] = [
        "CFBundleName": "날씨",
        "CFBundleShortVersionString": "1.0.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen.storyboard",
        "NSAppTransportSecurity": [
            "NSAllowsArbitraryLoads": true
        ],
    ]
    
    let packages: [Package] = [
        .remote(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            requirement: .upToNextMajor(from: "1.9.0")
        )
    ]
    let dependencies: [TargetDependency] = [
        .package(product: "ComposableArchitecture", type: .runtime)
    ]
    
    func target() -> [Target] {
        [
            .target(
                name: targetName,
                destinations: .iOS,
                product: .app,
                bundleId: "com.hyeonsik.\(appName)",
                deploymentTargets: .iOS("15.0"),
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["Weather/Sources/**"],
                resources: ["Weather/Resources/**"],
                dependencies: dependencies
            ),
            .target(
                name: "\(targetName)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "com.hyeonsik.\(appName)Tests",
                infoPlist: .default,
                sources: ["Weather/Tests/**"],
                resources: [],
                dependencies: [.target(name: targetName)]
            )
        ]
    }
    
}

let factory = BaseProjectFactory()

let project = Project(
    name: factory.appName,
    organizationName: factory.projectName,
    packages: factory.packages,
    targets: factory.target()
)
