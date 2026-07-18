//
//  NSGradient+DarkestColor.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSGradient {
    var darkestColor: NSColor {
        var darkestColor = NSColor.black
        var darkestLuminance = CGFloat.greatestFiniteMagnitude

        for index in 0..<numberOfColorStops {
            var color = NSColor.black
            var location = CGFloat(0)
            getColor(&color, location: &location, at: index)

            let luminance = color.relativeLuminance
            if luminance < darkestLuminance {
                darkestLuminance = luminance
                darkestColor = color
            }
        }

        return darkestColor
    }
}
