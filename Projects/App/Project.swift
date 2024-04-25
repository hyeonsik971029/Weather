import ProjectDescriptionHelpers
import ProjectDescription
import UtilityPlugin

let settings: Settings = .settings(
    base: Environment.baseSetting,
    configurations: [
        .debug(name: .debug),
        .release(name: .release)
    ],
    defaultSettings: .recommended
)

let scripts: [TargetScript] = [
    .swiftLint
]

let targets: [Target] = [
    .target(
        name: Environment.targetName,
        destinations: .iOS,
        product: .app,
        bundleId: "\(Environment.organizationName).\(Environment.targetName)",
        deploymentTargets: Environment.deploymentTargets,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: ["Sources/**"],
        resources: ["Resources/**"],
        scripts: scripts,
        dependencies: [
            .Project.Features.Features
        ],
        settings: .settings(base: Environment.baseSetting)
    ),
    .target(
        name: Environment.targetTestName,
        destinations: .iOS,
        product: .uiTests,
        bundleId: "\(Environment.organizationName).\(Environment.targetName)Tests",
        infoPlist: .default,
        sources: ["Tests/**"],
        dependencies: [
            .target(name: Environment.targetName)
        ]
    )
]

let schemes: [Scheme] = [
    .scheme(
        name: "\(Environment.targetName)-DEBUG",
        shared: true,
        buildAction: .buildAction(targets: ["\(Environment.targetName)"]),
        testAction: TestAction.targets(
            ["\(Environment.targetTestName)"],
            configuration: .debug,
            options: TestActionOptions.options(
                coverage: true,
                codeCoverageTargets: ["\(Environment.targetName)"]
            )
        ),
        runAction: .runAction(configuration: .debug),
        archiveAction: .archiveAction(configuration: .debug),
        profileAction: .profileAction(configuration: .debug),
        analyzeAction: .analyzeAction(configuration: .debug)
    ),
    .scheme(
        name: "\(Environment.targetName)-RELEASE",
        shared: true,
        buildAction: .buildAction(targets: ["\(Environment.targetName)"]),
        testAction: nil,
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
    )
]

let project: Project =
    .init(
        name: Environment.targetName,
        organizationName: Environment.organizationName,
        packages: [.TCA],
        settings: settings,
        targets: targets,
        schemes: schemes
    )
