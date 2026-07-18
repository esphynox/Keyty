//
//  KeyValueStore.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import Combine
import Foundation

protocol KeyValueStore {
    var changes: AnyPublisher<Void, Never> { get }

    func object(forKey key: String) -> Any?
    func bool(forKey key: String) -> Bool
    func integer(forKey key: String) -> Int
    func double(forKey key: String) -> Double
    func float(forKey key: String) -> Float
    func string(forKey key: String) -> String?
    func data(forKey key: String) -> Data?
    func color(forKey key: String) -> NSColor?
    func set(_ value: Any?, forKey key: String)
    func removeObject(forKey key: String)
    func register(defaults registrationDictionary: [String: Any])
}
