//
//  SwiftUIGenPlugin.swift
//  SwiftUIGenPlugin
//
//  Created by Ian Keen on 2022-10-07.
//

import Foundation
import PackagePlugin

@main
struct SwiftUIGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else { return [] }

        return try runSwiftUIGen(
            tool: context.tool(named: "SwiftUIGen"),
            inputFolder: sourceTarget.directory,
            outputFolder: sourceTarget.directory,
            inputFiles: sourceTarget.sourceFiles.map { $0 }
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftUIGenPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return try runSwiftUIGen(
            tool: context.tool(named: "SwiftUIGen"),
            inputFolder: context.xcodeProject.directory,
            outputFolder: context.pluginWorkDirectory,
            inputFiles: target.inputFiles.map { $0 }
        )
    }
}
#endif

private extension Path {
    var adjusted: Path {
        return removingLastComponent().appending([lastComponent.uppercased()])
    }
}

private func runSwiftUIGen(tool: PluginContext.Tool, inputFolder: Path, outputFolder: Path, inputFiles: [File]) -> [Command] {
    guard !inputFiles.isEmpty else { return [] }

    let inputFiles = inputFiles.map { $0.path.adjusted }
    let outputFile = outputFolder.appending(["SwiftUI.Generated.swift"])

    return [
        .buildCommand(
            displayName: "SwiftUIGen",
            executable: tool.path,
            arguments: ["previews", "--output", outputFile.string],
            inputFiles: inputFiles,
            outputFiles: [outputFile]
        )
    ]
}
