//
//  CaptureController+State.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

extension CaptureController {
    /// Current capture lifecycle state derived from user intent and permission status.
    enum State {
        case idle
        case waitingForPermission
        case capturing
        case blockedByPermission
        case blockedByTapFailure
    }
}
