//
//  ShortcutManager.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import Cocoa
import ShortcutRecorder

final class ShortcutManager: NSObject {
    weak var statusShortcutItem: NSMenuItem?
    weak var dockShortcutItem: NSMenuItem?

    private let settings: any ShortcutSettingsProtocol
    private var _toggleCapturingShortcut: Shortcut?

    var toggleCapturingShortcut: Shortcut? {
        get {
            if self._toggleCapturingShortcut == nil {
                self._toggleCapturingShortcut = self.shortcutFromSettings()
            }
            return self._toggleCapturingShortcut
        }
        set {
            self._toggleCapturingShortcut = self.persistShortcut(newValue)
            self.refreshMenuItems()
        }
    }

    init(settings: any ShortcutSettingsProtocol = ShortcutSettings()) {
        self.settings = settings
        super.init()
    }

    func configureToggleShortcutRecorder(_ recorder: RecorderControl) {
        recorder.delegate = self
        recorder.objectValue = self.toggleCapturingShortcut
    }

    func refreshMenuItems() {
        if let shortcut = self.toggleCapturingShortcut {
            let keyEquivalent = SymbolicKeyCodeTransformer.shared.transformedValue(NSNumber(value: shortcut.keyCode.rawValue)) ?? ""
            self.setKeyEquavalent(keyEquivalent)
            self.setKeyEquivalentModifierMask(shortcut.modifierFlags)
        } else {
            self.setKeyEquavalent("")
            self.setKeyEquivalentModifierMask([])
        }
    }
    
    private func setKeyEquavalent(_ keyEquivalent: String) {
        self.statusShortcutItem?.keyEquivalent = keyEquivalent
        self.dockShortcutItem?.keyEquivalent = keyEquivalent
    }
    
    private func setKeyEquivalentModifierMask(_ modifierFlags: NSEvent.ModifierFlags) {
        self.statusShortcutItem?.keyEquivalentModifierMask = modifierFlags
        self.dockShortcutItem?.keyEquivalentModifierMask = modifierFlags
    }

    // MARK: - Private
    private func shortcutFromSettings() -> Shortcut? {
        guard let data = self.settings.capturingHotKeyData else {
            return ShortcutArchiver.defaultShortcut()
        }
        return ShortcutArchiver.shortcut(from: data) ?? ShortcutArchiver.defaultShortcut()
    }

    private func persistShortcut(_ shortcut: Shortcut?) -> Shortcut? {
        guard let shortcut else {
            self.settings.capturingHotKeyData = nil
            return nil
        }

        do {
            self.settings.capturingHotKeyData = try ShortcutArchiver.data(for: shortcut)
            return shortcut
        } catch {
            return self.shortcutFromSettings()
        }
    }
}

// MARK: - SRRecorderControlDelegate
extension ShortcutManager: RecorderControlDelegate {
    @objc func recorderControlDidEndRecording(_ control: RecorderControl) {
        guard let newShortcut = control.objectValue else {
            self.toggleCapturingShortcut = nil
            return
        }
        self.toggleCapturingShortcut = newShortcut
        control.objectValue = newShortcut
    }
}
