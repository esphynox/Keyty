//
//  UpdateSettingsPaneViewModel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Sparkle
import SwiftUI

final class UpdateSettingsPaneViewModel: ObservableObject {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    private let updater: SPUUpdater

    @Published var automaticallyChecksForUpdates: Bool {
        didSet { self.updater.automaticallyChecksForUpdates = self.automaticallyChecksForUpdates }
    }

    @Published var sendsSystemProfile: Bool {
        didSet { self.updater.sendsSystemProfile = self.sendsSystemProfile }
    }

    init(updater: SPUUpdater) {
        self.updater = updater
        self.automaticallyChecksForUpdates = self.updater.automaticallyChecksForUpdates
        self.sendsSystemProfile = self.updater.sendsSystemProfile
    }

    var lastCheckedText: String {
        guard let date = self.updater.lastUpdateCheckDate else {
            return L10n.Update.never
        }
        return Self.dateFormatter.string(from: date)
    }

    func checkForUpdates() {
        self.updater.checkForUpdates()
        self.objectWillChange.send()
    }
}
