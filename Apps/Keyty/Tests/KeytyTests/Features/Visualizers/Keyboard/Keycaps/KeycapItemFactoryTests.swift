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

    private static func makeMouseEvent(type: NSEvent.EventType) -> MouseEvent {
        let cgType: CGEventType = type == .leftMouseDown ? .leftMouseDown : .leftMouseUp
        let cgEvent = CGEvent(mouseEventSource: nil, mouseType: cgType, mouseCursorPosition: .zero, mouseButton: .left)!
        return MouseEvent(nsEvent: NSEvent(cgEvent: cgEvent)!)
    }
}
