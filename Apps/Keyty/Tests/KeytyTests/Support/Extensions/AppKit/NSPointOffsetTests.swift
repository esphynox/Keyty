//
//  NSPointOffsetTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class NSPointOffsetTests: XCTestCase {
    func test_offsetBy_addsPositiveOffsets() {
        let point = NSPoint(x: 10, y: 20)

        XCTAssertEqual(point.offsetBy(dx: 3, dy: 4), NSPoint(x: 13, y: 24))
    }

    func test_offsetBy_addsNegativeOffsets() {
        let point = NSPoint(x: 10, y: 20)

        XCTAssertEqual(point.offsetBy(dx: -3, dy: -4), NSPoint(x: 7, y: 16))
    }

    func test_offsetBy_doesNotMutateOriginalPoint() {
        let point = NSPoint(x: 10, y: 20)

        _ = point.offsetBy(dx: 3, dy: 4)

        XCTAssertEqual(point, NSPoint(x: 10, y: 20))
    }
}
