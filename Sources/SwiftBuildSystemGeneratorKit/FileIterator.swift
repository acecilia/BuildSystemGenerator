import Path
import Yams

public class FileIterator {
    public let options: Options

    public init(_ options: Options) {
        self.options = options
    }
    
    public func start(_ globals: Globals) throws -> [Module] {
        let configurationFiles = Options.rootPath.find().type(.file).filter { $0.basename() == options.fileName }
        let middlewareModules = try configurationFiles.map { try Module.Middleware($0) }
        let modules = try middlewareModules.map { try Module($0, globals, resolveDependenciesUsing: middlewareModules) }
        return modules
    }
}
