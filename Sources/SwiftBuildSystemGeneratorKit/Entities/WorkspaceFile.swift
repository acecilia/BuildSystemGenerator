import Foundation

struct WorkspaceFile: Decodable {
    @RawWrapper
    private(set) var global: Global
    var options: Options
    let firstParty: [Module.Input]
    let artifacts: [Artifact.Input]
    let versionSpecs: [VersionSpec]
}
