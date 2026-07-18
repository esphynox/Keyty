//
//  KeyboardGlyphCatalog.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

/// Shared display glyphs used by keyboard visualizers.
///
/// This type is intentionally narrow:
/// - it maps known key names to the symbols we render on screen
/// - it exposes the common modifier glyphs in one place
///
/// It is not a key model, storage type, or event transformer.
enum KeyboardGlyphCatalog {
    static let command = KeyboardModifier.command.glyph
    static let shift = KeyboardModifier.shift.glyph
    static let option = KeyboardModifier.option.glyph
    static let control = KeyboardModifier.control.glyph
    
    static let tab = UnicodeToken.tab.string
    static let backTab = UnicodeToken.backTab.string

    /// Glyphs that can prefix a chord in display strings.
    static let modifierSymbols: [String] = KeyboardModifier.allCases.map(\.glyph)

    /// Physical key codes for left and right command, shift, option, and control keys.
    static let modifierKeyCodes: Set<KeyboardKeyCode> = Set(KeyboardModifier.allCases.flatMap(\.keyCodes))

    static func isModifierKeyCode(_ rawValue: UInt16) -> Bool {
        guard let keyCode = KeyboardKeyCode(rawValue: rawValue) else { return false }
        return modifierKeyCodes.contains(keyCode)
    }

    /// Returns the glyph we show for a typed keyboard key code when the key has a special visual representation.
    static func symbol(for keyCode: KeyboardKeyCode) -> String {
        switch keyCode {
        case .escape:
            return UnicodeToken.escape.string
        case .delete, .forwardDelete:
            return UnicodeToken.delete.string
        case .returnKey, .keypadEnter:
            return UnicodeToken.returnKey.string
        case .tab:
            return tab
        case .space:
            return UnicodeToken.visibleSpace.string
        default:
            preconditionFailure("No special glyph mapping defined for \(keyCode)")
        }
    }

    /// Returns the normalized display symbol we show for fallback display text.
    static func displaySymbol(for text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        switch trimmed.uppercased() {
        case "ESC":
            return UnicodeToken.escape.string
        case "DELETE", "BACKSPACE":
            return UnicodeToken.delete.string
        case "RETURN", "ENTER":
            return UnicodeToken.returnKey.string
        case "TAB":
            return tab
        case "SPACE":
            return UnicodeToken.visibleSpace.string
        default:
            return trimmed.uppercased()
        }
    }
}
