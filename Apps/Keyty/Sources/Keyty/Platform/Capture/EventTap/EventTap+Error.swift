//
//  EventTap+Error.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Cocoa

extension EventTap {
    enum Error: LocalizedError, Equatable {
        case keyTapCreationFailed
        case mouseAndFlagsTapCreationFailed

        var errorDescription: String? {
            switch self {
            case .keyTapCreationFailed:
                return NSLocalizedString(
                    "Could not create key event tap. Accessibility permission is required.",
                    comment: "Shown when the key event tap cannot be installed"
                )
            case .mouseAndFlagsTapCreationFailed:
                return NSLocalizedString(
                    "Could not create mouse and modifiers event tap.",
                    comment: "Shown when the mouse/flags event tap cannot be installed"
                )
            }
        }
    }
}
