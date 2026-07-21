//
//  KeyboardKeyCode.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

/// Named physical keyboard key codes used by Keyty's keyboard semantics.
///
/// This is intentionally incomplete: unknown keys still flow through the app as
/// raw `UInt16` values, and code converts to this type only where semantics
/// matter.
enum KeyboardKeyCode: UInt16 {
    // MARK: - Letters & punctuation

    case a = 0x00
    case minus = 0x1B

    // MARK: - Whitespace & editing

    case returnKey = 0x24
    case tab = 0x30
    case space = 0x31
    case delete = 0x33
    case forwardDelete = 0x75
    case escape = 0x35

    // MARK: - Modifiers

    case commandRight = 0x36
    case commandLeft = 0x37
    case shiftLeft = 0x38
    case shiftRight = 0x3C
    case optionLeft = 0x3A
    case optionRight = 0x3D
    case controlLeft = 0x3B
    case controlRight = 0x3E
    case capsLock = 0x39
    case function = 0x3F

    // MARK: - Function keys

    case f1 = 0x7A
    case f2 = 0x78
    case f3 = 0x63
    case f4 = 0x76
    case f5 = 0x60
    case f6 = 0x61
    case f7 = 0x62
    case f8 = 0x64
    case f9 = 0x65
    case f10 = 0x6D
    case f11 = 0x67
    case f12 = 0x6F
    case f13 = 0x69
    case f14 = 0x6B
    case f15 = 0x71
    case f16 = 0x6A
    case f17 = 0x40
    case f18 = 0x4F
    case f19 = 0x50
    case f20 = 0x5A

    // MARK: - Keypad

    case keypad0 = 0x52
    case keypad1 = 0x53
    case keypad2 = 0x54
    case keypad3 = 0x55
    case keypad4 = 0x56
    case keypad5 = 0x57
    case keypad6 = 0x58
    case keypad7 = 0x59
    case keypad8 = 0x5B
    case keypad9 = 0x5C
    case keypadDecimal = 0x41
    case keypadMultiply = 0x43
    case keypadPlus = 0x45
    case keypadMinus = 0x4E
    case keypadDivide = 0x4B
    case keypadEquals = 0x51
    case keypadEnter = 0x4C
    case keypadClear = 0x47

    // MARK: - Navigation

    case home = 0x73
    case end = 0x77
    case pageUp = 0x74
    case pageDown = 0x79
    case leftArrow = 0x7B
    case rightArrow = 0x7C
    case downArrow = 0x7D
    case upArrow = 0x7E

    // MARK: - International (JIS)

    case yen = 0x5D
    case jISUnderscore = 0x5E
    case jISKeypadComma = 0x5F
    case eisu = 0x66
    case kana = 0x68

    // MARK: - System & media

    case help = 0x72
    case contextMenu = 0x6E
    case brightnessUp = 0x90
    case brightnessDown = 0x91
    case missionControl = 0xA0
    case launchpad = 0x83
    case spotlight = 0xB1
    case dictation = 0xB0
    case doNotDisturb = 0xB2
}

extension KeyboardKeyCode {
    /// Whether this key should be treated as a non-text "special key" in the keyboard overlay filter.
    var isSpecial: Bool {
        switch self {
        case .returnKey,
             .tab,
             .space,
             .delete,
             .forwardDelete,
             .escape,
             .capsLock,
             .function,
             .f1,
             .f2,
             .f3,
             .f4,
             .f5,
             .f6,
             .f7,
             .f8,
             .f9,
             .f10,
             .f11,
             .f12,
             .f13,
             .f14,
             .f15,
             .f16,
             .f17,
             .f18,
             .f19,
             .f20,
             .keypadEnter,
             .keypadClear,
             .home,
             .end,
             .pageUp,
             .pageDown,
             .leftArrow,
             .rightArrow,
             .downArrow,
             .upArrow,
             .eisu,
             .kana,
             .help,
             .contextMenu,
             .brightnessUp,
             .brightnessDown,
             .missionControl,
             .launchpad,
             .spotlight,
             .dictation,
             .doNotDisturb:
            return true
        default:
            return false
        }
    }
}

// MARK: - Display Helpers
extension KeyboardKeyCode {
    /// The word shown on the keycap for text keys (e.g. `fn`, `tab`), or `nil` for keys drawn as a glyph or character.
    var label: String? {
        switch self {
        case .function:                return "fn"
        case .tab:                     return "tab"
        case .escape:                  return "esc"
        case .delete:                  return "delete"
        case .forwardDelete:           return "delete"
        case .returnKey:               return "return"
        case .keypadEnter:             return "enter"
        case .capsLock:                return "caps lock"
        default:                       return nil
        }
    }

    /// The normalized display text for non-text keys.
    var displayText: String? {
        switch self {
        case .upArrow:
            return UnicodeToken.upArrow.string
        case .downArrow:
            return UnicodeToken.downArrow.string
        case .rightArrow:
            return UnicodeToken.rightArrow.string
        case .leftArrow:
            return UnicodeToken.leftArrow.string
        case .tab:
            return UnicodeToken.tab.string
        case .escape:
            return UnicodeToken.escape.string
        case .keypadClear:
            return UnicodeToken.keypadClear.string
        case .delete:
            return UnicodeToken.delete.string
        case .forwardDelete:
            return UnicodeToken.forwardDelete.string
        case .help:
            return UnicodeToken.questionMark.string + UnicodeToken.enclosingCircle.string
        case .home:
            return UnicodeToken.home.string
        case .end:
            return UnicodeToken.end.string
        case .pageUp:
            return UnicodeToken.pageUp.string
        case .pageDown:
            return UnicodeToken.pageDown.string
        case .returnKey:
            return UnicodeToken.returnKey.string
        case .keypadEnter:
            return UnicodeToken.keypadEnter.string
        case .brightnessDown:
            return UnicodeToken.brightnessDown.string
        case .brightnessUp:
            return UnicodeToken.brightnessUp.string
        case .missionControl:
            return UnicodeToken.missionControl.string
        case .launchpad:
            return UnicodeToken.launchpad.string
        case .spotlight:
            return UnicodeToken.spotlight.string
        case .dictation:
            return UnicodeToken.dictation.string
        case .doNotDisturb:
            return UnicodeToken.doNotDisturb.string
        case .space:
            return UnicodeToken.visibleSpace.string + UnicodeToken.zeroWidthSpace.string
        case .function:
            return label ?? ""
        case .f1:
            return Self.functionKeyLabel(1)
        case .f2:
            return Self.functionKeyLabel(2)
        case .f3:
            return Self.functionKeyLabel(3)
        case .f4:
            return Self.functionKeyLabel(4)
        case .f5:
            return Self.functionKeyLabel(5)
        case .f6:
            return Self.functionKeyLabel(6)
        case .f7:
            return Self.functionKeyLabel(7)
        case .f8:
            return Self.functionKeyLabel(8)
        case .f9:
            return Self.functionKeyLabel(9)
        case .f10:
            return Self.functionKeyLabel(10)
        case .f11:
            return Self.functionKeyLabel(11)
        case .f12:
            return Self.functionKeyLabel(12)
        case .f13:
            return Self.functionKeyLabel(13)
        case .f14:
            return Self.functionKeyLabel(14)
        case .f15:
            return Self.functionKeyLabel(15)
        case .f16:
            return Self.functionKeyLabel(16)
        case .f17:
            return Self.functionKeyLabel(17)
        case .f18:
            return Self.functionKeyLabel(18)
        case .f19:
            return Self.functionKeyLabel(19)
        case .f20:
            return Self.functionKeyLabel(20)
        case .eisu:
            return "英数"
        case .kana:
            return "かな"
        default:
            return nil
        }
    }

    private static func functionKeyLabel(_ number: Int) -> String {
        "F\(number)"
    }
}
