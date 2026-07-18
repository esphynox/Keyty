//
//  CGFloatSuperellipseTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class CGFloatSuperellipseTests: XCTestCase {
    private let exponent: CGFloat = 4.0
    private let accuracy: CGFloat = 1e-9

    func test_zero_returnsZero() {
        XCTAssertEqual(CGFloat(0).signedSuperellipseComponent(exponent: exponent), 0)
    }

    func test_extremes_areUnchanged() {
        XCTAssertEqual(CGFloat(1).signedSuperellipseComponent(exponent: exponent), 1, accuracy: accuracy)
        XCTAssertEqual(CGFloat(-1).signedSuperellipseComponent(exponent: exponent), -1, accuracy: accuracy)
    }

    func test_preservesSign() {
        XCTAssertLessThan(CGFloat(-0.5).signedSuperellipseComponent(exponent: exponent), 0)
        XCTAssertGreaterThan(CGFloat(0.5).signedSuperellipseComponent(exponent: exponent), 0)
    }

    func test_isSymmetricAcrossZero() {
        let value: CGFloat = 0.5
        let positive = value.signedSuperellipseComponent(exponent: exponent)
        let negative = (-value).signedSuperellipseComponent(exponent: exponent)

        XCTAssertEqual(positive, -negative, accuracy: accuracy)
    }

    func test_matchesExpectedMagnitude() {
        // |0.5|^(2/4) == sqrt(0.5)
        XCTAssertEqual(
            CGFloat(0.5).signedSuperellipseComponent(exponent: exponent),
            sqrt(0.5),
            accuracy: accuracy
        )
    }

    func test_exponentTwo_isIdentityMagnitude() {
        // exponent == 2 → |value|^1, i.e. the unit circle (identity).
        XCTAssertEqual(CGFloat(0.5).signedSuperellipseComponent(exponent: 2), 0.5, accuracy: accuracy)
    }
}
