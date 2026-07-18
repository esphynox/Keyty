//
//  AppSettingsContainer.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation

final class AppSettingsContainer {
    let store: KeyValueStore
    let appSettings: any AppSettingsProtocol
    let pointerRingSettings: any PointerRingSettingsProtocol & ReactiveSettings
    let pointerIconSettings: any PointerIconSettingsProtocol & ReactiveSettings
    let presenceSettings: any PresenceSettingsProtocol & ReactiveSettings
    let shortcutSettings: any ShortcutSettingsProtocol
    let keyboardVisualizerSettings: KeyboardVisualizerSettings

    init(store: KeyValueStore) {
        self.store = store

        self.appSettings = AppSettings(store: store)
        self.pointerRingSettings = PointerRingSettings(store: store)
        self.pointerIconSettings = PointerIconSettings(store: store)
        self.presenceSettings = PresenceSettings(store: store)
        self.shortcutSettings = ShortcutSettings(store: store)
        self.keyboardVisualizerSettings = KeyboardVisualizerSettings(store: store)
        
        self.registerDefaults()
    }

    private func registerDefaults() {
        self.appSettings.registerDefaults()
        self.pointerRingSettings.registerDefaults()
        self.pointerIconSettings.registerDefaults()
        self.presenceSettings.registerDefaults()
        self.shortcutSettings.registerDefaults()
        self.keyboardVisualizerSettings.registerDefaults()
    }
}
