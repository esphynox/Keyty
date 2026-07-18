//
//  NSImage+TemplateDrawing.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSImage {
    /// Draws the image as a template mask filled with `color`.
    ///
    /// PDF/vector image representations stay unresolved until this draw call, so callers can
    /// apply view transforms first without pre-rasterizing the icon at an intermediate size.
    func drawTemplate(in rect: NSRect, color: NSColor) {
        NSGraphicsContext.saveGraphicsState()
        defer { NSGraphicsContext.restoreGraphicsState() }

        if let cgContext = NSGraphicsContext.current?.cgContext {
            cgContext.beginTransparencyLayer(auxiliaryInfo: nil)
            NSBezierPath(rect: rect).setClip()
            self.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1.0)
            color.set()
            rect.fill(using: .sourceIn)
            cgContext.endTransparencyLayer()
        } else {
            self.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1.0)
        }
    }
}
