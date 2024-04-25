import ProjectDescription
import UtilityPlugin

public extension Project {
    static func makeModule(
        name: String,
        destinations: Destinations = .iOS,
        product: Product,
        packages: [Package] = [],
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        demoResources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default,
        hasDemoApp: Bool = false
    ) -> Project {
        return project(
            name: name,
            destinations: destinations,
            product: product,
            packages: packages,
            dependencies: dependencies,
            sources: sources,
            resources: resources,
            infoPlist: infoPlist,
            hasDemoApp: hasDemoApp
        )
    }
}

public extension Project {
    static func project(
        name: String,
        destinations: Destinations,
        product: Product,
        organizationName: String = Environment.organizationName,
        packages: [Package] = [],
        deploymentTargets: DeploymentTargets? = Environment.deploymentTargets,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList,
        resources: ResourceFileElements? = nil,
        demoResources: ResourceFileElements? = nil,
        infoPlist: InfoPlist,
        hasDemoApp: Bool = false
    ) -> Project {
        let scripts: [TargetScript] = [
            .swiftLint
        ]
        let settings: Settings = .settings(
            base: Environment.baseSetting,
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ], defaultSettings: .recommended)
        let appTarget = Target.target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            scripts: scripts,
            dependencies: dependencies
        )
        let demoSource: SourceFilesList = ["Demo/Sources/**"]
        let demoSources: SourceFilesList = .sourceFilesList(globs: sources.globs + demoSource.globs)
        
        let demoAppTarget = Target.target(
            name: "\(name)DemoApp",
            destinations: destinations,
            product: .app,
            bundleId: "\(organizationName).\(name)DemoApp",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: [
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "ENABLE_TESTS": .boolean(true),
            ]),
            sources: demoSources,
            resources: nil,
            scripts: scripts,
            dependencies: [
                .target(name: name)
            ]
        )
        
        let testTargetDependencies: [TargetDependency] = hasDemoApp
        ? [.target(name: "\(name)DemoApp")]
        : [.target(name: name)]
        
        let testTarget = Target.target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTargets: deploymentTargets,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: testTargetDependencies
        )
        
        let schemes: [Scheme] = hasDemoApp
        ? [.makeScheme(target: .debug, name: name), .makeDemoScheme(target: .debug, name: name)]
        : [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = hasDemoApp
        ? [appTarget, testTarget, demoAppTarget]
        : [appTarget, testTarget]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
    static func makeDemoScheme(target: ConfigurationName, name: String) -> Scheme {
        .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)DemoApp"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)DemoApp"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
