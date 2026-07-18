//
//  NSColor+SwatchImage.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSColor {
    func swatchImage(diameter: CGFloat = 16, trailingPadding: CGFloat = 0) -> NSImage {
        let size = NSSize(width: diameter + trailingPadding, height: diameter)
        let image = NSImage(size: size)
        image.lockFocus()
        setFill()
        NSBezierPath(ovalIn: NSRect(origin: .zero, size: NSSize(width: diameter, height: diameter))).fill()
        image.unlockFocus()
        image.isTemplate = false
        return image
    }
}
