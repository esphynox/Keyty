//
//  NSScreen+ID.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

extension NSScreen {
    /// The `CGDirectDisplayID` backing this screen, or `0` if it cannot be resolved.
    var displayID: CGDirectDisplayID {
        self.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID ?? 0
    }
}
