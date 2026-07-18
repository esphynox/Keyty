//
//  GeneralSettingsPaneViewModel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

final class GeneralSettingsPaneViewModel: ObservableObject {
    let shortcutManager: ShortcutManager

    private let presenceManager: PresenceManager
    private let appSettings: any AppSettingsProtocol

    @Published var displayIconLocation: Int {
        didSet { self.presenceManager.displayIconLocationRawValue = self.displayIconLocation }
    }

    @Published var visibleAtLaunch: Bool {
        didSet { self.appSettings.visibleAtLaunch = self.visibleAtLaunch }
    }

    init(shortcutManager: ShortcutManager, presenceManager: PresenceManager, appSettings: any AppSettingsProtocol) {
        self.shortcutManager = shortcutManager
        self.presenceManager = presenceManager
        self.appSettings = appSettings

        self.displayIconLocation = presenceManager.displayIconLocationRawValue
        self.visibleAtLaunch = appSettings.visibleAtLaunch
    }
}
