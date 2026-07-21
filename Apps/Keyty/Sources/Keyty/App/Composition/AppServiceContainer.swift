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
        dockItemController: DockItemController
    ) {
        let pointerVisualizersManager = PointerVisualizersManager(
            pointerRingSettings: settings.pointerRingSettings,
            pointerIconSettings: settings.pointerIconSettings
        )
        let shortcutManager = ShortcutManager(settings: settings.shortcutSettings)
        let presenceManager = PresenceManager(
            dockItemController: dockItemController,
            settings: settings.presenceSettings
        )
        let keyboardVisualizer = KeyboardVisualizer(store: settings.store)
        keyboardVisualizer.activate()
        let permissionsService = SystemPermissionsService()

        self.permissionsService = permissionsService
        self.pointerVisualizersManager = pointerVisualizersManager
        self.keyboardVisualizer = keyboardVisualizer
        self.shortcutManager = shortcutManager
        self.presenceManager = presenceManager
        let captureController = CaptureController(
            presenceManager: presenceManager,
            pointerVisualizersManager: pointerVisualizersManager,
            keyboardVisualizer: keyboardVisualizer,
            permissionsService: permissionsService
        )
        shortcutManager.onToggleCapturingShortcut = { [weak captureController] in
            captureController?.toggleCapturing()
        }
        self.captureController = captureController
    }
}
