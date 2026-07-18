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
    case modifier(KeyboardModifier)
    case keyCode(UInt16)
    case media(MediaKeyEvent.Kind)
    case mouse(MouseEvent.Kind)

    var isModifier: Bool {
        if case .modifier = self { return true }
        return false
    }
}
