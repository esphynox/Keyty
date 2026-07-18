//
//  EventTransformerKeystrokeTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

// NOTE: These tests assume a US-English layout and may break under other locales.
// The correct modifier ordering is Control-Option-Shift-Command (as shown in Apple menus).

import Carbon
import XCTest
@testable import Keyty

final class EventTransformerKeystrokeTests: XCTestCase {
    var keystroke: StandardKeyEvent!
    var keyboardLayout: TISInputSource!
    var keyboardLayouts: [TISInputSource] = []

    func transform(_ event: StandardKeyEvent) -> String {
        EventTransformer(keyboardLayout: keyboardLayout).transform(.keystroke(event))
    }

    func usEnglishKeyboardLayout() -> TISInputSource {
        let properties: [String: Any] = [
            kTISPropertyInputSourceID as String: "com.apple.keylayout.US",
            kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout as String
        ]
        keyboardLayouts = TISCreateInputSourceList(properties as CFDictionary, true)!
            .takeRetainedValue() as! [TISInputSource]
        XCTAssertGreaterThan(keyboardLayouts.count, 0)
        return keyboardLayouts[0]
    }

    func makeKeystroke(keyCode: UInt16, modifiers: NSEvent.ModifierFlags,
                       characters: String, charactersIgnoringModifiers: String) -> StandardKeyEvent {
        let event = NSEvent.keyEvent(
            with: .keyDown,
            location: .zero,
            modifierFlags: modifiers,
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

    override func setUp() {
        super.setUp()
        keyboardLayout = usEnglishKeyboardLayout()
    }

    // MARK: - Numbers

    func test_KCKeystroke_convertsCtrlNumberToNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 262401), characters: "7", charactersIgnoringModifiers: "7")
        XCTAssertEqual(transform(keystroke), "⌃7")
    }

    func test_KCKeystroke_convertsShiftNumberToShiftNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 131330), characters: "&", charactersIgnoringModifiers: "&")
        XCTAssertEqual(transform(keystroke), "⇧7")
    }

    func test_KCKeystroke_convertsCtrlShiftNumberToNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 393475), characters: "7", charactersIgnoringModifiers: "&")
        XCTAssertEqual(transform(keystroke), "⌃⇧7")
    }

    func test_KCKeystroke_convertsCmdNumberToNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 1048840), characters: "7", charactersIgnoringModifiers: "7")
        XCTAssertEqual(transform(keystroke), "⌘7")
    }

    func test_KCKeystroke_convertsCmdShiftNumberToNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 1179914), characters: "7", charactersIgnoringModifiers: "&")
        XCTAssertEqual(transform(keystroke), "⇧⌘7")
    }

    func test_KCKeystroke_convertsCmdOptNumberToNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 1573160), characters: "¶", charactersIgnoringModifiers: "7")
        XCTAssertEqual(transform(keystroke), "⌥⌘7")
    }

    func test_KCKeystroke_convertsShiftOptionNumberToNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 655650), characters: "»", charactersIgnoringModifiers: "7")
        XCTAssertEqual(transform(keystroke), "⌥⇧7")
    }

    func test_KCKeystroke_convertsCmdOptShiftNumberToShiftedNumber() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 1704234), characters: "‡", charactersIgnoringModifiers: "&")
        XCTAssertEqual(transform(keystroke), "⌥⇧⌘7")
    }

    // MARK: - Letters

    func test_KCKeystroke_convertsCtrlLetterToUppercaseLetter() {
        keystroke = makeKeystroke(keyCode: 0, modifiers: NSEvent.ModifierFlags(rawValue: 262401), characters: "^A", charactersIgnoringModifiers: "a")
        XCTAssertEqual(transform(keystroke), "⌃A")
    }

    func test_KCKeystroke_convertsCtrlShiftLetterToLetter() {
        keystroke = makeKeystroke(keyCode: 0, modifiers: NSEvent.ModifierFlags(rawValue: 393475), characters: "^A", charactersIgnoringModifiers: "a")
        XCTAssertEqual(transform(keystroke), "⌃⇧A")
    }

    func test_KCKeystroke_convertsCtrlShiftCmdLetterToLetter() {
        keystroke = makeKeystroke(keyCode: 0, modifiers: NSEvent.ModifierFlags(rawValue: 1442059), characters: "^A", charactersIgnoringModifiers: "A")
        XCTAssertEqual(transform(keystroke), "⌃⇧⌘A")
    }

    func test_KCKeystroke_convertsCtrlOptLetterToUppercaseLetter() {
        keystroke = makeKeystroke(keyCode: 0, modifiers: NSEvent.ModifierFlags(rawValue: 786721), characters: "^A", charactersIgnoringModifiers: "a")
        XCTAssertEqual(transform(keystroke), "⌃⌥A")
    }

    func test_KCKeystroke_convertsCtrlOptShiftLetterToLetter() {
        keystroke = makeKeystroke(keyCode: 0, modifiers: NSEvent.ModifierFlags(rawValue: 917795), characters: "^A", charactersIgnoringModifiers: "A")
        XCTAssertEqual(transform(keystroke), "⌃⌥⇧A")
    }

    func test_KCKeystroke_displaysOptLetterByDefault() {
        keystroke = makeKeystroke(keyCode: 32, modifiers: NSEvent.ModifierFlags(rawValue: 524576), characters: "", charactersIgnoringModifiers: "u")
        XCTAssertEqual(transform(keystroke), "⌥U")
    }

    // MARK: - Function Row

    func test_KCKeystroke_convertsFnF1ToBrightnessDecrease() {
        keystroke = makeKeystroke(keyCode: 145, modifiers: NSEvent.ModifierFlags(rawValue: 8388864), characters: "", charactersIgnoringModifiers: "")
        XCTAssertEqual(transform(keystroke), "🔅")
    }

    func test_KCKeystroke_convertsFnF2ToBrightnessIncrease() {
        keystroke = makeKeystroke(keyCode: 144, modifiers: NSEvent.ModifierFlags(rawValue: 8388864), characters: "", charactersIgnoringModifiers: "")
        XCTAssertEqual(transform(keystroke), "🔆")
    }

    func test_KCKeystroke_convertsFnF3ToMissionControl() {
        keystroke = makeKeystroke(keyCode: 160, modifiers: NSEvent.ModifierFlags(rawValue: 8388864), characters: "", charactersIgnoringModifiers: "")
        XCTAssertEqual(transform(keystroke), "🖥")
    }

    func test_KCKeystroke_convertsFnF4ToLauncher() {
        keystroke = makeKeystroke(keyCode: 131, modifiers: NSEvent.ModifierFlags(rawValue: 8388864), characters: "", charactersIgnoringModifiers: "")
        XCTAssertEqual(transform(keystroke), "🚀")
    }

    // MARK: - JIS layout

    func test_KCKeystroke_convertsEisuKey() {
        keystroke = makeKeystroke(keyCode: 102, modifiers: [], characters: "", charactersIgnoringModifiers: "")
        XCTAssertEqual(transform(keystroke), "英数")
    }

    func test_KCKeystroke_convertsKanaKey() {
        keystroke = makeKeystroke(keyCode: 104, modifiers: [], characters: "", charactersIgnoringModifiers: "")
        XCTAssertEqual(transform(keystroke), "かな")
    }

    // MARK: - Option-modified characters

    func test_optionShiftNumberDisplaysExplicitModifiers() {
        keystroke = makeKeystroke(keyCode: 26, modifiers: NSEvent.ModifierFlags(rawValue: 655650), characters: "»", charactersIgnoringModifiers: "7")
        XCTAssertEqual(transform(keystroke), "⌥⇧7")
    }

    // MARK: - Special Cases

    func test_tabKey() {
        keystroke = makeKeystroke(keyCode: 48, modifiers: NSEvent.ModifierFlags(rawValue: 256), characters: "\t", charactersIgnoringModifiers: "\t")
        XCTAssertEqual(transform(keystroke), "⇥")
    }

    func test_shiftTab() {
        let ch = String(UnicodeScalar(0x19)!)
        keystroke = makeKeystroke(keyCode: 48, modifiers: NSEvent.ModifierFlags(rawValue: 131330), characters: ch, charactersIgnoringModifiers: ch)
        XCTAssertEqual(transform(keystroke), "⇤")
    }

    // MARK: - US English - Special Cases with Modifiers

    func test_optionShiftUp() {
        let ch = String(format: "%lu", UInt64(0x00006000002f5c00))
        keystroke = makeKeystroke(keyCode: 126, modifiers: NSEvent.ModifierFlags(rawValue: 11141410), characters: ch, charactersIgnoringModifiers: ch)

        XCTAssertEqual(transform(keystroke), "⌥⇧↑")
    }

    func test_optionUSpecialCase() {
        keystroke = makeKeystroke(keyCode: 32, modifiers: NSEvent.ModifierFlags(rawValue: 524576), characters: "", charactersIgnoringModifiers: "u")
        XCTAssertEqual(transform(keystroke), "⌥U")
    }

    func test_optionESpecialCase() {
        keystroke = makeKeystroke(keyCode: 14, modifiers: NSEvent.ModifierFlags(rawValue: 524576), characters: "", charactersIgnoringModifiers: "e")
        XCTAssertEqual(transform(keystroke), "⌥E")
    }

    func test_optionBacktickSpecialCase() {
        keystroke = makeKeystroke(keyCode: 50, modifiers: NSEvent.ModifierFlags(rawValue: 524576), characters: "", charactersIgnoringModifiers: "`")
        XCTAssertEqual(transform(keystroke), "⌥`")
    }

    // MARK: - German - Special Case

    func test_commandßDisplaysCommandß() {
        keystroke = makeKeystroke(keyCode: 27, modifiers: NSEvent.ModifierFlags(rawValue: 1048840), characters: "ß", charactersIgnoringModifiers: "ß")
        XCTAssertEqual(transform(keystroke), "⌘ß")
    }
}
