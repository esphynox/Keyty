//
//  PointerIconAnchor.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

enum PointerIconAnchor: Int, CaseIterable {
    case bottomRight = 0
    case bottomLeft  = 1
    case topRight    = 2
    case topLeft     = 3

    var label: String {
        switch self {
        case .bottomRight:
            "\(L10n.Anchor.bottom) \(L10n.Anchor.right)"
        case .bottomLeft:
            "\(L10n.Anchor.bottom) \(L10n.Anchor.left)"
        case .topRight:
            "\(L10n.Anchor.top) \(L10n.Anchor.right)"
        case .topLeft:
            "\(L10n.Anchor.top) \(L10n.Anchor.left)"
        }
    }
}
