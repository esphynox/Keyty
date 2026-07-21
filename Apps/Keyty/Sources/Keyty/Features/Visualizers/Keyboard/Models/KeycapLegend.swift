//
//  KeycapLegend.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

/// Visual content rendered inside a keycap.
///
/// This answers "what should be drawn?" independently from semantic identity.
struct KeycapLegend {
    let symbol: String
    let image: NSImage?
    let imageBadgeText: String?
    let sfSymbolName: String?
    let label: String?
    let rendersSymbolWithLabel: Bool

    init(
        symbol: String = "",
        image: NSImage? = nil,
        imageBadgeText: String? = nil,
        sfSymbolName: String? = nil,
        label: String? = nil,
        rendersSymbolWithLabel: Bool = false
    ) {
        self.symbol = symbol
        self.image = image
        self.imageBadgeText = imageBadgeText
        self.sfSymbolName = sfSymbolName
        self.label = label
        self.rendersSymbolWithLabel = rendersSymbolWithLabel
    }
}

// MARK: - Helpers
extension KeycapLegend {
    static func modifier(_ modifier: KeyboardModifierKey.Kind) -> KeycapLegend {
        KeycapLegend(symbol: modifier.glyph, label: modifier.label)
    }
    
    static func character(_ symbol: String) -> KeycapLegend {
        KeycapLegend(symbol: symbol)
    }
}

// MARK: - Instances
extension KeycapLegend {
    static let function = KeycapLegend(sfSymbolName: "globe", label: KeyboardKeyCode.function.label, rendersSymbolWithLabel: true)
    static let tab = KeycapLegend(symbol: KeyboardGlyphCatalog.tab, label: KeyboardKeyCode.tab.label)
    static let escape = KeycapLegend(symbol: KeyboardGlyphCatalog.symbol(for: .escape), label: KeyboardKeyCode.escape.label)
    static let delete = KeycapLegend(symbol: KeyboardGlyphCatalog.symbol(for: .delete), label: KeyboardKeyCode.delete.label)
    static let `return` = KeycapLegend(symbol: KeyboardGlyphCatalog.symbol(for: .returnKey), label: KeyboardKeyCode.returnKey.label)
    static let enter = KeycapLegend(symbol: KeyboardGlyphCatalog.symbol(for: .keypadEnter), label: KeyboardKeyCode.keypadEnter.label)
    static let space = KeycapLegend(symbol: KeyboardGlyphCatalog.symbol(for: .space))
    static let capsLock = KeycapLegend(label: KeyboardKeyCode.capsLock.label)
}
