//
//  StatusItemController.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

final class StatusItemController {
    private let menu: NSMenu
    private let shortcutItem: NSMenuItem
    private var statusItem: NSStatusItem?

    private var statusItemImage: NSImage {
        let image = self.isCapturing ? NSImage.statusItemEnabled : NSImage.statusItemDisabled
        image.isTemplate = true
        return image
    }

    init(menu: NSMenu, shortcutItem: NSMenuItem) {
        self.menu = menu
        self.shortcutItem = shortcutItem
    }

    var isCapturing: Bool = false {
        didSet {
            self.shortcutItem.title = isCapturing ? L10n.General.stopCapturing : L10n.General.startCapturing
            self.statusItem?.button?.image = self.statusItemImage
        }
    }

    var isVisible: Bool = false {
        didSet {
            guard self.isVisible != oldValue else { return }
            self.isVisible ? self.createStatusItem() : self.deleteStatusItem()
        }
    }

    private func createStatusItem() {
        guard self.statusItem == nil else { return }
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.menu = self.menu
        item.button?.image = self.statusItemImage
        item.button?.cell?.isHighlighted = true
        self.statusItem = item
    }

    private func deleteStatusItem() {
        guard let item = self.statusItem else { return }
        NSStatusBar.system.removeStatusItem(item)
        self.statusItem = nil
    }
}
