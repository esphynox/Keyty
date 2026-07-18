//
//  NSColorHexTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class NSColorHexTests: XCTestCase {

    // MARK: - NSColor → hex string

    func test_hexString_white() {
        XCTAssertEqual(NSColor.white.hexString, "#FFFFFFFF")
    }

    func test_hexString_black() {
        XCTAssertEqual(NSColor.black.hexString, "#000000FF")
    }

    func test_hexString_red() {
        let color = NSColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        XCTAssertEqual(color.hexString, "#FF0000FF")
    }

    func test_hexString_semiTransparent() {
        let color = NSColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)
        XCTAssertEqual(color.hexString, "#00000080")
    }

    func test_hexString_fullyTransparent() {
        let color = NSColor(srgbRed: 1, green: 1, blue: 1, alpha: 0)
        XCTAssertEqual(color.hexString, "#FFFFFF00")
    }

    // MARK: - hex string → NSColor

    func test_init_eightCharHex() {
        let color = NSColor(hexString: "#FF0000FF")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.redComponent ?? 0, 1.0, accuracy: 0.01)
        XCTAssertEqual(color?.greenComponent ?? 1, 0.0, accuracy: 0.01)
        XCTAssertEqual(color?.blueComponent ?? 1, 0.0, accuracy: 0.01)
        XCTAssertEqual(color?.alphaComponent ?? 0, 1.0, accuracy: 0.01)
    }

    func test_init_sixCharHex_defaultsAlphaToOne() {
        let color = NSColor(hexString: "#FF0000")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.alphaComponent ?? 0, 1.0, accuracy: 0.01)
    }

    func test_init_withoutHashPrefix() {
        let color = NSColor(hexString: "FF0000FF")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.redComponent ?? 0, 1.0, accuracy: 0.01)
    }

    func test_init_lowercaseHex() {
        let color = NSColor(hexString: "#ff0000ff")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.redComponent ?? 0, 1.0, accuracy: 0.01)
    }

    func test_init_withLeadingAndTrailingWhitespace() {
        let color = NSColor(hexString: "  #FF0000FF  ")
        XCTAssertNotNil(color)
    }

    func test_init_invalidLength_returnsNil() {
        XCTAssertNil(NSColor(hexString: "#FFF"))
        XCTAssertNil(NSColor(hexString: "#FFFFF"))
        XCTAssertNil(NSColor(hexString: "#FFFFFFFFF"))
    }

    func test_init_nonHexCharacters_returnsNil() {
        XCTAssertNil(NSColor(hexString: "#GGHHIIJJ"))
    }

    func test_init_emptyString_returnsNil() {
        XCTAssertNil(NSColor(hexString: ""))
    }

    // MARK: - Round-trip

    func test_roundTrip_preservesColor() {
        let original = NSColor(srgbRed: 0.2, green: 0.5, blue: 0.8, alpha: 0.75)
        let recovered = NSColor(hexString: original.hexString)
        XCTAssertNotNil(recovered)
        XCTAssertEqual(original.redComponent,   recovered!.redComponent,   accuracy: 0.01)
        XCTAssertEqual(original.greenComponent, recovered!.greenComponent, accuracy: 0.01)
        XCTAssertEqual(original.blueComponent,  recovered!.blueComponent,  accuracy: 0.01)
        XCTAssertEqual(original.alphaComponent, recovered!.alphaComponent, accuracy: 0.01)
    }

    func test_roundTrip_black() {
        let original = NSColor.black
        XCTAssertEqual(NSColor(hexString: original.hexString)?.hexString, original.hexString)
    }

    func test_roundTrip_white() {
        let original = NSColor.white
        XCTAssertEqual(NSColor(hexString: original.hexString)?.hexString, original.hexString)
    }
}
