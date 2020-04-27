import Foundation
import Path

public class DefaultReporter: ReporterInterface {
    public init() { }

    public func start(_ arguments: [String]) {
        Swift.print("🌱 Working directory: \(cwd)")
        Swift.print("🌱 Arguments: '\(arguments.joined(separator: " "))'")
    }

    public func info(_ string: String) {
        Swift.print("✨ \(string.capitalizingFirstLetter())")
    }

    public func warning(_ string: String) {
        Swift.print("⚠️ Warning: \(string)")
    }

    public func formatAsError(_ string: String) -> String {
        return "💥 Error: \(string)"
    }

    public func end(_ status: Int32) {
        if status == 0 {
            Swift.print("✅ Done")
        } else {
            Swift.print("💥 Failed")
        }
    }
}
