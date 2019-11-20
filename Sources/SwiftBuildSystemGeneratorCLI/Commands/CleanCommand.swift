import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit
import Path

public class CleanCommand: Command {
    public static let name: String = "clean"
    public let shortDescription: String = "Removes all generated build system configurations"

    let reporter: ReporterInterface
    public init(reporter: ReporterInterface) {
        self.reporter = reporter
    }

    public func execute() throws {
        let rootPath = Path(Path.cwd)

        reporter.print("Removing existing configuration files from path: \(rootPath)")

        let options = Options(rootPath: rootPath, reporter: reporter)
        let fileIterator = FileIterator(options)
        let modules = try fileIterator.start()

        reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: rootPath)
            reporter.print("\(relativePath)")
        }
        
        let generators: [GeneratorInterface] = [
            XcodegenGenerator(options, modules)
        ]

        for generator in generators {
            try generator.clean()
        }

        reporter.print("Done")
    }
}
