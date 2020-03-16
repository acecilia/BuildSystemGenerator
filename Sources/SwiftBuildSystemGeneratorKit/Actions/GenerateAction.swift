import Foundation
import Yams
import Path

public class GenerateAction: Action {
    public init() { }

    public func execute() throws {
        // Resolve modules
        let workspaceFileContent = try String(contentsOf: cwd/"workspace.yml")
        let workspaceFile: WorkspaceFile = try YAMLDecoder().decode(from: workspaceFileContent, userInfo: [.relativePath: cwd])
        let resolver = try Resolver(workspaceFile)
        let mainContext = MainContext(global: workspaceFile.$global, modules: resolver.moduleContexts)

        // Resolve templates
        for template in workspaceFile.options.templatesPath.ls() where template.isFile {
            let templateFileContent = try String(contentsOf: template)
            let templateFiles: [TemplateFile] = try [YAMLDecoder().decode(from: templateFileContent)]

            for templateFile in templateFiles {
                switch templateFile.context {
                case .module:
                    for module in mainContext.modules {
                        let context = try mainContext.asDictionary(module.path, for: module)
                        switch templateFile.outputLevel {
                        case .module:
                            try write(templateFile: templateFile, context: context, outputPath: module.path)

                        case .root:
                            try write(templateFile: templateFile, context: context, outputPath: cwd)
                        }
                    }

                case .global:
                    let context = try mainContext.asDictionary(cwd)
                    switch templateFile.outputLevel {
                    case .module:
                        for module in mainContext.modules {
                            try write(templateFile: templateFile, context: context, outputPath: module.path)
                        }

                    case .root:
                        try write(templateFile: templateFile, context: context, outputPath: cwd)
                    }
                }
            }
        }
    }

    private func write(templateFile: TemplateFile, context: [String : Any], outputPath: Path) throws {
        let fileName = try TemplateEngine.shared.render(
            templateContent: templateFile.name,
            context: context
        )

        let rendered = try TemplateEngine.shared.render(
            templateContent: templateFile.content,
            context: context
        )

        let outputPath = outputPath/templateFile.subdir/fileName
        try outputPath.delete()
        try outputPath.parent.mkdir()
        try rendered.write(to: outputPath)
    }
}
