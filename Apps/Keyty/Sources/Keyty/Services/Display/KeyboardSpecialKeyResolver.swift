//
//  KeyboardSpecialKeyResolver.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Foundation

/// Resolves semantic special keys from full key events.
///
/// Keyty keeps raw virtual key codes as physical identity, but some keys need
/// event-level semantic data to display correctly. For example, macOS uses the
/// legacy Help virtual key slot for many external keyboards' Insert key, while
/// AppKit can still expose separate Help and Insert function-key characters.
enum KeyboardSpecialKeyResolver {
    static func specialKey(for event: StandardKeyEvent) -> KeyboardSpecialKey? {
        if let semanticKey = self.semanticKey(from: event.charactersIgnoringModifiers)
            ?? self.semanticKey(from: event.characters) {
            return semanticKey
        }

        return self.specialKey(for: event.keyCode)
    }

    static func specialKey(for rawKeyCode: UInt16) -> KeyboardSpecialKey? {
        guard let keyCode = KeyboardKeyCode(rawValue: rawKeyCode) else {
            return nil
        }

        if let functionKey = KeyboardSpecialKey.functionRow(keyCode) {
            return functionKey
        }

        if let systemKey = KeyboardSpecialKey.SystemKey.key(for: keyCode) {
            return .system(systemKey)
        }

        switch keyCode {
        case .escape:        return .escape
        case .tab:           return .tab
        case .delete:        return .delete
        case .forwardDelete: return .forwardDelete
        case .returnKey:     return .returnKey
        case .keypadEnter:   return .keypadEnter
        case .space:         return .space
        case .help:          return .insert
        case .keypadClear:   return .keypadClear
        case .home:          return .home
        case .end:           return .end
        case .pageUp:        return .pageUp
        case .pageDown:      return .pageDown
        case .leftArrow:     return .leftArrow
        case .rightArrow:    return .rightArrow
        case .upArrow:       return .upArrow
        case .downArrow:     return .downArrow
        case .function:      return .function
        case .capsLock:      return .capsLock
        case .eisu:          return .eisu
        case .kana:          return .kana
        default:             return nil
        }
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
        case NSHomeFunctionKey:
            return .home
        case NSEndFunctionKey:
            return .end
        case NSPageUpFunctionKey:
            return .pageUp
        case NSPageDownFunctionKey:
            return .pageDown
        case NSLeftArrowFunctionKey:
            return .leftArrow
        case NSRightArrowFunctionKey:
            return .rightArrow
        case NSUpArrowFunctionKey:
            return .upArrow
        case NSDownArrowFunctionKey:
            return .downArrow
        default:
            return nil
        }
    }
}
