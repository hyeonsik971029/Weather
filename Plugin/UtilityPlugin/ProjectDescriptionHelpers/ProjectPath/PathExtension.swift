import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToFeatures(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    static func relativeToDomain(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    static func relativeToData(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    static func relativeToShared(_ path: String) -> Self {
        return .relativeToRoot("Projects/Shared/\(path)")
    }
    static func relativeToUserInterfaces(_ path: String) -> Self {
        return .relativeToRoot("Projects/UsertInterfaces/\(path)")
    }
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

public extension TargetDependency {
    static func features(name: String) -> Self {
        return .project(target: name, path: .relativeToFeatures(name))
    }
    static func domain(name: String) -> Self {
        return .project(target: name, path: .relativeToDomain(name))
    }
    static func data(name: String) -> Self {
        return .project(target: name, path: .relativeToData(name))
    }
    static func shared(name: String) -> Self {
        return .project(target: name, path: .relativeToShared(name))
    }
    static func ui(name: String) -> Self {
        return .project(target: name, path: .relativeToUserInterfaces(name))
    }
}
