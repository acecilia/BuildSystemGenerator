import Foundation
import Path


public struct TemplateResolver2 {
    public static let fileName = "templates.yml"
    public static let defaultFolderName = "Templates"

    private let env: Env

    public init(_ env: Env) {
        self.env = env
    }

    public func resolveTemplate(_ relativePath: String) throws -> Path {
        let paths: [Path?] = [
            // First: treat as absolut path
            Path(relativePath),
            // Second: check relative to the current location
            env.cwd/relativePath,
            // Third: check the bundled templates. They should be located next to the binary (follow symlinks if needed)
            try? Bundle.main.executable?.readlink().parent
                .join(Self.defaultFolderName)
                .join(relativePath)
                .join(Self.fileName),
            // Fourth: check the path relative to this file (to be used during development)
            Path(#file)?.parent.parent.parent.parent
                .join(Self.defaultFolderName)
                .join(relativePath)
                .join(Self.fileName)
            ]

        let templateFile = try paths
            .compactMap { $0 }
            .first { $0.exists }
            .require(relativePath)

        env.reporter.info(.pageFacingUp, "using template file at path \(templateFile.string)")

        return templateFile
    }
}

public struct TemplateSpec: Decodable {
    public let mode: Mode
}

private extension Optional {
    func require(_ relativePath: String) throws -> Wrapped {
        guard let unwrapped = self else {
            throw CustomError(.templatesFileNotFound(relativePath: relativePath))
        }
        return unwrapped
    }
}

public extension TemplateSpec {
    enum Mode: Decodable {
        public static let defaultModuleFilter = NSRegularExpression(".*")

        case module(filter: NSRegularExpression)
        case moduleToRoot(filter: NSRegularExpression)
        case root

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let singleValue = try? container.decode(SingleValue.self) {
                switch singleValue {
                case .module:
                    self = .module(filter: Self.defaultModuleFilter)

                case .moduleToRoot:
                    self = .moduleToRoot(filter: Self.defaultModuleFilter)

                case .root:
                    self = .root
                }
            } else {
                let fullValue = try container.decode(FullValue.self)
                switch fullValue {
                case let .module(filter):
                    self = .module(filter: filter?.wrappedValue ?? Self.defaultModuleFilter)

                case let .moduleToRoot(filter):
                    self = .moduleToRoot(filter: filter?.wrappedValue ?? Self.defaultModuleFilter)

                case .root:
                    self = .root
                }

            }
        }
    }
}

extension TemplateSpec.Mode {
    enum SingleValue: String, Codable {
        case module
        case moduleToRoot
        case root
    }

    enum FullValue: AutoCodable {
        case module(filter: RegularExpression?)
        case moduleToRoot(filter: RegularExpression?)
        case root
    }
}
