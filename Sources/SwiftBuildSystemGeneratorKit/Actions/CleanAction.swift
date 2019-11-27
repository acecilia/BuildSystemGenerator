import Foundation
import Path

public class CleanAction: Action {
    public init(_ commandLineOptions: Options.Yaml) throws {
        try setCurrent(commandLineOptions)
    }

    public func execute() throws {
        Reporter.print("Removing existing configuration files from path: \(Current.wd)")

        let modules = try FileIterator().start()

        Reporter.print("Found modules:")
        modules.forEach {
            let relativePath = $0.path.relative(to: Current.wd)
            Reporter.print("\(relativePath)")
        }

        let converters: [ConverterInterface] = Current.options.converters.map {
            $0.build()
        }

        if converters.isEmpty == false {
            for converter in converters {
                try converter.clean()
            }
        } else {
            let generators: [GeneratorInterface] = Current.options.generators.map {
                $0.build(modules)
            }

            for generator in generators {
                try generator.clean()
            }
        }

        Reporter.print("Done")
    }
}
