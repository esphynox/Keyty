//
//  EventProcessorTests.swift
//  KeytyTests
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import XCTest
@testable import Keyty

final class EventProcessorTests: XCTestCase {
    func testMouseUpEmitsContentAndGroupBreakWhenModifierIsHeld() {
        let processor = EventProcessor()
        var items: [DisplayItem] = []
        processor.onItemProduced = { items.append($0) }

        processor.noteMouseEvent(Self.makeMouseEvent(type: .leftMouseUp, buttonNumber: 0, modifiers: [.command]))

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].kind, .content)
        XCTAssertEqual(items[0].sourceEvent?.type, .leftMouseUp)
        XCTAssertEqual(items[1].kind, .groupBreak)
    }

    func testMouseUpWithoutModifiersEmitsContentAndGroupBreak() {
        let processor = EventProcessor()
        var items: [DisplayItem] = []
        processor.onItemProduced = { items.append($0) }

        processor.noteMouseEvent(Self.makeMouseEvent(type: .leftMouseUp, buttonNumber: 0, modifiers: []))

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].kind, .content)
        XCTAssertEqual(items[0].sourceEvent?.type, .leftMouseUp)
        XCTAssertEqual(items[1].kind, .groupBreak)
    }

    private static func makeMouseEvent(
        type: NSEvent.EventType,
        buttonNumber: Int,
        modifiers: NSEvent.ModifierFlags
    ) -> MouseEvent {
        let cgType: CGEventType = {
            switch type {
            case .leftMouseDown, .leftMouseUp: return type == .leftMouseDown ? .leftMouseDown : .leftMouseUp
            case .rightMouseDown, .rightMouseUp: return type == .rightMouseDown ? .rightMouseDown : .rightMouseUp
            default: return type == .otherMouseDown ? .otherMouseDown : .otherMouseUp
            }
        }()

        var cgFlags: CGEventFlags = []
        if modifiers.contains(.shift)   { cgFlags.insert(.maskShift) }
        if modifiers.contains(.command) { cgFlags.insert(.maskCommand) }
        if modifiers.contains(.control) { cgFlags.insert(.maskControl) }
        if modifiers.contains(.option)  { cgFlags.insert(.maskAlternate) }
        if modifiers.contains(.function) { cgFlags.insert(.maskSecondaryFn) }

        let cgEvent = CGEvent(mouseEventSource: nil, mouseType: cgType, mouseCursorPosition: .zero, mouseButton: .left)!
        cgEvent.setIntegerValueField(.mouseEventButtonNumber, value: Int64(buttonNumber))
        cgEvent.flags = cgFlags
        return MouseEvent(nsEvent: NSEvent(cgEvent: cgEvent)!)
    }
}
