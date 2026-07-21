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
    private var globalShortcutMonitor: FakeGlobalShortcutMonitor!
    private var manager: ShortcutManager!

    override func setUp() {
        super.setUp()
        store = InMemoryKeyValueStore()
        settings = ShortcutSettings(store: store)
        settings.registerDefaults()
        globalShortcutMonitor = FakeGlobalShortcutMonitor()
        manager = ShortcutManager(settings: settings, globalShortcutMonitor: globalShortcutMonitor)
    }

    override func tearDown() {
        manager = nil
        globalShortcutMonitor = nil
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

        manager = ShortcutManager(settings: settings, globalShortcutMonitor: globalShortcutMonitor)

        XCTAssertEqual(manager.toggleCapturingShortcut, shortcut)
    }

    func testFallsBackToDefaultShortcutWhenStoredDataIsInvalid() {
        store.set(Data([0x00, 0x01, 0x02]), forKey: ShortcutSettings.capturingHotKeyKey)

        manager = ShortcutManager(settings: settings, globalShortcutMonitor: globalShortcutMonitor)

        XCTAssertEqual(manager.toggleCapturingShortcut, ShortcutArchiver.defaultShortcut())
    }

    func testRegistersGlobalShortcutAtStartup() {
        XCTAssertEqual(globalShortcutMonitor.addedActions.count, 1)
        XCTAssertEqual(globalShortcutMonitor.addedActions.first?.shortcut, ShortcutArchiver.defaultShortcut())
        XCTAssertEqual(globalShortcutMonitor.addedKeyEvents, [.down])
    }

    func testUpdatesRegisteredGlobalShortcutWhenShortcutChanges() {
        let shortcut = Shortcut(
            code: .ansiA,
            modifierFlags: [.command, .option],
            characters: nil,
            charactersIgnoringModifiers: nil
        )

        manager.toggleCapturingShortcut = shortcut

        XCTAssertEqual(globalShortcutMonitor.removedActions.count, 1)
        XCTAssertEqual(globalShortcutMonitor.addedActions.count, 2)
        XCTAssertEqual(globalShortcutMonitor.addedActions.last?.shortcut, shortcut)
    }

    func testGlobalShortcutActionTogglesCapturing() {
        var toggleCount = 0
        manager.onToggleCapturingShortcut = {
            toggleCount += 1
        }

        globalShortcutMonitor.performLastAction()

        XCTAssertEqual(toggleCount, 1)
    }

    func testUnregistersGlobalShortcutOnDeinit() {
        manager = nil

        XCTAssertEqual(globalShortcutMonitor.removedActions.count, 1)
    }
}

private final class FakeGlobalShortcutMonitor: GlobalShortcutMonitoring {
    private(set) var addedActions: [ShortcutAction] = []
    private(set) var addedKeyEvents: [KeyEventType] = []
    private(set) var removedActions: [ShortcutAction] = []

    func addAction(_ action: ShortcutAction, forKeyEvent keyEvent: KeyEventType) {
        self.addedActions.append(action)
        self.addedKeyEvents.append(keyEvent)
    }

    func removeAction(_ action: ShortcutAction) {
        self.removedActions.append(action)
    }

    func performLastAction() {
        self.addedActions.last?.perform(onTarget: nil)
    }
}
