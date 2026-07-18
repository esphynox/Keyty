//
//  KeyboardVisualizerSpecialKeyFilteringTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class KeyboardVisualizerSpecialKeyFilteringTests: XCTestCase {
    func testClassifiesPrintableLetterAsNonSpecial() {
        XCTAssertFalse(KeyboardKeyCode.a.isSpecial)
    }

    func testClassifiesTabAsSpecial() {
        XCTAssertTrue(KeyboardKeyCode.tab.isSpecial)
    }

    func testClassifiesArrowKeyAsSpecial() {
        XCTAssertTrue(KeyboardKeyCode.upArrow.isSpecial)
    }

    func testClassifiesFunctionRowKeyAsSpecial() {
        XCTAssertTrue(KeyboardKeyCode.f5.isSpecial)
    }
}
