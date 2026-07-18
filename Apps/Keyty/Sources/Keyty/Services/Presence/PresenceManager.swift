//
//  PresenceManager.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Cocoa
import Combine

final class PresenceManager {
    private let dockItemController: DockItemController
    private let settings: any PresenceSettingsProtocol & ReactiveSettings
    private var cancellables = Set<AnyCancellable>()
    var onMenuBarVisibilityChanged: ((Bool) -> Void)?

    weak var settingsWindow: NSWindow?

    var isCapturing: Bool = false {
        didSet {
            self.dockItemController.isCapturing = self.isCapturing
        }
    }

    var displayIconLocation: DisplayIconLocation {
        get { self.settings.displayIconLocation }
        set { self.settings.displayIconLocation = newValue }
    }

    var displayIconLocationRawValue: Int {
        get { self.displayIconLocation.rawValue }
        set { self.displayIconLocation = DisplayIconLocation(rawValue: newValue) ?? .menuBarAndDock }
    }

    init(
        dockItemController: DockItemController,
        settings: any PresenceSettingsProtocol & ReactiveSettings = PresenceSettings()
    ) {
        self.dockItemController = dockItemController
        self.settings = settings
        self.settings.changes
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                self?.displayIconLocationUpdated()
            }
            .store(in: &self.cancellables)
        self.displayIconLocationUpdated()
    }

    private func displayIconLocationUpdated() {
        let shouldRestoreSettingsFocus = !self.displayIconLocation.showsInDock && (self.settingsWindow?.isKeyWindow ?? false)

        if !self.displayIconLocation.showsInDock {
            self.settingsWindow?.canHide = false
        }
        self.dockItemController.isVisible = self.displayIconLocation.showsInDock
        self.onMenuBarVisibilityChanged?(self.displayIconLocation.showsInMenuBar)

        if shouldRestoreSettingsFocus {
            DispatchQueue.main.async { [weak self] in
                guard let settingsWindow = self?.settingsWindow else { return }
                NSApp.activate(ignoringOtherApps: true)
                settingsWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
}
