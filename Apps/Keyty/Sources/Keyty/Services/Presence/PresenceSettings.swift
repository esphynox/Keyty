//
//  PresenceSettings.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Foundation
import Combine

protocol PresenceSettingsProtocol: AnyObject {
    var displayIconLocation: DisplayIconLocation { get set }

    func registerDefaults()
}

final class PresenceSettings: PresenceSettingsProtocol, ReactiveSettings, HasSettingsStore {
    static let displayIconLocationKey = "displayIconLocation"

    let store: KeyValueStore

    var changes: AnyPublisher<Void, Never> {
        self.store.changes
    }

    init(store: KeyValueStore = UserDefaultsStore()) {
        self.store = store
    }

    @Stored(.enum(PresenceSettings.displayIconLocationKey, default: .menuBarAndDock))
    var displayIconLocation: DisplayIconLocation

    func registerDefaults() {
        self.registerStoredDefaults()
    }
}
