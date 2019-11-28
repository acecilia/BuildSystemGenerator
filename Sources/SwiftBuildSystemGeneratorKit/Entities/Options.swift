import Foundation
import Path

public struct Options {
    public static let defaultFileName = "module.yml"
    public static let defaultTemplatesPath = "Templates"
    public static let defaultGenerateXcodeProject = false
    public static let defaultCarthagePath = cwd

    public let fileName: String
    public let templatePath: String
    public let generateXcodeProject: Bool
    public let generators: [Generator]
    public let converters: [Converter]
    public let carthagePath: Path

    public init(
        yaml: Yaml?
    ) {
        self.fileName = yaml?.fileName ?? Self.defaultFileName
        self.templatePath = yaml?.templatePath ?? Self.defaultTemplatesPath
        self.generateXcodeProject = yaml?.generateXcodeProject ?? Self.defaultGenerateXcodeProject
        if let generators = yaml?.generators, generators.isEmpty == false {
            self.generators = generators
        } else {
            self.generators = Generator.allCases
        }
        self.converters = yaml?.converters ?? []
        self.carthagePath = yaml?.carthagePath ?? Self.defaultCarthagePath
    }
}

extension Options {
    public struct Yaml: Codable {
        public let fileName: String?
        public let templatePath: String?
        public let generateXcodeProject: Bool?
        public let generators: [Generator]?
        public let converters: [Converter]?
        public let carthagePath: Path?

        public init(
            fileName: String?,
            templatePath: String?,
            generateXcodeProject: Bool?,
            generators: [Generator]?,
            converters: [Converter]?,
            carthagePath: Path?
        ) {
            self.fileName = fileName
            self.templatePath = templatePath
            self.generateXcodeProject = generateXcodeProject
            self.generators = generators
            self.converters = converters
            self.carthagePath = carthagePath
        }

        public func merge(with yaml: Yaml?) -> Yaml {
            return Yaml(
                fileName: fileName ?? yaml?.fileName,
                templatePath: templatePath ?? yaml?.templatePath,
                generateXcodeProject: generateXcodeProject ?? yaml?.generateXcodeProject,
                generators: generators ?? yaml?.generators,
                converters: converters ?? yaml?.converters,
                carthagePath: carthagePath ?? yaml?.carthagePath
            )
        }
    }
}
