//
//  PointerRingShape.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

enum PointerRingShape: String, CaseIterable {
    case circle
    case rhomb
    case squircle
}

extension PointerRingShape: Identifiable {
    var id: String { self.rawValue }
}

extension PointerRingShape {
    var label: String {
        switch self {
        case .circle:
            return L10n.Mouse.Shape.circle
        case .rhomb:
            return L10n.Mouse.Shape.rhomb
        case .squircle:
            return L10n.Mouse.Shape.squircle
        }
    }
}
