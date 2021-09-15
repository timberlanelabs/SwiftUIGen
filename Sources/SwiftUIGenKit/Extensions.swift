//
//  Extensions.swift
//  SwiftUIGenKit
//
//  Created by Ian Keen on 2021-09-15.
//

import Foundation

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        guard let value = character.unicodeScalars.first else { return false }
        return contains(value)
    }
}

extension String {
    mutating func lowercaseFirst() {
        guard !self[startIndex].isLowercase else { return }
        replaceSubrange(startIndex...startIndex, with: self[startIndex].lowercased())
    }
    func lowercasedFirst() -> String {
        guard !self[startIndex].isLowercase else { return self }
        return replacingCharacters(in: startIndex...startIndex, with: self[startIndex].lowercased())
    }
}
