//
//  AppServiceContainer.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

@MainActor
final class AppServiceContainer {
    let permissionsService: any PermissionsService
    let pointerVisualizersManager: PointerVisualizersManager
    let keyboardVisualizer: KeyboardVisualizer
    let shortcutManager: ShortcutManager
    let presenceManager: PresenceManager
    let captureController: CaptureController

    init(
        settings: AppSettingsContainer,
        dockItemController: DockItemController,
        statusShortcutItem: NSMenuItem
    ) {
        let pointerVisualizersManager = PointerVisualizersManager(
            pointerRingSettings: settings.pointerRingSettings,
            pointerIconSettings: settings.pointerIconSettings
        )
        let presenceManager = PresenceManager(
            dockItemController: dockItemController,
            settings: settings.presenceSettings
        )
        let keyboardVisualizer = KeyboardVisualizer(store: settings.store)
        keyboardVisualizer.activate()
        let permissionsService = SystemPermissionsService()
        let captureController = CaptureController(
            presenceManager: presenceManager,
            pointerVisualizersManager: pointerVisualizersManager,
            keyboardVisualizer: keyboardVisualizer,
            permissionsService: permissionsService
        )
        let shortcutManager = ShortcutManager(
            settings: settings.shortcutSettings,
            menuItemPresenter: ShortcutMenuItemPresenter(
                statusShortcutItem: statusShortcutItem,
                dockShortcutItem: dockItemController.shortcutItem
            ),
            onToggleCapturingShortcut: { [weak captureController] in
                captureController?.toggleCapturing()
            }
        )

        self.permissionsService = permissionsService
        self.pointerVisualizersManager = pointerVisualizersManager
        self.keyboardVisualizer = keyboardVisualizer
        self.shortcutManager = shortcutManager
        self.presenceManager = presenceManager
        self.captureController = captureController
    }
}
