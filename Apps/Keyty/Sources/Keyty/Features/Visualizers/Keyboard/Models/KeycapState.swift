//
//  KeycapState.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

/// Transient runtime state for a keycap.
struct KeycapState {
    let isPressed: Bool
    let showsDot: Bool
    let isDotActive: Bool

    init(
        isPressed: Bool,
        showsDot: Bool = false,
        isDotActive: Bool = true
    ) {
        self.isPressed = isPressed
        self.showsDot = showsDot
        self.isDotActive = isDotActive
    }
}
