//
//  KeyboardSpecialKey+SystemKey.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

extension KeyboardSpecialKey {
    /// Hardware or OS-level keys that do not map to ordinary text input.
    enum SystemKey {
        case contextMenu
        case brightnessUp
        case brightnessDown
        case missionControl
        case launchpad
        case spotlight
        case dictation
        case doNotDisturb
    }
}

extension KeyboardSpecialKey.SystemKey {
    /// Text rendered inside the keycap for this system key.
    ///
    /// System keys are represented by platform glyphs when available, and by a
    /// compact readable name when no suitable glyph exists.
    var displayText: String {
        switch self {
        case .contextMenu:
            return UnicodeToken.contextMenu.string
        case .brightnessUp:
            return UnicodeToken.brightnessUp.string
        case .brightnessDown:
            return UnicodeToken.brightnessDown.string
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
        }
    }

    static func key(for keyCode: KeyboardKeyCode) -> KeyboardSpecialKey.SystemKey? {
        switch keyCode {
        case .contextMenu:    return .contextMenu
        case .brightnessUp:   return .brightnessUp
        case .brightnessDown: return .brightnessDown
        case .missionControl: return .missionControl
        case .launchpad:      return .launchpad
        case .spotlight:      return .spotlight
        case .dictation:      return .dictation
        case .doNotDisturb:   return .doNotDisturb
        default:              return nil
        }
    }
}
