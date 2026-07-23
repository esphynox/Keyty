//
//  MainMenu.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

final class MenuController {
    private weak var appController: AppController?
    private var controlledMenuItems: [NSMenuItem] = []

    init(appController: AppController? = nil) {
        self.appController = appController
    }

    func setAppController(_ appController: AppController) {
        self.appController = appController
        self.controlledMenuItems.forEach { $0.target = appController }
    }

    func makeStatusShortcutMenuItem() -> NSMenuItem {
        self.makeShortcutMenuItem(action: #selector(AppController.toggleCapturing(_:)))
    }

    func makeStatusMenu(shortcutItem: NSMenuItem) -> NSMenu {
        let menu = NSMenu(title: AppConstants.appName)
        menu.addItem(shortcutItem)
        menu.addItem(self.makeSettingsMenuItem())
        let quit = NSMenuItem(title: L10n.MainMenu.quit(AppConstants.appName), action: #selector(AppController.quitApplication(_:)), keyEquivalent: "q")
        quit.keyEquivalentModifierMask = [.command]
        menu.addItem(self.register(quit))
        return menu
    }

    private func makeSettingsMenuItem() -> NSMenuItem {
        let item = NSMenuItem(
            title: L10n.MainMenu.settings,
            action: #selector(AppController.orderFrontKeytySettingsPanel(_:)),
            keyEquivalent: ","
        )
        return self.register(item)
    }

    private func makeShortcutMenuItem(action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: L10n.General.startCapturing, action: action, keyEquivalent: "S")
        item.keyEquivalentModifierMask = [.shift, .option]
        return self.register(item)
    }

    private func register(_ item: NSMenuItem) -> NSMenuItem {
        item.target = self.appController
        self.controlledMenuItems.append(item)
        return item
    }
}
