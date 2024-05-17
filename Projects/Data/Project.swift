import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Data",
    product: .framework,
    dependencies: [
        .Project.Domain.Domain,
        .Project.Shared.Extensions,
        .Project.Shared.Utilities
    ],
    resources: ["Resources/**"]
)
