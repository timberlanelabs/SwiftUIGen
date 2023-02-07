//
//  SwiftUIGenPluginCommand.swift
//  SwiftUIGenPluginCommand
//
//  Created by Ian Keen on 2023-02-06.
//

import Foundation
import PackagePlugin

@main
struct SwiftUIGenPluginCommand: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) async throws {
        try runSwiftUIGen(
            exe: context.tool(named: "SwiftUIGen"),
            output: context.package.directory
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftUIGenPluginCommand: XcodeCommandPlugin {
    func performCommand(context: XcodePluginContext, arguments: [String]) throws {
        try runSwiftUIGen(
            exe: context.tool(named: "SwiftUIGen"),
            output: context.xcodeProject.directory
        )
    }
}
#endif

enum PluginError: Error {
    case inputMissing
    case outputMissing
}

private func runSwiftUIGen(exe: PluginContext.Tool, output: Path) throws {
    guard !output.string.isEmpty else { throw PluginError.outputMissing }

    let outputFile = output.appending(subpath: "SwiftUI.Generated.swift")

    let process = Process()
    process.executableURL = URL(fileURLWithPath: exe.path.string)
    process.arguments = ["previews", "--output", outputFile.string]

    let outputPipe = Pipe()
    process.standardOutput = outputPipe
    try process.run()
    process.waitUntilExit()
}
