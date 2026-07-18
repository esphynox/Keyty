//
//  SymbolImage.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

/// Builds tinted images and inline text attachments from SF Symbols, so the
/// attributed-string visualizers can render symbols the same way they already
/// render the mouse icons.
enum SymbolImage {
    /// A tinted SF Symbol image, or `nil` if the symbol is unavailable.
    static func image(named name: String, color: NSColor, pointSize: CGFloat, weight: NSFont.Weight = .regular) -> NSImage? {
        guard #available(macOS 11.0, *),
              let base = NSImage(systemSymbolName: name, accessibilityDescription: nil) else {
            return nil
        }
        var config = NSImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        if #available(macOS 12.0, *) {
            config = config.applying(NSImage.SymbolConfiguration(paletteColors: [color]))
            return base.withSymbolConfiguration(config)
        }

        guard let image = base.withSymbolConfiguration(config) else {
            return nil
        }

        return image.tinted(with: color)
    }

    /// An inline attachment wrapping the symbol, sized and baseline-aligned to
    /// `font` so it renders correctly in a layout manager (matching how
    /// `MouseEvent` lays out its icons).
    static func attributedString(named name: String, color: NSColor, font: NSFont) -> NSAttributedString? {
        guard let image = image(named: name, color: color, pointSize: font.pointSize) else {
            return nil
        }
        let targetHeight = font.ascender + (-font.descender)
        let aspect = image.size.height == 0 ? 1 : image.size.width / image.size.height
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = NSRect(x: 0, y: font.descender, width: targetHeight * aspect, height: targetHeight)
        return NSAttributedString(attachment: attachment)
    }
}
