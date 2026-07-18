//
//  NSColor+Blend.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSColor {
    /// Blends `fraction` (0...1) of white into the color.
    func lightened(by fraction: CGFloat) -> NSColor {
        blended(withFraction: fraction, of: .white) ?? self
    }

    /// Blends `fraction` (0...1) of black into the color.
    func darkened(by fraction: CGFloat) -> NSColor {
        blended(withFraction: fraction, of: .black) ?? self
    }
}
