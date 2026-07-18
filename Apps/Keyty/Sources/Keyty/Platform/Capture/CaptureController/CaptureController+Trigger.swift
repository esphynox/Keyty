//
//  CaptureController+Trigger.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

extension CaptureController {
    /// Events that drive capture lifecycle transitions.
    enum Trigger {
        case appStarted
        case userEnabledCapture
        case userDisabledCapture
        case permissionChanged
    }
}
