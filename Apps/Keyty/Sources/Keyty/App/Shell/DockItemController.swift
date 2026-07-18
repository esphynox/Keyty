//
//  DockItemController.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

final class DockItemController {
    let menu: NSMenu
    let shortcutItem: NSMenuItem

    init(menu: NSMenu, shortcutItem: NSMenuItem) {
        self.menu = menu
        self.shortcutItem = shortcutItem
    }

    var isCapturing: Bool = false {
        didSet {
            self.shortcutItem.title = self.isCapturing ? L10n.General.stopCapturing : L10n.General.startCapturing
        }
    }

    var isVisible: Bool = false {
        didSet {
            NSApp.setActivationPolicy(isVisible ? .regular : .accessory)
        }
    }
}
