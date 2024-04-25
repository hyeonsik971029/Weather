import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Domain",
    product: .framework,
    dependencies: [
        .Project.Shared.Extensions
    ]
)
