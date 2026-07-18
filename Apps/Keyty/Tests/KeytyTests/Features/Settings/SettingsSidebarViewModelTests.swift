//
//  SettingsSidebarViewModelTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

@MainActor
final class SettingsSidebarViewModelTests: XCTestCase {
    func testSetBadgeCountStoresPositiveCount() {
        let model = SettingsSidebarViewModel()

        model.setBadgeCount(3, for: .permissions)

        XCTAssertEqual(model.badgeCount(for: .permissions), 3)
    }

    func testSetBadgeCountClearsZeroCount() {
        let model = SettingsSidebarViewModel()

        model.setBadgeCount(3, for: .permissions)
        model.setBadgeCount(0, for: .permissions)

        XCTAssertNil(model.badgeCount(for: .permissions))
    }

    func testSetBadgeCountIgnoresNegativeCount() {
        let model = SettingsSidebarViewModel()

        model.setBadgeCount(-1, for: .permissions)

        XCTAssertNil(model.badgeCount(for: .permissions))
    }
}
