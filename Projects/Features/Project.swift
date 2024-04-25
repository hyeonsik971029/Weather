import ProjectDescriptionHelpers
import ProjectDescription
import UtilityPlugin

let project = Project.makeModule(
    name: "Features",
    product: .framework,
    packages: [.TCA],
    dependencies: [
        .Project.Data.Data,
        .Project.UserInterfaces.DesignSystems,
        .SPM.ComposableArchitecture
    ]
)
