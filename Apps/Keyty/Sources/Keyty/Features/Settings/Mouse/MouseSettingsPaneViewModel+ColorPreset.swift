//
//  MouseSettingsPaneViewModel+ColorPreset.swift
//  Keyty
//
//  SPDX-FileCopyrightText: 2026 Serhii Bykov
//  SPDX-License-Identifier: BSD-3-Clause
//

import AppKit
import SwiftUI

extension MouseSettingsPaneViewModel {
    struct ColorPreset: Identifiable {
        let id = UUID()
        let title: String
        let color: NSColor
    }
}

extension MouseSettingsPaneViewModel.ColorPreset {
    static let ringColorPresets: [Self] = automaticRingColorPreset + spectrumColorPresets + neutralRingColorPresets

    static let iconBackgroundColorSections: [[Self]] = [
        translucentNeutralColorPresets,
        translucentSpectrumColorPresets,
    ]

    static let iconTintColorSections: [[Self]] = [
        neutralColorPresets,
        spectrumColorPresets,
    ]

    private static let automaticRingColorPreset: [Self] = [
        Self(title: L10n.Mouse.Color.automatic, color: PointerRingSettingsKeys.automaticVisualizerColor)
    ]

    private static let spectrumColorPresets: [Self] = [
        Self(title: L10n.Mouse.Color.red, color: Color.Theme.Palette.red),
        Self(title: L10n.Mouse.Color.orange, color: Color.Theme.Palette.orange),
        Self(title: L10n.Mouse.Color.yellow, color: Color.Theme.Palette.yellow),
        Self(title: L10n.Mouse.Color.green, color: Color.Theme.Palette.green),
        Self(title: L10n.Mouse.Color.blue, color: Color.Theme.Palette.blue),
        Self(title: L10n.Mouse.Color.purple, color: Color.Theme.Palette.purple),
        Self(title: L10n.Mouse.Color.pink, color: Color.Theme.Palette.pink),
    ]

    private static let neutralRingColorPresets: [Self] = [
        Self(title: L10n.Mouse.Color.graphite, color: Color.Theme.Palette.graphite),
        Self(title: L10n.Mouse.Color.white, color: Color.Theme.Palette.white),
        Self(title: L10n.Mouse.Color.black, color: Color.Theme.Palette.black),
    ]

    private static let neutralColorPresets: [Self] = [
        Self(title: L10n.Mouse.Color.black, color: Color.Theme.Palette.black),
        Self(title: L10n.Mouse.Color.white, color: Color.Theme.Palette.white),
    ]

    private static let translucentNeutralColorPresets: [Self] = [
        Self(title: L10n.Mouse.Color.black, color: Color.Theme.Palette.black60),
        Self(title: L10n.Mouse.Color.white, color: Color.Theme.Palette.white60),
    ]

    private static let translucentSpectrumColorPresets: [Self] = [
        Self(title: L10n.Mouse.Color.red, color: Color.Theme.Palette.red60),
        Self(title: L10n.Mouse.Color.orange, color: Color.Theme.Palette.orange60),
        Self(title: L10n.Mouse.Color.yellow, color: Color.Theme.Palette.yellow60),
        Self(title: L10n.Mouse.Color.green, color: Color.Theme.Palette.green60),
        Self(title: L10n.Mouse.Color.blue, color: Color.Theme.Palette.blue60),
        Self(title: L10n.Mouse.Color.purple, color: Color.Theme.Palette.purple60),
        Self(title: L10n.Mouse.Color.pink, color: Color.Theme.Palette.pink60),
    ]
}
