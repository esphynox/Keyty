//
//  KeyboardSpecialKeyResolver.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Foundation

enum KeyboardSpecialKey {
    case keyCode(KeyboardKeyCode)
    case help
    case insert

    var displayText: String? {
        switch self {
        case .keyCode(let keyCode):
            return keyCode.displayText
        case .help:
            return UnicodeToken.questionMark.string + UnicodeToken.enclosingCircle.string
        case .insert:
            return "ins"
        }
    }
}

enum KeyboardSpecialKeyResolver {
    static func specialKey(for event: StandardKeyEvent) -> KeyboardSpecialKey? {
        if let semanticKey = self.semanticKey(from: event.charactersIgnoringModifiers)
            ?? self.semanticKey(from: event.characters) {
            return semanticKey
        }

        guard let keyCode = KeyboardKeyCode(rawValue: event.keyCode), keyCode.isSpecial else {
            return nil
        }

        if keyCode == .help {
            return .insert
        }

        return .keyCode(keyCode)
    }

    static func displayText(for event: StandardKeyEvent) -> String? {
        self.specialKey(for: event)?.displayText
    }

    static func isSpecial(_ event: StandardKeyEvent) -> Bool {
        self.specialKey(for: event) != nil
    }

    private static func semanticKey(from characters: String?) -> KeyboardSpecialKey? {
        guard let scalar = characters?.unicodeScalars.first else { return nil }
        switch Int(scalar.value) {
        case NSHelpFunctionKey:
            return .help
        case NSInsertFunctionKey:
            return .insert
        default:
            return nil
        }
    }
}
