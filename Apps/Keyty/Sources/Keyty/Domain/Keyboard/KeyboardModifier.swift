//
//  KeyboardModifier.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

enum KeyboardModifier: CaseIterable {
    case command
    case shift
    case option
    case control

    var glyph: String {
        switch self {
        case .command: return UnicodeToken.command.string
        case .shift:   return UnicodeToken.shift.string
        case .option:  return UnicodeToken.option.string
        case .control: return UnicodeToken.control.string
        }
    }

    var label: String {
        switch self {
        case .command: return "command"
        case .shift:   return "shift"
        case .option:  return "option"
        case .control: return "control"
        }
    }

    /// Physical key codes for the left and right keys for this modifier.
    var keyCodes: Set<KeyboardKeyCode> {
        switch self {
        case .command: return [.commandLeft, .commandRight]
        case .shift:   return [.shiftLeft, .shiftRight]
        case .option:  return [.optionLeft, .optionRight]
        case .control: return [.controlLeft, .controlRight]
        }
    }
}
