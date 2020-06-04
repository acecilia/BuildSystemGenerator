import XCTest
import StackGenCLI
import StackGenKit
import Path
import Foundation

// This tests are used to regenerate the fixtures and other files. They are enabled by default, but disabled on CI
#if DISABLE_GENERATOR
typealias GeneratorTestCase = XCTest
#else
typealias GeneratorTestCase = XCTestCase
#endif

final class AAA_Generator: GeneratorTestCase {
    func test_01_Clean() throws {
        // It is faster to move the files than to remove them
        let trash = Constant.tmpDir.join("trash").join(UUID().uuidString)
        if fixturesPath.exists { try fixturesPath.move(into: trash) }
        if testsOutputPath.exists { try testsOutputPath.move(into: trash) }
    }

    func test_02_SelfGenerate() throws {
        let path = rootPath
        FileManager.default.changeCurrentDirectoryPath(path.string)

        let cli = CLI()
        let exitCode = cli.execute(with: [Generate.name])
        XCTAssertEqual(exitCode, 0)
    }

    func test_03_GenerateFixtures() throws {
        Snapshot.recording = true
        for testSpec in GenerateTests.testSpecs() {
            let test = GenerateTests()
            try testSpec.implementation(test)
        }
        Snapshot.recording = false
    }
}
