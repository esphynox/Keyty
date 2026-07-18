//
//  MainMenu.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Sparkle

final class MenuController {
    private weak var appController: AppController?
    private weak var updaterController: SPUStandardUpdaterController?
    private var controlledMenuItems: [NSMenuItem] = []

    init(appController: AppController? = nil, updaterController: SPUStandardUpdaterController? = nil) {
        self.appController = appController
        self.updaterController = updaterController
    }

    func setAppController(_ appController: AppController) {
        self.appController = appController
        self.controlledMenuItems.forEach { $0.target = appController }
    }

    func makeMainMenu() -> NSMenu {
        let mainMenu = NSMenu()

        // App (Apple) menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu(title: AppConstants.appName)
        appMenuItem.submenu = appMenu
        let aboutItem = NSMenuItem(
            title: L10n.MainMenu.about(AppConstants.appName),
            action: #selector(AppController.orderFrontKeytyAboutPanel(_:)),
            keyEquivalent: ""
        )
        appMenu.addItem(self.register(aboutItem))
        appMenu.addItem(.separator())

        if let updaterController = self.updaterController {
            let updateItem = appMenu.addItem(
                withTitle: L10n.MainMenu.checkForUpdates,
                action: #selector(SPUStandardUpdaterController.checkForUpdates(_:)),
                keyEquivalent: ""
            )
            updateItem.target = updaterController
        }

        appMenu.addItem(self.makeSettingsMenuItem())
        appMenu.addItem(.separator())

        let servicesMenu = NSMenu(title: L10n.MainMenu.services)
        let servicesItem = NSMenuItem(title: L10n.MainMenu.services, action: nil, keyEquivalent: "")
        servicesItem.submenu = servicesMenu
        appMenu.addItem(servicesItem)
        NSApp.servicesMenu = servicesMenu

        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: L10n.MainMenu.hide(AppConstants.appName), action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")

        let hideOthers = appMenu.addItem(
            withTitle: L10n.MainMenu.hideOthers,
            action: #selector(NSApplication.hideOtherApplications(_:)),
            keyEquivalent: "h"
        )
        hideOthers.keyEquivalentModifierMask = [.command, .option]

        appMenu.addItem(withTitle: L10n.MainMenu.showAll, action: #selector(NSApplication.unhideAllApplications(_:)), keyEquivalent: "")
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: L10n.MainMenu.quit(AppConstants.appName), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        // File menu
        let fileMenuItem = NSMenuItem()
        mainMenu.addItem(fileMenuItem)
        let fileMenu = NSMenu(title: L10n.MainMenu.file)
        fileMenuItem.submenu = fileMenu
        fileMenu.addItem(withTitle: L10n.MainMenu.close, action: #selector(NSWindow.orderOut(_:)), keyEquivalent: "w")

        // Help menu
        let helpMenuItem = NSMenuItem()
        mainMenu.addItem(helpMenuItem)
        let helpMenu = NSMenu(title: L10n.MainMenu.help)
        helpMenuItem.submenu = helpMenu
        let feedbackItem = NSMenuItem(
            title: L10n.MainMenu.sendFeedback,
            action: #selector(AppController.sendFeedback(_:)),
            keyEquivalent: ""
        )
        helpMenu.addItem(self.register(feedbackItem))
        helpMenu.addItem(.separator())
        let githubItem = NSMenuItem(
            title: L10n.MainMenu.github,
            action: #selector(AppController.openGitHub(_:)),
            keyEquivalent: ""
        )
        helpMenu.addItem(self.register(githubItem))
        let websiteItem = NSMenuItem(
            title: L10n.MainMenu.website,
            action: #selector(AppController.openWebsite(_:)),
            keyEquivalent: ""
        )
        helpMenu.addItem(self.register(websiteItem))
        NSApp.helpMenu = helpMenu

        return mainMenu
    }

    func makeStatusShortcutMenuItem() -> NSMenuItem {
        self.makeShortcutMenuItem(action: #selector(AppController.toggleCapturing(_:)))
    }

    func makeDockShortcutMenuItem() -> NSMenuItem {
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

    func makeDockMenu(shortcutItem: NSMenuItem) -> NSMenu {
        let menu = NSMenu(title: AppConstants.appName)
        menu.addItem(shortcutItem)
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
