//
//  DisplayIconLocation.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

enum DisplayIconLocation: Int {
    case menuBar = 1
    case dock = 2
    case menuBarAndDock = 3

    var showsInDock: Bool {
        self == .dock || self == .menuBarAndDock
    }

    var showsInMenuBar: Bool {
        self == .menuBar || self == .menuBarAndDock
    }
}
