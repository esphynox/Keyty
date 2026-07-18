//
//  NSImage+Tint.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSImage {
    func tinted(with color: NSColor, size: NSSize? = nil) -> NSImage {
        let canvasSize = size ?? self.size
        let tinted = NSImage(size: canvasSize)
        tinted.lockFocus()
        draw(
            in: NSRect(origin: .zero, size: canvasSize),
            from: .zero,
            operation: .sourceOver,
            fraction: 1.0
        )
        color.set()
        NSRect(origin: .zero, size: canvasSize).fill(using: .sourceAtop)
        tinted.unlockFocus()
        return tinted
    }
}
