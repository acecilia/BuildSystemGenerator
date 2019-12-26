import Stencil
import Path

class TemplateEngine {
    static let shared = TemplateEngine()
    
    private init() { }

    func render(templateName: String, context: [String: Any]) throws -> String {
        let environment = Environment(
          loader: FileSystemLoader(paths: [.init(Current.options.templatePath.string)]),
          throwOnUnresolvedVariable: true
        )
        let rendered = try environment.renderTemplate(name: templateName, context: context)
        return trimNewLines(rendered)
    }

    /// See: https://github.com/groue/GRMustache/issues/46#issuecomment-19498046
    private func trimNewLines(_ value: String) -> String {
        return value
            .replacingOccurrences(of: "\n( *\n)+", with: "\n", options: .regularExpression)
            .replacingOccurrences(of: "\n¶", with: "\n")
            .replacingOccurrences(of: "¶", with: "\n")
    }
}

extension Stencil.TemplateSyntaxError: ThirdPartyErrorInterface {
    public var thirdPartyErrorDescription: String {
        let reporter = SimpleErrorReporter()
        return """
        Template syntax error.
        \(reporter.renderError(self))
        """
    }
}
