//
//  CGEventType+SystemDefined.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Cocoa

public extension CGEventType {
    /// Quartz event type for `NX_SYSDEFINED` events, which includes media-key input.
    /// Apple does not expose this value as a named `CGEventType` case.
    static let systemDefined = CGEventType(rawValue: UInt32(NX_SYSDEFINED))!
}
