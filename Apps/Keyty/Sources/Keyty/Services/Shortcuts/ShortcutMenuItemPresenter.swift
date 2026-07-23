//
//  ShortcutMenuItemPresenter.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Cocoa
import ShortcutRecorder

/// Displays the configured shortcut in menu items that expose the toggle command.
protocol ShortcutMenuItemPresenting: AnyObject {
    /// Shows the shortcut in attached menu items, or clears them when `shortcut` is `nil`.
    func displayShortcut(_ shortcut: Shortcut?)
}

/// Updates the status bar menu item to display the currently assigned toggle shortcut.
final class ShortcutMenuItemPresenter {
    private weak var statusShortcutItem: NSMenuItem?

    init(statusShortcutItem: NSMenuItem) {
        self.statusShortcutItem = statusShortcutItem
    }
}

// MARK: - Logic
private extension ShortcutMenuItemPresenter {
    private func setKeyEquivalent(_ keyEquivalent: String) {
        self.statusShortcutItem?.keyEquivalent = keyEquivalent
    }

    private func setKeyEquivalentModifierMask(_ modifierFlags: NSEvent.ModifierFlags) {
        self.statusShortcutItem?.keyEquivalentModifierMask = modifierFlags
    }
}

// MARK: - ShortcutMenuItemPresenting
extension ShortcutMenuItemPresenter: ShortcutMenuItemPresenting {
    func displayShortcut(_ shortcut: Shortcut?) {
        if let shortcut {
            let keyEquivalent = KeyEquivalentTransformer.shared.transformedValue(shortcut) ?? ""
            self.setKeyEquivalent(keyEquivalent)
            self.setKeyEquivalentModifierMask(shortcut.modifierFlags)
        } else {
            self.setKeyEquivalent("")
            self.setKeyEquivalentModifierMask([])
        }
    }
}
