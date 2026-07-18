//
//  ShortcutArchiver.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Cocoa
import ShortcutRecorder

enum ShortcutArchiver {
    static func defaultShortcut() -> Shortcut {
        Shortcut(
            code: .ansiK,
            modifierFlags: [.control, .option, .command],
            characters: nil,
            charactersIgnoringModifiers: nil
        )
    }

    static func defaultShortcutData() -> Data? {
        try? self.data(for: self.defaultShortcut())
    }

    static func defaultData() -> Data? {
        self.defaultShortcutData()
    }

    static func data(for shortcut: Shortcut) throws -> Data {
        try NSKeyedArchiver.archivedData(withRootObject: shortcut, requiringSecureCoding: true)
    }

    static func shortcut(from data: Data) -> Shortcut? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: Shortcut.self, from: data)
    }
}
