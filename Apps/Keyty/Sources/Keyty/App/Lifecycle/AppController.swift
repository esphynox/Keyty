//
//  AppController.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import AppMover
import Sparkle

@MainActor
final class AppController: NSObject {
    private let menuController: MenuController
    private let dockItemController: DockItemController
    private let statusItemController: StatusItemController
    private let dependencies: AppDependencies
    private let updaterController: SPUStandardUpdaterController

    override init() {
        self.updaterController = SPUStandardUpdaterController(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
        self.menuController = MenuController(updaterController: self.updaterController)
        let statusShortcutItem = self.menuController.makeStatusShortcutMenuItem()
        let dockShortcutItem = self.menuController.makeDockShortcutMenuItem()
        self.dockItemController = DockItemController(
            menu: self.menuController.makeDockMenu(shortcutItem: dockShortcutItem),
            shortcutItem: dockShortcutItem
        )
        self.statusItemController = StatusItemController(
            menu: self.menuController.makeStatusMenu(shortcutItem: statusShortcutItem),
            shortcutItem: statusShortcutItem
        )
        self.dependencies = AppDependencies(
            dockItemController: self.dockItemController,
            statusShortcutItem: statusShortcutItem,
            updater: self.updaterController.updater
        )
        super.init()
        self.menuController.setAppController(self)
        self.dependencies.presenceManager.onMenuBarVisibilityChanged = { [weak self] isVisible in
            self?.statusItemController.isVisible = isVisible
        }
        self.dependencies.captureController.onCapturingChanged = { [weak self] isCapturing in
            self?.statusItemController.isCapturing = isCapturing
        }
        self.dependencies.presenceManager.settingsWindow = self.dependencies.settingsWindowController.window
    }
}

// MARK: - NSApplicationDelegate
extension AppController: NSApplicationDelegate {
    func applicationDockMenu(_ sender: NSApplication) -> NSMenu? {
        guard ProcessEnvironment.isRunningApp else {
            return nil
        }

        return self.dockItemController.menu
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        guard ProcessEnvironment.isRunningApp else {
            return
        }

        NSApp.mainMenu = self.menuController.makeMainMenu()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard ProcessEnvironment.isRunningApp else {
            return
        }

        NSApp.activate(ignoringOtherApps: true)

        #if !DEBUG
        if AppMover.moveIfNecessary() {
            return
        }
        #endif

        self.dependencies.captureController.start()

        if self.dependencies.permissionsOnboardingWindowController.needsOnboarding {
            self.dependencies.permissionsOnboardingWindowController.onCompletion = { [weak self] in
                guard let self else { return }
                self.dependencies.permissionsOnboardingWindowController.close()
                self.dependencies.captureController.start()
                self.showSettingsWindow(self)
            }
            self.dependencies.permissionsOnboardingWindowController.showWindow(self)
            return
        }

        self.checkForUpdatesAtLaunchIfNeeded()
        self.showSettingsAtLaunchIfNeeded()
    }

    func applicationWillTerminate(_ notification: Notification) {
        guard ProcessEnvironment.isRunningApp else {
            return
        }

        self.dependencies.captureController.stopCapturing()
    }
}

// MARK: - Settings Presentation
private extension AppController {
    func checkForUpdatesAtLaunchIfNeeded() {
        guard self.updaterController.updater.automaticallyChecksForUpdates else { return }
        self.updaterController.updater.checkForUpdatesInBackground()
    }

    func showSettingsAtLaunchIfNeeded() {
        guard self.dependencies.appSettings.visibleAtLaunch else { return }
        self.showSettingsWindow(self)
    }

    func showSettingsWindow(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        self.dependencies.settingsWindowController.window?.center()
        self.dependencies.settingsWindowController.showWindow(sender)
    }
}

// MARK: - Action
extension AppController {
    @objc
    func orderFrontKeytyAboutPanel(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        self.dependencies.aboutWindowController.window?.center()
        self.dependencies.aboutWindowController.showWindow(sender)
    }

    @objc
    func orderFrontKeytySettingsPanel(_ sender: Any?) {
        self.showSettingsWindow(sender)
    }

    @objc
    func toggleCapturing(_ sender: Any?) {
        self.dependencies.captureController.toggleCapturing()
    }

    @objc
    func quitApplication(_ sender: Any?) {
        NSApp.terminate(sender)
    }

    @objc
    func sendFeedback(_ sender: Any?) {
        NSWorkspace.shared.open(AppConstants.feedbackURL)
    }

    @objc
    func openGitHub(_ sender: Any?) {
        NSWorkspace.shared.open(AppConstants.githubURL)
    }

    @objc
    func openWebsite(_ sender: Any?) {
        NSWorkspace.shared.open(AppConstants.websiteURL)
    }
}
