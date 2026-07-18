//
//  UserDefaultsStore.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Combine
import Foundation

final class UserDefaultsStore: KeyValueStore {
    private let userDefaults: UserDefaults
    private let changesSubject = PassthroughSubject<Void, Never>()
    private var changesCancellable: AnyCancellable?

    var changes: AnyPublisher<Void, Never> {
        changesSubject.eraseToAnyPublisher()
    }

    init(userDefaults: UserDefaults = .standard, notificationCenter: NotificationCenter = .default) {
        self.userDefaults = userDefaults
        changesCancellable = notificationCenter
            .publisher(for: UserDefaults.didChangeNotification, object: userDefaults)
            .map { _ in () }
            .sink { [changesSubject] in
                changesSubject.send($0)
            }
    }

    func object(forKey key: String) -> Any? {
        userDefaults.object(forKey: key)
    }

    func bool(forKey key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    func integer(forKey key: String) -> Int {
        userDefaults.integer(forKey: key)
    }

    func double(forKey key: String) -> Double {
        userDefaults.double(forKey: key)
    }

    func float(forKey key: String) -> Float {
        userDefaults.float(forKey: key)
    }

    func string(forKey key: String) -> String? {
        userDefaults.string(forKey: key)
    }

    func data(forKey key: String) -> Data? {
        userDefaults.data(forKey: key)
    }

    func color(forKey key: String) -> NSColor? {
        guard let hex = userDefaults.string(forKey: key) else { return nil }
        return NSColor(hexString: hex)
    }

    func set(_ value: Any?, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func removeObject(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

    func register(defaults registrationDictionary: [String: Any]) {
        userDefaults.register(defaults: registrationDictionary)
    }
}
