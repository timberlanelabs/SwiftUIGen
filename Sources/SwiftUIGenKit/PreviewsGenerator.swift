//
//  PreviewsGenerator.swift
//  SwiftUIGenKit
//
//  Created by Ian Keen on 2021-09-15.
//

import Foundation

public struct PreviewsGenerator {
    enum Error: Swift.Error {
        case outputMustBeSwiftFile
    }

    private let output: String
    private let charactersToRemove = CharacterSet.alphanumerics.inverted

    public init(output: String) {
        self.output = output
    }

    public func run() throws {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: output, isDirectory: &isDirectory)
        if isDirectory.boolValue || !output.hasSuffix(".swift") {
            throw "Output '\(output)' must be a .swift file"
        }

        let jsonData = try Process().launch(with: "xcrun simctl list devicetypes -j")
        let devices = try JSONDecoder().decode(DeviceList.self, from: jsonData)

        let grouped = Dictionary(grouping: devices.devicetypes, by: \.productFamily)

        let previews = grouped.keys.sorted()
            .map { generatePreviews(grouped[$0, default: []]) }
            .joined()

        let contents = """
        // swiftlint:disable all
        // Generated using SwiftUIGen

        import SwiftUI

        \(previews)
        """

        try Data(contents.utf8).write(to: URL(fileURLWithPath: output), options: [.atomic])
    }

    private func generatePreviews(_ devices: [Device]) -> String {
        guard let first = devices.first else { return "" }

        var familyName = first.productFamily
        familyName.removeAll(where: charactersToRemove.contains)

        return """
        public struct \(familyName)Device: RawRepresentable, Equatable {
            public var rawValue: String
            public init(rawValue: String) { self.rawValue = rawValue }
        }
        extension PreviewDevice {
            public static func \(familyName.lowercasedFirst())(_ device: \(familyName)Device) -> PreviewDevice { .init(rawValue: device.rawValue) }
        }
        extension \(familyName)Device {
        \(devices.sorted(by: { $0.name < $1.name })
            .map { device -> String in
                var deviceName = device.name
                deviceName.removeAll(where: charactersToRemove.contains)
                deviceName = deviceName
                    .replacingOccurrences(of: "mini", with: "Mini")
                    .replacingOccurrences(of: "generation", with: "Generation")

                deviceName.lowercaseFirst()

                return """
                    public static let \(deviceName) = \(familyName)Device(rawValue: "\(device.identifier)")
                """
            }
            .joined(separator: "\n")
        )
        }

        """
    }
}

private struct DeviceList: Decodable, Equatable {
    let devicetypes: [Device]
}
private struct Device: Decodable, Equatable {
    let name: String
    let identifier: String
    let productFamily: String
}
