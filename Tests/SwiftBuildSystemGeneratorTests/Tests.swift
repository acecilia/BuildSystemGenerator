import XCTest
import SwiftBuildSystemGeneratorCLI
import SwiftBuildSystemGeneratorKit
import Path

final class Tests: XCTestCase {
    func testGenerate() throws {
        for templatesPath in templatesPath.ls().directories {
            let templatesName = templatesPath.basename()

            let destination = try examplesPath.copy(into: try tmp())
            FileManager.default.changeCurrentDirectoryPath(destination.string)
            try patchWorkspaceFile(destination, using: templatesPath)

            let cli = SwiftBuildSystemGeneratorCLI()
            let status = cli.execute(with: generateCommandArgs())
            XCTAssertEqual(status, 0)

            assert(fixture: fixturesPath/templatesName, equals: destination)
        }
    }
}
