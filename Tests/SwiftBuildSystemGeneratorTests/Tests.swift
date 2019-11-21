import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testClean() throws {
        for generator in GeneratorType.allCases {
            let destination = try (fixturesPath/generator.rawValue).copy(into: try tmp())

            FileManager.default.changeCurrentDirectoryPath(destination.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: [CleanCommand.name])
            XCTAssertEqual(status, 0)

            let result = FileManager.default.contentsEqual(
                atPath: destination.string,
                andPath: examplesPath.string
            )
            XCTAssertTrue(result, "Generator '\(generator)' failed")
        }
    }

    func testGenerate() throws {
        for generator in GeneratorType.allCases {
            let destination = try examplesPath.copy(into: try tmp())

            FileManager.default.changeCurrentDirectoryPath(destination.string)
            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: generateCommandArgs(generator))
            XCTAssertEqual(status, 0)

            let result = FileManager.default.contentsEqual(
                atPath: destination.string,
                andPath: (fixturesPath/generator.rawValue).string
            )
            XCTAssertTrue(result, "Generator '\(generator)' failed")
        }
    }
}
