//
//  KeycapItemFactoryTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import XCTest
@testable import Keyty

final class KeycapItemFactoryTests: XCTestCase {
    func testKeyboardModifierKeysDecodeLocationSpecificFlags() {
        let flags = Self.flags(.command, masks: UInt(NX_DEVICELCMDKEYMASK), UInt(NX_DEVICERCMDKEYMASK))

        XCTAssertEqual(KeyboardModifierKey.keys(in: flags), [.leftCommand, .rightCommand])
    }

    func testModifierItemsIncludeFunctionKey() {
        let items = KeycapItemFactory.modifierItems(
            currentFlags: [.function],
            releasedFlags: [],
            palette: Self.makePalette()
        )

        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.identity, .keyCode(KeyboardKeyCode.function.rawValue))
        XCTAssertEqual(items.first?.label, "fn")
        XCTAssertEqual(items.first?.sfSymbolName, "globe")
        XCTAssertEqual(items.first?.isPressed, true)
    }

    func testModifierItemsUseLocationSpecificModifierKeys() {
        let items = KeycapItemFactory.modifierItems(
            currentFlags: Self.flags(.command, masks: UInt(NX_DEVICELCMDKEYMASK), UInt(NX_DEVICERCMDKEYMASK)),
            releasedFlags: [],
            palette: Self.makePalette()
        )

        XCTAssertEqual(items.map(\.identity), [
            .modifier(.leftCommand),
            .modifier(.rightCommand),
        ])
        XCTAssertEqual(items.map(\.layoutHints.alignment), [.right, .left])
    }

    func testModifierItemsUseInwardAlignmentForNonCommandModifierKeys() {
        let items = KeycapItemFactory.modifierItems(
            currentFlags: Self.flags(.shift, masks: UInt(NX_DEVICELSHIFTKEYMASK), UInt(NX_DEVICERSHIFTKEYMASK)),
            releasedFlags: [],
            palette: Self.makePalette()
        )

        XCTAssertEqual(items.map(\.identity), [
            .modifier(.leftShift),
            .modifier(.rightShift),
        ])
        XCTAssertEqual(items.map(\.layoutHints.alignment), [.right, .left])
    }

    func testModifierItemsFallbackToLeftKeyForAggregateFlags() {
        let items = KeycapItemFactory.modifierItems(
            currentFlags: [.command],
            releasedFlags: [],
            palette: Self.makePalette()
        )

        XCTAssertEqual(items.map(\.identity), [.modifier(.leftCommand)])
    }

    func testReturnAndKeypadEnterRenderDifferentLegends() {
        let palette = Self.makePalette()

        let returnItems = KeycapItemFactory.keycapItems(
            keyCode: KeyboardKeyCode.returnKey.rawValue,
            displayString: KeyboardKeyCode.returnKey.displayText ?? "",
            modifierFlags: [],
            isPressed: true,
            palette: palette
        )
        let enterItems = KeycapItemFactory.keycapItems(
            keyCode: KeyboardKeyCode.keypadEnter.rawValue,
            displayString: KeyboardKeyCode.keypadEnter.displayText ?? "",
            modifierFlags: [],
            isPressed: true,
            palette: palette
        )

        XCTAssertEqual(returnItems.map(\.identity), [.keyCode(KeyboardKeyCode.returnKey.rawValue)])
        XCTAssertEqual(returnItems.first?.symbol, UnicodeToken.returnKey.string)
        XCTAssertEqual(returnItems.first?.label, "return")
        XCTAssertEqual(enterItems.map(\.identity), [.keyCode(KeyboardKeyCode.keypadEnter.rawValue)])
        XCTAssertEqual(enterItems.first?.symbol, UnicodeToken.keypadEnter.string)
        XCTAssertEqual(enterItems.first?.label, "enter")
    }

    func testMouseItemUsesPressedStateFromMouseEventType() {
        let palette = Self.makePalette()

        let downItem = KeycapItemFactory.mouseItem(
            for: Self.makeMouseEvent(type: .leftMouseDown),
            palette: palette
        )
        let upItem = KeycapItemFactory.mouseItem(
            for: Self.makeMouseEvent(type: .leftMouseUp),
            palette: palette
        )

        XCTAssertTrue(downItem.isPressed)
        XCTAssertFalse(upItem.isPressed)
    }

    private static func makePalette(
        style: KeycapStyle = .minimal,
        theme: KeyboardVisualizerTheme = .citrus
    ) -> KeycapThemePalette {
        KeycapThemePalette(
            style: style,
            themes: [
                .regular:  theme,
                .modifier: theme,
                .special:  theme,
                .media:    theme,
                .mouse:    theme,
            ],
            groupBackgroundTheme: theme,
            legendColorOverride: nil
        )
    }

    private static func flags(_ flags: NSEvent.ModifierFlags, masks: UInt...) -> NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: masks.reduce(flags.rawValue) { $0 | $1 })
    }

    private static func makeMouseEvent(type: NSEvent.EventType) -> MouseEvent {
        let cgType: CGEventType = type == .leftMouseDown ? .leftMouseDown : .leftMouseUp
        let cgEvent = CGEvent(mouseEventSource: nil, mouseType: cgType, mouseCursorPosition: .zero, mouseButton: .left)!
        return MouseEvent(nsEvent: NSEvent(cgEvent: cgEvent)!)
    }
}
