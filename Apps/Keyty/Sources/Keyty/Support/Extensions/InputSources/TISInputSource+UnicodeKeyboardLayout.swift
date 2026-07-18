//
//  TISInputSource+UnicodeKeyboardLayout.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Carbon
import Foundation

extension TISInputSource {
    var unicodeKeyboardLayout: UnsafePointer<UCKeyboardLayout> {
        let layoutData = TISGetInputSourceProperty(self, kTISPropertyUnicodeKeyLayoutData)
        let data = unsafeBitCast(layoutData, to: CFData.self)
        return unsafeBitCast(CFDataGetBytePtr(data), to: UnsafePointer<UCKeyboardLayout>.self)
    }
}
