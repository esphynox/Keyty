//
//  CaptureController+TapState.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

extension CaptureController {
    enum TapState {
        case idle
        case active
        case recovering
        case failed
    }
}
