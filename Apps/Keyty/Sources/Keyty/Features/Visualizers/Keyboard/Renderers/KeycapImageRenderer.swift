//
//  KeycapImageRenderer.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

enum KeycapImageRenderer {
    static func draw(image: NSImage, badgeText: String?, color: NSColor, in rect: NSRect) {
        image.drawTemplate(in: rect, color: color)

        guard let badgeText else { return }
        self.drawBadge(text: badgeText, color: color, in: rect)
    }

    private static func drawBadge(text: String, color: NSColor, in rect: NSRect) {
        let fontSize = rect.height * 0.26
        let font = NSFont.boldSystemFont(ofSize: fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
        ]
        let labelSize = text.size(withAttributes: attributes)
        let naturalHeight = labelSize.height + fontSize * 0.20
        let badgeWidth = max(labelSize.width + fontSize * 0.68, naturalHeight)

        text.draw(
            in: NSRect(
                x: rect.midX - badgeWidth / 2,
                y: rect.minY + rect.height * 0.16 + (naturalHeight - labelSize.height) / 2,
                width: badgeWidth,
                height: labelSize.height
            ),
            withAttributes: attributes
        )
    }
}
