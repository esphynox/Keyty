//
//  AppUIContainer.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Sparkle

@MainActor
final class AppUIContainer {
    let aboutWindowController: AboutWindowController
    let permissionsOnboardingWindowController: PermissionsOnboardingWindowController
    let settingsWindowController: SettingsWindowController

    init(
        settings: AppSettingsContainer,
        services: AppServiceContainer,
        updater: SPUUpdater
    ) {
        aboutWindowController = AboutWindowController()
        permissionsOnboardingWindowController = PermissionsOnboardingWindowController(
            permissionsService: services.permissionsService
        )
        settingsWindowController = SettingsWindowController(
            shortcutManager: services.shortcutManager,
            appSettings: settings.appSettings,
            pointerRingVisualizer: services.pointerVisualizersManager.ring,
            pointerRingSettings: settings.pointerRingSettings,
            pointerIconSettings: settings.pointerIconSettings,
            keyboardVisualizerSettings: settings.keyboardVisualizerSettings,
            permissionsService: services.permissionsService,
            updater: updater
        )
    }
}
