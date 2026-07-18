//
//  KeycapCategory.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

/// Semantic key-type bucket used to pick a per-type theme for a keycap.
///
/// Derived from `KeycapIdentity` so the mapping lives in one place and every
/// `KeycapItemFactory` branch lands in the right bucket automatically.
enum KeycapCategory: CaseIterable {
    case regular
    case modifier
    case special
    case media
    case mouse

    init(identity: KeycapIdentity) {
        switch identity {
        case .modifier:
            self = .modifier
        case .media:
            self = .media
        case .mouse:
            self = .mouse
        case let .keyCode(code):
            // `fn` is emitted as a keyCode from the modifier path and is shown beside the
            // modifiers, so it follows the modifier theme rather than the special theme.
            if code == KeyboardKeyCode.function.rawValue {
                self = .modifier
            } else if KeyboardKeyCode(rawValue: code)?.isSpecial == true {
                self = .special
            } else {
                self = .regular
            }
        }
    }
}
