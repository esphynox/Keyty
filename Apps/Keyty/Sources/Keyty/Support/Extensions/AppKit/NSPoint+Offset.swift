//
//  NSPoint+Offset.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

public extension NSPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> NSPoint {
        NSPoint(x: x + dx, y: y + dy)
    }
}
