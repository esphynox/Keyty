//
//  NSImage+Assets.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

// MARK: - Helpers
extension NSImage {
    static func required(_ name: String) -> NSImage {
        guard let image = NSImage(named: name) else {
            preconditionFailure("Missing image asset: \(name)")
        }
        return image
    }
}
