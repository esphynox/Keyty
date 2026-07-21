//
//  KeyboardVisualizerSpecialKeyFilteringTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
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

    func testResolverClassifiesInsertFunctionKeyAsSpecial() {
        let ch = Self.appKitFunctionKey(NSInsertFunctionKey)
        let event = Self.makeKeystroke(
            keyCode: KeyboardKeyCode.help.rawValue,
            characters: ch,
            charactersIgnoringModifiers: ch
        )

        XCTAssertTrue(KeyboardSpecialKeyResolver.isSpecial(event))
    }

    func testResolverClassifiesPrintableLetterAsNonSpecial() {
        let event = Self.makeKeystroke(
            keyCode: KeyboardKeyCode.a.rawValue,
            characters: "a",
            charactersIgnoringModifiers: "a"
        )

        XCTAssertFalse(KeyboardSpecialKeyResolver.isSpecial(event))
    }

    private static func makeKeystroke(
        keyCode: UInt16,
        characters: String,
        charactersIgnoringModifiers: String
    ) -> StandardKeyEvent {
        let event = NSEvent.keyEvent(
            with: .keyDown,
            location: .zero,
            modifierFlags: [],
            timestamp: NSDate.timeIntervalSinceReferenceDate,
            windowNumber: 0,
            context: nil,
            characters: characters,
            charactersIgnoringModifiers: charactersIgnoringModifiers,
            isARepeat: false,
            keyCode: keyCode
        )!
        return StandardKeyEvent(nsEvent: event)
    }

    private static func appKitFunctionKey(_ key: Int) -> String {
        String(UnicodeScalar(key)!)
    }
}
