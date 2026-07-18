//
//  KeyboardVisualizer.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

final class KeyboardVisualizer {
    private static let trackedModifierFlags: NSEvent.ModifierFlags = [.command, .shift, .option, .control, .function]

    private let visualizerSettings: KeyboardVisualizerSettings
    private let visualizerWindow: KeyboardVisualizerWindow
    private let eventCoordinator = KeycapEventCoordinator<KeyboardVisualizerGroupView, KeycapItem>()
    private var currentTrackedFlags: NSEvent.ModifierFlags = []
    private var lastTrackedFlags: NSEvent.ModifierFlags = []
    private var hasPendingGroupBreak = false

    convenience init() {
        self.init(store: UserDefaultsStore())
    }

    init(store: KeyValueStore) {
        let settings = KeyboardVisualizerSettings(store: store)
        self.visualizerSettings = settings
        self.visualizerWindow = KeyboardVisualizerWindow(settings: settings)
    }

    func activate() {
        self.visualizerWindow.orderFront(nil)
    }

    func display(_ item: DisplayItem) {
        if item.kind == .flagsChanged {
            self.currentTrackedFlags = item.modifierFlags.intersection(Self.trackedModifierFlags)
            self.displayModifierPreview(item.modifierFlags)
            if self.hasPendingGroupBreak && self.currentTrackedFlags.isEmpty {
                self.finishCurrentGroup(retaining: [])
            }
            return
        }

        if item.kind == .groupBreak {
            if self.currentTrackedFlags.isEmpty {
                self.finishCurrentGroup(retaining: [])
            } else {
                self.hasPendingGroupBreak = true
            }
            return
        }

        guard let sourceEvent = item.sourceEvent else { return }
        switch sourceEvent {
        case .mouse(let mouseEvent):
            guard self.visualizerSettings.showMouseEvents else { return }
            self.prepareForNextContentEvent()

            let modifierItems = KeycapItemFactory.modifierItems(
                currentFlags: mouseEvent.modifierFlags.intersection(Self.trackedModifierFlags),
                releasedFlags: [],
                palette: self.visualizerSettings.palette
            )
            let keycap = KeycapItemFactory.mouseItem(for: mouseEvent, palette: self.visualizerSettings.palette)
            self.eventCoordinator.handleMouseButton(
                kind: mouseEvent.kind,
                isPressed: keycap.isPressed,
                items: modifierItems + [keycap],
                appendGroup: { self.visualizerWindow.appendGroup(with: $0) },
                updateGroup: { group, items in self.visualizerWindow.updateGroup(group, with: items) }
            )
            return

        case .mediaKey(let mediaKey):
            guard self.visualizerSettings.showMediaKeyButtons else { return }
            self.prepareForNextContentEvent()

            let keycap = KeycapItemFactory.mediaKeyItem(for: mediaKey, palette: self.visualizerSettings.palette)
            self.eventCoordinator.handleStandalone(
                items: [keycap],
                appendGroup: { self.visualizerWindow.appendGroup(with: $0) },
                updateGroup: { group, items in self.visualizerWindow.updateGroup(group, with: items) }
            )
            return

        case .keystroke(let keystroke):
            self.displayKeystroke(keystroke)
            return
        }
    }

    private func displayKeystroke(_ keystroke: StandardKeyEvent) {
        // Track command/shift/option/control exclusively through flagsChanged so a modifier
        // release does not create a separate keystroke group after the chord ends.
        if KeyboardGlyphCatalog.isModifierKeyCode(keystroke.keyCode) {
            return
        }

        if self.visualizerSettings.onlyShowModifiedKeystrokes && !keystroke.isModified {
            return
        }

        if !self.visualizerSettings.showSpecialKeys,
           let keyCode = KeyboardKeyCode(rawValue: keystroke.keyCode),
           keyCode.isSpecial {
            return
        }

        let items = KeycapItemFactory.keycapItems(for: keystroke, palette: self.visualizerSettings.palette)
        guard !items.isEmpty else { return }

        self.prepareForNextContentEvent()

        self.eventCoordinator.handleTrackedKey(
            keyCode: keystroke.keyCode,
            isKeyDown: keystroke.type != .keyUp,
            items: items,
            appendGroup: { self.visualizerWindow.appendGroup(with: $0) },
            updateGroup: { group, items in self.visualizerWindow.updateGroup(group, with: items) }
        )
    }

    private func displayModifierPreview(_ modifierFlags: NSEvent.ModifierFlags) {
        let currentTrackedFlags = modifierFlags.intersection(Self.trackedModifierFlags)
        let previousTrackedFlags = self.lastTrackedFlags.intersection(Self.trackedModifierFlags)
        let releasedTrackedFlags = previousTrackedFlags.subtracting(currentTrackedFlags)

        // Caps Lock: one-shot flash, lit when turning on, dim when turning off
        let capsNow = modifierFlags.contains(.capsLock)
        let capsWas = self.lastTrackedFlags.contains(.capsLock)
        if self.visualizerSettings.showSpecialKeys, capsNow != capsWas {
            self.eventCoordinator.handleStandalone(
                items: [KeycapItem(
                    identity: .keyCode(KeyboardKeyCode.capsLock.rawValue),
                    legend: .capsLock,
                    state: KeycapState(isPressed: false, showsDot: true, isDotActive: capsNow),
                    layoutHints: KeycapLayoutHints(alignment: .left),
                    appearance: self.visualizerSettings.palette.appearance(for: .keyCode(KeyboardKeyCode.capsLock.rawValue))
                )],
                appendGroup: { self.visualizerWindow.appendGroup(with: $0) },
                updateGroup: { group, items in self.visualizerWindow.updateGroup(group, with: items) }
            )
        }

        self.lastTrackedFlags = modifierFlags.intersection(Self.trackedModifierFlags.union(.capsLock))

        let items = KeycapItemFactory.modifierItems(
            currentFlags: currentTrackedFlags,
            releasedFlags: releasedTrackedFlags,
            palette: self.visualizerSettings.palette
        )
        guard !items.isEmpty else {
            if currentTrackedFlags.isEmpty {
                self.eventCoordinator.reset()
            }
            return
        }

        self.eventCoordinator.handleFlagsChanged(
            currentTrackedFlags: currentTrackedFlags,
            releasedTrackedFlags: releasedTrackedFlags,
            buildItems: { currentFlags, releasedFlags in
                KeycapItemFactory.modifierItems(
                    currentFlags: currentFlags,
                    releasedFlags: releasedFlags,
                    palette: self.visualizerSettings.palette
                )
            },
            appendGroup: { visualizerWindow.appendGroup(with: $0) },
            updateGroup: { group, items in visualizerWindow.updateGroup(group, with: items) }
        )
    }

    private func prepareForNextContentEvent() {
        guard self.hasPendingGroupBreak else { return }
        self.finishCurrentGroup(retaining: self.currentTrackedFlags)
    }

    private func finishCurrentGroup(retaining trackedFlags: NSEvent.ModifierFlags) {
        self.eventCoordinator.reset()
        self.lastTrackedFlags = trackedFlags
        self.hasPendingGroupBreak = false
    }
}
