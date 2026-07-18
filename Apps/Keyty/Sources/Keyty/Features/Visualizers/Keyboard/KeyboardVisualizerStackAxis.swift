//
//  KeyboardVisualizerStackAxis.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

/// The axis the keycaps visualizer uses to stack groups.
///
/// The persisted setting historically stored four directional values
/// (`up/down/left/right`). Existing installs still read through
/// `init(storedValue:)`, which collapses those values to a vertical or
/// horizontal stack.
enum KeyboardVisualizerStackAxis: Int {
    case vertical = 0
    case horizontal = 1

    var storedValue: Int {
        switch self {
        case .vertical:
            return 0
        case .horizontal:
            return 2
        }
    }

    init(storedValue: Int) {
        switch storedValue {
        case 2, 3:
            self = .horizontal
        default:
            self = .vertical
        }
    }
}
