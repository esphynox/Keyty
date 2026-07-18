//
//  Color+NSColor.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

extension Color {
    init(appKitColor color: NSColor) {
        if #available(macOS 12.0, *) {
            self = Color(nsColor: color)
            return
        }

        let sRGBColor = color.usingColorSpace(.sRGB) ?? color
        self = Color(
            .sRGB,
            red: Double(sRGBColor.redComponent),
            green: Double(sRGBColor.greenComponent),
            blue: Double(sRGBColor.blueComponent),
            opacity: Double(sRGBColor.alphaComponent)
        )
    }
}
