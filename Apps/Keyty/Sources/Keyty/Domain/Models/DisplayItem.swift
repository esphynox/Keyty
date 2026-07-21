//
//  DisplayItem.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

public enum DisplayItemKind: Int {
    case content
    case groupBreak
    case flagsChanged
}

public class DisplayItem {
    public private(set) var kind: DisplayItemKind

    public private(set) var text: String?
    public private(set) var sourceEvent: InputEvent?
    public private(set) var startsNewLine: Bool
    public private(set) var isCommand: Bool
    public private(set) var isModified: Bool
    public private(set) var isMouseEvent: Bool

    public private(set) var modifierFlags: NSEvent.ModifierFlags

    public init(
        asContentWithText text: String,
        sourceEvent event: InputEvent?,
        startsNewLine: Bool,
        isCommand: Bool,
        isModified: Bool,
        isMouseEvent: Bool
    ) {
        self.kind = .content
        self.text = text
        self.sourceEvent = event
        self.startsNewLine = startsNewLine
        self.isCommand = isCommand
        self.isModified = isModified
        self.isMouseEvent = isMouseEvent
        self.modifierFlags = []
    }

    public init(asGroupBreak: Void = ()) {
        self.kind = .groupBreak
        self.text = nil
        self.sourceEvent = nil
        self.startsNewLine = false
        self.isCommand = false
        self.isModified = false
        self.isMouseEvent = false
        self.modifierFlags = []
    }

    init(asFlagsChangedWith modifierFlags: NSEvent.ModifierFlags) {
        self.kind = .flagsChanged
        self.text = nil
        self.sourceEvent = nil
        self.startsNewLine = false
        self.isCommand = false
        self.isModified = false
        self.isMouseEvent = false
        self.modifierFlags = modifierFlags
    }
}
