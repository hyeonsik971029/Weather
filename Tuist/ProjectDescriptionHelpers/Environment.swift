import ProjectDescription

public enum Environment {
    public static let appName = "weather"
    public static let targetName = "weather-grid"
    public static let targetTestName = "\(targetName)Tests"
    public static let organizationName = "hyeonsik"
    public static let deploymentTargets = DeploymentTargets.iOS("15.0")
    public static let baseSetting: SettingsDictionary = SettingsDictionary()
}
