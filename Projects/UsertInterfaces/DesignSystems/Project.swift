import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "DesignSystems",
    product: .framework,
    dependencies: [],
    resources: ["Resources/**"]
)
