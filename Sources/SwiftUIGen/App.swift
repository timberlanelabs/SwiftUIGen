import ArgumentParser
import Foundation
import SwiftUIGenKit

@main
struct SwiftUIGen: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swiftuigen",
        abstract: "A utility to generate helper code for SwiftUI",
        version: "1.0.0",
        subcommands: [Previews.self]
    )

    struct Previews: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate `PreviewDevice` presets")

        @Option(help: "The location the generated code will be written")
        var output: String

        func run() throws {
            try PreviewsGenerator(output: output).run()
        }
    }
}
