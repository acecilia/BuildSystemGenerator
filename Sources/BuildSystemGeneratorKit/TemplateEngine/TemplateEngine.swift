import Stencil
import Path
import Foundation

public class TemplateEngine {
    private let env: Environment
    
    public init(_ templatesFilePath: Path) {
        self.env = Environment(
            loader: FileSystemLoader(paths: [.init(templatesFilePath.parent.relative(to: cwd))]),
            throwOnUnresolvedVariable: true
        )
    }

    public func render(templateContent: String, context: [String: Any]) throws -> String {
        let fixedTemplateContent = addNewLineDelimiters(templateContent)
        let rendered = try env.renderTemplate(string: fixedTemplateContent, context: context)
        return removeNewLinesDelimiters(rendered)
    }

    /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    private func addNewLineDelimiters(_ value: String) -> String {
        return value.replacingOccurrences(of: "\n\n", with: "\n¶\n")
    }

    private func removeNewLinesDelimiters(_ value: String) -> String {
        return value
            .replacingOccurrences(of: "\n( *\n)+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: "\n¶", with: "\n")
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
