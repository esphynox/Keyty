//
//  KeycapIdentity.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

/// Stable semantic identity for a rendered keycap.
///
/// This answers "what real input does this keycap represent?" and is used for
/// semantics-driven behavior such as grouping, width rules, and per-key-type styling.
enum KeycapIdentity: Hashable {
    case modifier(KeyboardModifierKey)
    case keyCode(UInt16)
    case media(MediaKeyEvent.Kind)
    case mouse(MouseEvent.Kind)

    var isModifier: Bool {
        switch self {
        case .modifier:
            return true
        case .keyCode, .media, .mouse:
            return false
        }
    }

    var modifierKind: KeyboardModifierKey.Kind? {
        switch self {
        case let .modifier(key):
            return key.kind
        case .keyCode, .media, .mouse:
            return nil
        }
    }

    var modifierLocation: KeyboardModifierKey.Location? {
        switch self {
        case let .modifier(key):
            return key.location
        case .keyCode, .media, .mouse:
            return nil
        }
    }
}
