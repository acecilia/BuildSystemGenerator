import Foundation
import AnyCodable

public enum Dependency {
    public enum Middleware {
        case firstParty(FirstPartyModule.Middleware)
        case thirdParty(ThirdPartyModule.Output)

        public var name: String {
            switch self {
            case .firstParty(let target):
                return target.name

            case .thirdParty(let artifact):
                return artifact.name
            }
        }
    }

    public enum Output: Codable {
        case firstParty(FirstPartyModule.Output)
        case thirdParty(ThirdPartyModule.Output)

        private enum CodingKeys: String, CodingKey {
            case type
        }

        public enum Kind: String, Codable {
            case firstParty
            case thirdParty
        }

        public var underlyingObject: DictionaryConvertible {
            switch self {
            case .firstParty(let firstPartyModule):
                return firstPartyModule

            case .thirdParty(let thirdPartyModule):
                return thirdPartyModule
            }
        }

        public var type: Kind {
            switch self {
            case .firstParty:
                return .firstParty

            case .thirdParty:
                return .thirdParty
            }
        }

        public func encode(to encoder: Encoder) throws {
            let basePath = encoder.userInfo[.relativePath] as! Path
            var dict = try underlyingObject.asDictionary(basePath)
            dict[CodingKeys.type.rawValue] = type.rawValue

            var container = encoder.singleValueContainer()
            try container.encode(dict.mapValues { AnyCodable($0) })
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(Kind.self, forKey: .type)
            
            switch type {
            case .firstParty:
                self = .firstParty(try FirstPartyModule.Output(from: decoder))

            case .thirdParty:
                self = .thirdParty(try ThirdPartyModule.Output(from: decoder))
            }
        }
    }
}
