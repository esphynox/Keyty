//
//  ShortcutManagerTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
import ShortcutRecorder
@testable import Keyty

final class ShortcutManagerTests: XCTestCase {
    private var store: InMemoryKeyValueStore!
    private var settings: ShortcutSettings!
    private var manager: ShortcutManager!

    override func setUp() {
        super.setUp()
        store = InMemoryKeyValueStore()
        settings = ShortcutSettings(store: store)
        settings.registerDefaults()
        manager = ShortcutManager(settings: settings)
    }

    override func tearDown() {
        manager = nil
        settings = nil
        store = nil
        super.tearDown()
    }

    func testRegistersDefaultShortcutData() {
        XCTAssertEqual(
            store.data(forKey: ShortcutSettings.capturingHotKeyKey),
            ShortcutArchiver.defaultData()
        )
    }

    func testPersistsShortcutToSettings() throws {
        let shortcut = Shortcut(
            code: .ansiA,
            modifierFlags: [.command, .option],
            characters: nil,
            charactersIgnoringModifiers: nil
        )

        manager.toggleCapturingShortcut = shortcut

        XCTAssertEqual(
            store.data(forKey: ShortcutSettings.capturingHotKeyKey),
            try ShortcutArchiver.data(for: shortcut)
        )
    }

    func testClearingShortcutRevertsToDefaultData() {
        manager.toggleCapturingShortcut = nil

        XCTAssertEqual(
            store.data(forKey: ShortcutSettings.capturingHotKeyKey),
            ShortcutArchiver.defaultData()
        )
    }

    func testLoadsShortcutFromSettings() throws {
        let shortcut = Shortcut(
            code: .ansiB,
            modifierFlags: [.control, .shift],
            characters: nil,
            charactersIgnoringModifiers: nil
        )
        store.set(try ShortcutArchiver.data(for: shortcut), forKey: ShortcutSettings.capturingHotKeyKey)

        manager = ShortcutManager(settings: settings)

        XCTAssertEqual(manager.toggleCapturingShortcut, shortcut)
    }

    func testFallsBackToDefaultShortcutWhenStoredDataIsInvalid() {
        store.set(Data([0x00, 0x01, 0x02]), forKey: ShortcutSettings.capturingHotKeyKey)

        manager = ShortcutManager(settings: settings)

        XCTAssertEqual(manager.toggleCapturingShortcut, ShortcutArchiver.defaultShortcut())
    }
}
