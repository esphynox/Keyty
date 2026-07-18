//
//  KeyboardSettingsPaneViewModel+ColorPreset.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

extension KeyboardSettingsPaneViewModel {
    struct ColorPreset: Identifiable {
        static let automaticSelectionID = "__automatic_legend_color__"

        let id = UUID()
        let title: String
        let color: NSColor
    }
}

extension KeyboardSettingsPaneViewModel.ColorPreset {
    static let presets: [Self] = neutralPresets + spectrumPresets

    private static let neutralPresets: [Self] = [
        Self(title: L10n.KeyboardVisualizer.Color.white, color: Color.Theme.Palette.white),
        Self(title: L10n.KeyboardVisualizer.Color.black, color: Color.Theme.Palette.black),
    ]

    private static let spectrumPresets: [Self] = [
        Self(title: L10n.KeyboardVisualizer.Color.red, color: Color.Theme.Palette.red),
        Self(title: L10n.KeyboardVisualizer.Color.orange, color: Color.Theme.Palette.orange),
        Self(title: L10n.KeyboardVisualizer.Color.yellow, color: Color.Theme.Palette.yellow),
        Self(title: L10n.KeyboardVisualizer.Color.green, color: Color.Theme.Palette.green),
        Self(title: L10n.KeyboardVisualizer.Color.blue, color: Color.Theme.Palette.blue),
        Self(title: L10n.KeyboardVisualizer.Color.purple, color: Color.Theme.Palette.purple),
        Self(title: L10n.KeyboardVisualizer.Color.pink, color: Color.Theme.Palette.pink),
    ]
}
