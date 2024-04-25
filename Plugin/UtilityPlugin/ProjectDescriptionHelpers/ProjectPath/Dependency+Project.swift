import ProjectDescription

public extension TargetDependency {
    struct Project {
        public struct Features {}
        public struct Domain {}
        public struct Data {}
        public struct Shared {}
        public struct UserInterfaces {}
    }
}

public extension TargetDependency.Project.Features {
    static let Features = TargetDependency.features(name: "Features")
}

public extension TargetDependency.Project.Domain {
    static let Domain = TargetDependency.domain(name: "Domain")
}

public extension TargetDependency.Project.Data {
    static let Data = TargetDependency.data(name: "Data")
}

public extension TargetDependency.Project.Shared {
    static let Extensions = TargetDependency.shared(name: "Extensions")
    static let Utilities = TargetDependency.shared(name: "Utilities")
}

public extension TargetDependency.Project.UserInterfaces {
    static let DesignSystems = TargetDependency.ui(name: "DesignSystems")
}
