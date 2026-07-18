//
//  SettingsSidebarViewModel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import SwiftUI

@MainActor
final class SettingsSidebarViewModel: ObservableObject {
    @Published var selectedPaneID: SettingsPaneIdentifier
    @Published private var badgeCounts: [SettingsPaneIdentifier: Int]

    init(selectedPaneID: SettingsPaneIdentifier = .general) {
        self.selectedPaneID = selectedPaneID
        self.badgeCounts = [:]
    }

    func select(_ identifier: SettingsPaneIdentifier) {
        self.selectedPaneID = identifier
    }

    func badgeCount(for identifier: SettingsPaneIdentifier) -> Int? {
        self.badgeCounts[identifier]
    }

    func setBadgeCount(_ count: Int, for identifier: SettingsPaneIdentifier) {
        if count > 0 {
            self.badgeCounts[identifier] = count
        } else {
            self.badgeCounts.removeValue(forKey: identifier)
        }
    }
}
