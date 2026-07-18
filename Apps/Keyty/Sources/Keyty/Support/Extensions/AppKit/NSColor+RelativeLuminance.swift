//
//  NSColor+RelativeLuminance.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSColor {
    var relativeLuminance: CGFloat {
        let rgbColor = usingColorSpace(.deviceRGB) ?? self
        return (0.2126 * rgbColor.redComponent)
            + (0.7152 * rgbColor.greenComponent)
            + (0.0722 * rgbColor.blueComponent)
    }
}
