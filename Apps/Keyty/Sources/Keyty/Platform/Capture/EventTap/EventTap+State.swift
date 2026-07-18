//
//  EventTap+State.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

extension EventTap {
    enum State: Equatable {
        case idle
        case installed
        case temporarilyDisabled(EventTap.DisableReason)
        case failed(EventTap.Error)
    }
}
