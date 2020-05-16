import Stencil
import Path
import Foundation
import Path

public class TemplateEngine {
    private let environment: Environment
    private let extensions = CustomExtensions()
    
    public init(_ templatesFilePath: Path, _ env: Env) {
        self.environment = Environment(
            loader: FileSystemLoader(paths: [.init(templatesFilePath.parent.relative(to: env.cwd))]),
            extensions: [extensions],
            throwOnUnresolvedVariable: true
        )
    }

    public func render(templateContent: String, context: MainContext) throws -> String {
        extensions.set(context)
        let encodedContext = try context.asDictionary(context.global.output.path.parent)
        let fixedTemplateContent = addNewLineDelimiters(templateContent)
        let rendered = try environment.renderTemplate(string: fixedTemplateContent, context: encodedContext)
        return removeNewLinesDelimiters(rendered)
    }

    /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    private func addNewLineDelimiters(_ value: String) -> String {
        return value.replacingOccurrences(of: "\n\n", with: "\n¶\n")
    }

    private func removeNewLinesDelimiters(_ value: String) -> String {
        return value
            .replacingOccurrences(of: "\n( *\n)+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: "^\n+", with: "", options: .regularExpression)
            .replacingOccurrences(of: "¶\n", with: "\n")
    }
}

extension Stencil.TemplateSyntaxError: LocalizedError {
    public var errorDescription: String? {
        let reporter = SimpleErrorReporter()
        return """
        Template syntax error.
        \(reporter.renderError(self))
        """
    }
}
