//
//  Spacing.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import CoreGraphics

enum Spacing {
    static let none = CGFloat(0)
    static let unit = CGFloat(4)

    static let xxs = grid(1)
    static let xs = grid(2)
    static let sm = grid(3)
    static let md = grid(4)
    static let lg = grid(6)
    static let xl = grid(8)
    static let xxl = grid(12)

    static func grid(_ steps: Int) -> CGFloat {
        CGFloat(steps) * unit
    }
}
