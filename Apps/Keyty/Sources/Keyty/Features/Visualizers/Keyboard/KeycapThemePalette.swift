//
//  KeycapThemePalette.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit

/// Resolves a `KeycapAppearance` for a keycap based on its semantic category,
/// letting different key types render with different themes while sharing one style.
struct KeycapThemePalette {
    let style: KeycapStyle
    let themes: [KeycapCategory: KeyboardVisualizerTheme]
    let groupBackgroundTheme: KeyboardVisualizerTheme
    let legendColorOverride: NSColor?

    func appearance(for identity: KeycapIdentity) -> KeycapAppearance {
        self.appearance(for: KeycapCategory(identity: identity))
    }

    func appearance(for category: KeycapCategory) -> KeycapAppearance {
        self.theme(for: category).appearance(for: self.style, legendColorOverride: self.legendColorOverride)
    }

    /// Appearance whose group background/stroke colors panel a rendered group.
    var groupAppearance: KeycapAppearance {
        self.groupBackgroundTheme.appearance(for: self.style, legendColorOverride: self.legendColorOverride)
    }

    private func theme(for category: KeycapCategory) -> KeyboardVisualizerTheme {
        self.themes[category] ?? self.themes[.regular] ?? .black
    }
}
