//
//  KeyboardVisualizerAnchorTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class KeyboardVisualizerAnchorTests: XCTestCase {
    func testSymbolUsesDirectionalArrowsForCardinalAnchors() {
        XCTAssertEqual(KeyboardVisualizerAnchor.topCenter.symbol, "↑")
        XCTAssertEqual(KeyboardVisualizerAnchor.middleLeft.symbol, "←")
        XCTAssertEqual(KeyboardVisualizerAnchor.middleRight.symbol, "→")
        XCTAssertEqual(KeyboardVisualizerAnchor.bottomCenter.symbol, "↓")
    }
}
