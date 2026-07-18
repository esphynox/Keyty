//
//  UCKeyboardLayout+TranslatedKeyCode.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Carbon
import Foundation

extension UnsafePointer<UCKeyboardLayout> {
    func translatedKeyCode(_ keyCode: UInt16) -> String {
        let maxLength = 4
        var length = 0
        var unicodeString = [UniChar](repeating: 0, count: maxLength)
        var deadKeyState: UInt32 = 0

        UCKeyTranslate(
            self,
            keyCode,
            UInt16(kUCKeyActionDisplay),
            0,
            UInt32(LMGetKbdType()),
            OptionBits(kUCKeyTranslateNoDeadKeysBit),
            &deadKeyState,
            maxLength,
            &length,
            &unicodeString
        )

        return String(utf16CodeUnits: unicodeString, count: length)
    }
}
