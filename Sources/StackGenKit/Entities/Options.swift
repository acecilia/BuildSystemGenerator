import Foundation
import Path

public enum Options {
    public struct CLI: Codable {
        public let templates: String?

        public init(templates: String? = nil) {
            self.templates = templates
        }
    }

    public struct StackGenFile: Codable {
        public let templates: String?
        public let root: String?

        public init(
            templates: String? = nil,
            root: String? = nil
        ) {
            self.templates = templates
            self.root = root
        }
    }

    public struct Resolved {
        public let templates: String

        public init(_ cliOptions: CLI, _ stackGenFileOptions: StackGenFile) throws  {
            self.templates = try (cliOptions.templates ?? stackGenFileOptions.templates)
                .unwrap(onFailure: .requiredParameterNotFound(name: "templateFile"))
        }
    }
}
