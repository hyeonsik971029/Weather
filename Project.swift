import ProjectDescription

let project = Project(
    name: "Weather",
    targets: [
        .target(
            name: "Weather",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.Weather",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "NSAppTransportSecurity": {
                        "NSAllowsArbitraryLoads": true
                    },
                ]
            ),
            sources: ["Weather/Sources/**"],
            resources: ["Weather/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "WeatherTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.WeatherTests",
            infoPlist: .default,
            sources: ["Weather/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Weather")]
        ),
    ]
)
