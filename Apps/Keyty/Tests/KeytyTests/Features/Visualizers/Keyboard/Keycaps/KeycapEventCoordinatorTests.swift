//
//  KeycapEventCoordinatorTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import XCTest
@testable import Keyty

final class KeycapEventCoordinatorTests: XCTestCase {
    func testFlagsChangedStartsNewGroupAfterRegularKeyGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleTrackedKey(
            keyCode: 8,
            isKeyDown: true,
            items: [TestItem(identity: .keyCode(8))],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 2)
        XCTAssertEqual(appendedGroups[0].map(\.identity), [.keyCode(8)])
        XCTAssertEqual(appendedGroups[1].map(\.identity), [.modifier(.command)])
        XCTAssertTrue(updatedGroups.isEmpty)
    }

    func testFlagsChangedContinuesExistingModifierGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command, .shift],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 1)
        XCTAssertEqual(updatedGroups.count, 1)
        XCTAssertEqual(updatedGroups[0].map(\.identity), [.modifier(.command), .modifier(.shift)])
    }

    func testTrackedKeyUpdateDoesNotAppendLaterModifierToExistingKeyGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleTrackedKey(
            keyCode: 8,
            isKeyDown: true,
            items: [TestItem(identity: .keyCode(8))],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleTrackedKey(
            keyCode: 8,
            isKeyDown: false,
            items: [
                TestItem(identity: .modifier(.command)),
                TestItem(identity: .keyCode(8))
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 2)
        XCTAssertEqual(appendedGroups[0].map(\.identity), [.keyCode(8)])
        XCTAssertEqual(appendedGroups[1].map(\.identity), [.modifier(.command)])
        XCTAssertEqual(updatedGroups.count, 1)
        XCTAssertEqual(updatedGroups[0].map(\.identity), [.keyCode(8)])
    }

    func testFlagsChangedDoesNotMergeNewModifierIntoExistingPlainKeyGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleTrackedKey(
            keyCode: 1,
            isKeyDown: true,
            items: [TestItem(identity: .keyCode(1), isPressed: true)],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 2)
        XCTAssertEqual(appendedGroups[0].map(\.identity), [.keyCode(1)])
        XCTAssertEqual(appendedGroups[1].map(\.identity), [.modifier(.command)])
        XCTAssertTrue(updatedGroups.isEmpty)
    }

    func testModifierReleaseUpdatesExistingChordGroupInsteadOfAppendingNewGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleTrackedKey(
            keyCode: 8,
            isKeyDown: true,
            items: [
                TestItem(identity: .modifier(.command), isPressed: true),
                TestItem(identity: .keyCode(8), isPressed: true)
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [],
            releasedTrackedFlags: [.command],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 1)
        XCTAssertEqual(updatedGroups.count, 2)
        XCTAssertEqual(updatedGroups[0].map(\.identity), [.modifier(.command), .keyCode(8)])
        XCTAssertEqual(updatedGroups[1].map(\.identity), [.modifier(.command), .keyCode(8)])
        XCTAssertEqual(updatedGroups[1].first(where: { $0.identity == .modifier(.command) })?.isPressed, false)
    }

    func testNextModifiedKeyStartsNewGroupWhileModifiersRemainHeld() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command, .shift],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleTrackedKey(
            keyCode: 29,
            isKeyDown: true,
            items: [
                TestItem(identity: .modifier(.command), isPressed: true),
                TestItem(identity: .modifier(.shift), isPressed: true),
                TestItem(identity: .keyCode(29), isPressed: true)
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleTrackedKey(
            keyCode: 29,
            isKeyDown: false,
            items: [
                TestItem(identity: .modifier(.command), isPressed: true),
                TestItem(identity: .modifier(.shift), isPressed: true),
                TestItem(identity: .keyCode(29), isPressed: false)
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleTrackedKey(
            keyCode: 18,
            isKeyDown: true,
            items: [
                TestItem(identity: .modifier(.command), isPressed: true),
                TestItem(identity: .modifier(.shift), isPressed: true),
                TestItem(identity: .keyCode(18), isPressed: true)
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 2)
        XCTAssertEqual(appendedGroups[0].map(\.identity), [.modifier(.command), .modifier(.shift)])
        XCTAssertEqual(updatedGroups[0].map(\.identity), [.modifier(.command), .modifier(.shift), .keyCode(29)])
        XCTAssertEqual(updatedGroups[1].map(\.identity), [.modifier(.command), .modifier(.shift), .keyCode(29)])
        XCTAssertEqual(appendedGroups[1].map(\.identity), [.modifier(.command), .modifier(.shift), .keyCode(18)])
    }

    func testStandaloneItemAbsorbsExistingModifierGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command, .shift],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleStandalone(
            items: [TestItem(identity: .mouse(.leftButton))],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 1)
        XCTAssertEqual(appendedGroups[0].map(\.identity), [.modifier(.command), .modifier(.shift)])
        XCTAssertEqual(updatedGroups.count, 1)
        XCTAssertEqual(updatedGroups[0].map(\.identity), [.modifier(.command), .modifier(.shift), .mouse(.leftButton)])
    }

    func testMouseButtonReleaseUpdatesExistingChordGroup() {
        let coordinator = KeycapEventCoordinator<TestGroupView, TestItem>()
        var appendedGroups: [[TestItem]] = []
        var updatedGroups: [[TestItem]] = []

        coordinator.handleFlagsChanged(
            currentTrackedFlags: [.command],
            releasedTrackedFlags: [],
            buildItems: { currentFlags, releasedFlags in
                Self.modifierItems(currentFlags: currentFlags, releasedFlags: releasedFlags)
            },
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleMouseButton(
            kind: .leftButton,
            isPressed: true,
            items: [
                TestItem(identity: .modifier(.command), isPressed: true),
                TestItem(identity: .mouse(.leftButton), isPressed: true)
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        coordinator.handleMouseButton(
            kind: .leftButton,
            isPressed: false,
            items: [
                TestItem(identity: .modifier(.command), isPressed: true),
                TestItem(identity: .mouse(.leftButton), isPressed: false)
            ],
            appendGroup: {
                appendedGroups.append($0)
                return TestGroupView()
            },
            updateGroup: { _, items in
                updatedGroups.append(items)
            }
        )

        XCTAssertEqual(appendedGroups.count, 1)
        XCTAssertEqual(appendedGroups[0].map(\.identity), [.modifier(.command)])
        XCTAssertEqual(updatedGroups.count, 2)
        XCTAssertEqual(updatedGroups[0].map(\.identity), [.modifier(.command), .mouse(.leftButton)])
        XCTAssertEqual(updatedGroups[0].first(where: { $0.identity == .mouse(.leftButton) })?.isPressed, true)
        XCTAssertEqual(updatedGroups[1].map(\.identity), [.modifier(.command), .mouse(.leftButton)])
        XCTAssertEqual(updatedGroups[1].first(where: { $0.identity == .mouse(.leftButton) })?.isPressed, false)
    }

    private static func modifierItems(
        currentFlags: NSEvent.ModifierFlags,
        releasedFlags: NSEvent.ModifierFlags
    ) -> [TestItem] {
        var items: [TestItem] = []
        if currentFlags.contains(.command) || releasedFlags.contains(.command) {
            items.append(TestItem(identity: .modifier(.command), isPressed: currentFlags.contains(.command)))
        }
        if currentFlags.contains(.shift) || releasedFlags.contains(.shift) {
            items.append(TestItem(identity: .modifier(.shift), isPressed: currentFlags.contains(.shift)))
        }
        if currentFlags.contains(.option) || releasedFlags.contains(.option) {
            items.append(TestItem(identity: .modifier(.option), isPressed: currentFlags.contains(.option)))
        }
        if currentFlags.contains(.control) || releasedFlags.contains(.control) {
            items.append(TestItem(identity: .modifier(.control), isPressed: currentFlags.contains(.control)))
        }
        return items
    }
}

private final class TestGroupView {}

private struct TestItem: KeycapGroupItem {
    let identity: KeycapIdentity
    let isPressed: Bool

    init(identity: KeycapIdentity, isPressed: Bool = false) {
        self.identity = identity
        self.isPressed = isPressed
    }
}
