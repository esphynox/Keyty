//
//  InMemoryKeyValueStore.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Combine

final class InMemoryKeyValueStore: KeyValueStore {
    private var values: [String: Any] = [:]
    private var registeredDefaults: [String: Any] = [:]
    private let changesSubject = PassthroughSubject<Void, Never>()

    var changes: AnyPublisher<Void, Never> {
        self.changesSubject.eraseToAnyPublisher()
    }

    func object(forKey key: String) -> Any? {
        self.values[key] ?? self.registeredDefaults[key]
    }

    func bool(forKey key: String) -> Bool {
        if let value = self.object(forKey: key) as? Bool { return value }
        if let number = self.object(forKey: key) as? NSNumber { return number.boolValue }
        return false
    }

    func integer(forKey key: String) -> Int {
        if let value = self.object(forKey: key) as? Int { return value }
        if let number = self.object(forKey: key) as? NSNumber { return number.intValue }
        return 0
    }

    func double(forKey key: String) -> Double {
        if let value = self.object(forKey: key) as? Double { return value }
        if let number = self.object(forKey: key) as? NSNumber { return number.doubleValue }
        return 0
    }

    func float(forKey key: String) -> Float {
        if let value = self.object(forKey: key) as? Float { return value }
        if let number = self.object(forKey: key) as? NSNumber { return number.floatValue }
        return 0
    }

    func string(forKey key: String) -> String? {
        self.object(forKey: key) as? String
    }

    func data(forKey key: String) -> Data? {
        self.object(forKey: key) as? Data
    }

    func color(forKey key: String) -> NSColor? {
        guard let hex = self.string(forKey: key) else { return nil }
        return NSColor(hexString: hex)
    }

    func set(_ value: Any?, forKey key: String) {
        if let value {
            self.values[key] = value
        } else {
            self.values.removeValue(forKey: key)
        }
        self.changesSubject.send(())
    }

    func removeObject(forKey key: String) {
        self.values.removeValue(forKey: key)
        self.changesSubject.send(())
    }

    func register(defaults registrationDictionary: [String: Any]) {
        for (key, value) in registrationDictionary {
            self.registeredDefaults[key] = value
        }
        self.changesSubject.send(())
    }
}
