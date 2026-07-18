//
//  EventTap+DisableReason.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

extension EventTap {
    enum DisableReason: Equatable {
        /// The system disabled the tap because the callback stopped responding quickly enough.
        case timeout

        /// The system disabled the tap after user input re-enabled secure or direct input handling.
        case userInput
    }
}
