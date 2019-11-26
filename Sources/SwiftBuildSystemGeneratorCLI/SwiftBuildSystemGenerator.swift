import Foundation
import SwiftCLI
import SwiftBuildSystemGeneratorKit

public class SwiftBuildSystemGeneratorCLI {
    let cli: CLI

    public init() {
        cli = CLI(
            name: "swiftbuildsystemgenerator",
            description: "Generates build system configurations for swift projects",
            commands: [
                GenerateCommand(),
                CleanCommand(),
                XcodeGenConvertCommand()
            ]
        )

        cli.helpMessageGenerator = MessageGenerator()
        cli.parser.routeBehavior = .searchWithFallback(cli.commands.first! as! Command)
    }

    public func execute(with arguments: [String] = []) -> Int32 {
        return cli.go(with: arguments)
    }
}
