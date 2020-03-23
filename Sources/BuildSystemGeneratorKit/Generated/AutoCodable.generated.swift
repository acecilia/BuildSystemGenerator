// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


extension Context {

    enum CodingKeys: String, CodingKey {
        case global
        case module
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.global.rawValue: self = .global
        case CodingKeys.module.rawValue: self = .module
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .global: try container.encode(CodingKeys.global.rawValue)
        case .module: try container.encode(CodingKeys.module.rawValue)
        }
    }

}

extension FirstPartyModule.Input {

    enum CodingKeys: String, CodingKey {
        case name
        case dependencies
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        dependencies = (try? container.decode([String: [String]].self, forKey: .dependencies)) ?? FirstPartyModule.Input.defaultDependencies
    }

}

extension OutputLevel {

    enum CodingKeys: String, CodingKey {
        case root
        case module
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let enumCase = try container.decode(String.self)
        switch enumCase {
        case CodingKeys.root.rawValue: self = .root
        case CodingKeys.module.rawValue: self = .module
        default: throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Unknown enum case '\(enumCase)'"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .root: try container.encode(CodingKeys.root.rawValue)
        case .module: try container.encode(CodingKeys.module.rawValue)
        }
    }

}

extension TemplateFile {

    enum CodingKeys: String, CodingKey {
        case name
        case context
        case outputLevel
        case subdir
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        context = try container.decode(Context.self, forKey: .context)
        outputLevel = try container.decode(OutputLevel.self, forKey: .outputLevel)
        subdir = (try? container.decode(String.self, forKey: .subdir)) ?? TemplateFile.defaultSubdir
        content = try container.decode(String.self, forKey: .content)
    }

}

extension BsgFile {

    enum CodingKeys: String, CodingKey {
        case global
        case modules
        case versionSources
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        global = (try? container.decode([String: String].self, forKey: .global)) ?? BsgFile.defaultGlobal
        modules = (try? container.decode([FirstPartyModule.Input].self, forKey: .modules)) ?? BsgFile.defaultModules
        versionSources = (try? container.decode([Path].self, forKey: .versionSources)) ?? BsgFile.defaultVersionSources
        options = try container.decode(Options.self, forKey: .options)
    }

}
