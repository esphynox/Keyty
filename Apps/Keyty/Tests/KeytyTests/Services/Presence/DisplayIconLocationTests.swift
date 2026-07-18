//
//  DisplayIconLocationTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class DisplayIconLocationTests: XCTestCase {
    func testShowsInDock() {
        XCTAssertFalse(DisplayIconLocation.menuBar.showsInDock)
        XCTAssertTrue(DisplayIconLocation.dock.showsInDock)
        XCTAssertTrue(DisplayIconLocation.menuBarAndDock.showsInDock)
    }

    func testShowsInMenuBar() {
        XCTAssertTrue(DisplayIconLocation.menuBar.showsInMenuBar)
        XCTAssertFalse(DisplayIconLocation.dock.showsInMenuBar)
        XCTAssertTrue(DisplayIconLocation.menuBarAndDock.showsInMenuBar)
    }
}
