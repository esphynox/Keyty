//
//  PresenceSettingsTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class PresenceSettingsTests: XCTestCase {
    private var store: InMemoryKeyValueStore!
    private var settings: PresenceSettings!

    override func setUp() {
        super.setUp()
        store = InMemoryKeyValueStore()
        settings = PresenceSettings(store: store)
        settings.registerDefaults()
    }

    override func tearDown() {
        settings = nil
        store = nil
        super.tearDown()
    }

    func testRegistersDefaultDisplayIconLocation() {
        XCTAssertEqual(
            store.integer(forKey: PresenceSettings.displayIconLocationKey),
            DisplayIconLocation.menuBarAndDock.rawValue
        )
    }

    func testDisplayIconLocationPersists() {
        settings.displayIconLocation = .dock

        XCTAssertEqual(
            store.integer(forKey: PresenceSettings.displayIconLocationKey),
            DisplayIconLocation.dock.rawValue
        )
    }
}
