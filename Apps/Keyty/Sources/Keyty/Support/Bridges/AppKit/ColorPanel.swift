//
//  ColorPanel.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

@MainActor
final class ColorPanel: NSObject {
    var onColorChange: ((NSColor) -> Void)?

    func present(initialColor: NSColor) {
        let panel = NSColorPanel.shared
        panel.showsAlpha = true
        panel.setTarget(self)
        panel.setAction(#selector(self.colorDidChange(_:)))
        panel.color = initialColor
        panel.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc
    private func colorDidChange(_ sender: NSColorPanel) {
        self.onColorChange?(sender.color)
    }
}
