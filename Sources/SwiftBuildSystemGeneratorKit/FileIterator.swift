import Path
import Yams

public class FileIterator {
    public init() { }
    
    public func start() throws -> [Module] {
        let configurationFiles = cwd.find(name: Current.options.fileName)
        let middlewareModules = try configurationFiles.map { try Module.Middleware($0) }

        try Self.performDuplicatedModulesCheck(middlewareModules)

        let modules = try middlewareModules.map { try Module($0, resolveDependenciesUsing: middlewareModules) }
        let foundModules = modules.map { $0.path.relative(to: cwd) }.joined(separator: ", ")
        Reporter.info("found modules '\(foundModules)'")
        
        return modules
    }

    private static func performDuplicatedModulesCheck(_ middlewareModules: [Module.Middleware]) throws {
        var modules = [
            middlewareModules.map { (name: $0.name, description: $0.path.relative(to: cwd)) },
            try Current.carthageService.getFrameworks().map { (name: $0.name, description: "carthage: \($0.name)") }
            ]
            .flatMap { $0 }

        while let module = modules.popLast() {
            let duplications = modules.filter { $0.name == module.name }.map { $0.description }
            if duplications.isEmpty == false {
                throw CustomError(.multipleModulesWithSameName(modules: duplications))
            }
        }
    }
}
