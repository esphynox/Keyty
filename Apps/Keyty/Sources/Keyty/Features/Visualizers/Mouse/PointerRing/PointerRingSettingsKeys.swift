//
//  PointerRingSettingsKeys.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

enum PointerRingSettingsKeys {
    static let isEnabled = "pointer_ring.isEnabled"
    static let alwaysVisible = "pointer_ring.alwaysVisible"
    static let color = "pointer_ring.color"
    static let size = "pointer_ring.size"
    static let thickness = "pointer_ring.thickness"
    static let shape = "pointer_ring.shape"
    
    static let defaultIsEnabled = false
    static let defaultAlwaysVisible = false
    static let defaultColor = automaticVisualizerColor.hexString
    static let defaultSize = CGFloat(75)
    static let defaultThickness = CGFloat(5)
    static let defaultShape = PointerRingShape.circle
    static let sizeRange: ClosedRange<CGFloat> = 24...96
    static let thicknessRange: ClosedRange<CGFloat> = 1...12

    static var automaticVisualizerColor: NSColor {
        return .controlAccentColor
    }
}
