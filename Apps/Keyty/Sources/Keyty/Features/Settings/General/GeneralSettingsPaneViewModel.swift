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

    private let appSettings: any AppSettingsProtocol

    @Published var visibleAtLaunch: Bool {
        didSet { self.appSettings.visibleAtLaunch = self.visibleAtLaunch }
    }

    @Published var shortcutValidationMessage: String?

    init(shortcutManager: ShortcutManager, appSettings: any AppSettingsProtocol) {
        self.shortcutManager = shortcutManager
        self.appSettings = appSettings

        self.visibleAtLaunch = self.appSettings.visibleAtLaunch
        self.shortcutValidationMessage = self.shortcutManager.shortcutValidationMessage
        self.shortcutManager.onShortcutValidationMessageChanged = { [weak self] message in
            self?.shortcutValidationMessage = message
        }
    }
}
